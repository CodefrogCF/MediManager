import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

import '../domain/local_date.dart';
import '../domain/medication.dart';
import 'app_database.dart';

enum BackupProblem { invalid, unsupported, tooLarge }

final class BackupException implements Exception {
  const BackupException(this.problem);

  final BackupProblem problem;
}

typedef _Row = Map<String, Object?>;
typedef _Tables = Map<String, List<_Row>>;

final class BackupPreview {
  BackupPreview._(this.exportedAt, this._tables);

  final DateTime exportedAt;
  final _Tables _tables;
  int get medicationCount => _tables['medications']!.length;
  int get eventCount => _tables['intake_events']!.length;
}

final class BackupRepository {
  BackupRepository(this._db, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  static const maxBytes = 32 * 1024 * 1024;
  static const _format = 'medimanager-backup';
  static const _version = 2;
  static const _invalid = BackupException(BackupProblem.invalid);

  final AppDatabase _db;
  final DateTime Function() _now;

  Future<Uint8List> export() async {
    final tables = await _db.transaction(() async {
      final result = <String, List<_Row>>{};
      for (final table in _schema.entries) {
        final columns = table.value.fields.keys.join(', ');
        final rows = await _db
            .customSelect(
              'SELECT $columns FROM ${table.key} ORDER BY ${table.value.key.join(', ')}',
            )
            .get();
        result[table.key] = [
          for (final row in rows)
            {
              for (final field in table.value.fields.entries)
                field.key: field.value.encode(row.data[field.key]),
            },
        ];
      }
      return result;
    });
    final payload = {
      'exported_at': _toTimestamp(_now().microsecondsSinceEpoch),
      'tables': tables,
    };
    final bytes = Uint8List.fromList(
      utf8.encode(
        const JsonEncoder.withIndent('  ').convert({
          'format': _format,
          'version': _version,
          'sha256': _digest(payload),
          'payload': payload,
        }),
      ),
    );
    checkSize(bytes.length);
    return bytes;
  }

  static void checkSize(int bytes) {
    if (bytes > maxBytes) throw const BackupException(BackupProblem.tooLarge);
  }

  BackupPreview inspect(Uint8List bytes) {
    checkSize(bytes.length);
    try {
      final envelope = _object(jsonDecode(utf8.decode(bytes)));
      if (envelope['format'] != _format || envelope['version'] is! int) {
        throw _invalid;
      }
      final version = envelope['version'];
      if (version != 1 && version != _version) {
        throw const BackupException(BackupProblem.unsupported);
      }
      _keys(envelope, const ['format', 'version', 'sha256', 'payload']);
      final payload = _object(envelope['payload']);
      if (envelope['sha256'] != _digest(payload)) throw _invalid;
      _keys(payload, const ['exported_at', 'tables']);
      final exportedAt = _fromTimestamp(payload['exported_at']);
      final source = _object(payload['tables']);
      _keys(source, _schema.keys);
      final tables = <String, List<_Row>>{
        for (final table in _schema.entries)
          table.key: _readRows(
            source[table.key],
            table.value,
            legacySchedules:
                version == 1 && table.key == 'medication_schedules',
          ),
      };
      _validateRelationships(tables);
      return BackupPreview._(
        DateTime.fromMicrosecondsSinceEpoch(exportedAt, isUtc: true),
        tables,
      );
    } on FormatException {
      throw _invalid;
    } on RangeError {
      throw _invalid;
    }
  }

  Future<void> restore(BackupPreview backup) => _db.transaction(() async {
    await _clearTables();
    await _db.batch((batch) {
      for (final table in _schema.entries) {
        final columns = table.value.fields.keys;
        final placeholders = List.filled(columns.length, '?').join(', ');
        for (final row in backup._tables[table.key]!) {
          batch.customStatement(
            'INSERT INTO ${table.key} (${columns.join(', ')}) VALUES ($placeholders)',
            columns.map((column) => row[column]).toList(),
            [TableUpdate(table.key, kind: UpdateKind.insert)],
          );
        }
      }
    });
    if ((await _db.customSelect('PRAGMA foreign_key_check').get()).isNotEmpty) {
      throw _invalid;
    }
  });

  Future<void> deleteAll() => _db.transaction(_clearTables);

  Future<void> _clearTables() async {
    // Invalidate local delivery state and notification action tokens on restore.
    await _db.delete(_db.reminderOccurrences).go();
    await _db.delete(_db.slotReminders).go();
    await _db.delete(_db.intakeEvents).go();
    await _db.delete(_db.medicationSchedules).go();
    await _db.delete(_db.medicationDetails).go();
    await _db.delete(_db.medications).go();
    await _db.delete(_db.appSettings).go();
  }

  static List<_Row> _readRows(
    Object? value,
    _Table table, {
    required bool legacySchedules,
  }) {
    if (value is! List) throw _invalid;
    final keys = <String>{};
    return value.map((item) {
      final data = _object(item);
      final fields = table.fields.keys;
      _keys(
        data,
        legacySchedules ? fields.where((key) => key != 'plan_id') : fields,
      );
      final row = <String, Object?>{
        for (final field in table.fields.entries)
          field.key: field.value.decode(data[field.key]),
      };
      final key = table.key.map((column) => row[column]).join('/');
      if (!keys.add(key)) throw _invalid;
      return row;
    }).toList();
  }

  static void _validateRelationships(_Tables tables) {
    final medications = {
      for (final row in tables['medications']!) row['id'] as int,
    };
    final firstDetails = <int, int>{};
    for (final row in tables['medication_details']!) {
      final medication = row['medication_id'] as int;
      final start = row['starts_on'] as int;
      if (!medications.contains(medication)) throw _invalid;
      final first = firstDetails[medication];
      if (first == null || start < first) firstDetails[medication] = start;
    }
    if (firstDetails.length != medications.length) throw _invalid;

    final schedules = <int, MedicationSchedule>{};
    final scheduleRows = tables['medication_schedules']!
      ..sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
    final latestVersions = <int, MedicationSchedule>{};
    for (final row in scheduleRows) {
      final id = row['id'] as int;
      final medication = row['medication_id'] as int;
      final start = row['starts_on'] as int;
      final end = row['ends_before'] as int?;
      final first = firstDetails[medication];
      if (first == null || first > start || (end != null && end < start)) {
        throw _invalid;
      }
      final planId = row['plan_id'] as int?;
      final schedule = MedicationSchedule(
        id: id,
        medicationId: medication,
        planId: planId,
        recurrence: Recurrence.fromMask(row['recurrence'] as int),
        minutesAfterMidnight: row['minutes_after_midnight'] as int?,
        startsOn: LocalDate.fromEpochDay(start),
        endsBefore: end == null ? null : LocalDate.fromEpochDay(end),
      );
      if (planId != null) {
        final original = schedules[planId];
        final previousEnd = latestVersions[planId]?.endsBefore;
        if (original?.planId != null ||
            original?.medicationId != medication ||
            previousEnd == null ||
            schedule.startsOn.isBefore(previousEnd)) {
          throw _invalid;
        }
      }
      schedules[id] = schedule;
      latestVersions[schedule.logicalId] = schedule;
    }

    final confirmed = <(int, int)>{};
    final events = tables['intake_events']!
      ..sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
    for (final row in events) {
      final schedule = row['schedule_id'] as int;
      final date = row['scheduled_date'] as int;
      final recordedOn = row['recorded_on'] as int?;
      final key = (schedule, date);
      final confirmation = row['kind'] == 'confirmation';
      if (schedules[schedule]?.occursOn(LocalDate.fromEpochDay(date)) != true ||
          (confirmation && recordedOn != null && recordedOn < date) ||
          (!confirmation && row['reported_intake_at'] != null) ||
          !(confirmation ? confirmed.add(key) : confirmed.remove(key))) {
        throw _invalid;
      }
    }
    for (final row in tables['slot_reminders']!) {
      if (!schedules.containsKey(row['schedule_id'])) throw _invalid;
    }
  }

  static _Row _object(Object? value) => value is _Row ? value : throw _invalid;

  static void _keys(_Row object, Iterable<String> expected) {
    if (object.length != expected.length ||
        !expected.every(object.containsKey)) {
      throw _invalid;
    }
  }

  static String _digest(Object? payload) =>
      sha256.convert(utf8.encode(jsonEncode(payload))).toString();
}

typedef _Table = ({List<String> key, Map<String, _Field> fields});

const _schema = <String, _Table>{
  'medications': (
    key: ['id'],
    fields: {
      'id': _Field.id,
      'name': _Field.nonEmpty,
      'dosage': _Field.text,
      'is_active': _Field.boolean,
      'created_at': _Field.timestamp,
    },
  ),
  'medication_details': (
    key: ['medication_id', 'starts_on'],
    fields: {
      'medication_id': _Field.id,
      'starts_on': _Field.date,
      'name': _Field.nonEmpty,
      'dosage': _Field.text,
    },
  ),
  'medication_schedules': (
    key: ['id'],
    fields: {
      'id': _Field.id,
      'medication_id': _Field.id,
      'recurrence': _Field.recurrence,
      'minutes_after_midnight': _Field.minute,
      'starts_on': _Field.date,
      'ends_before': _Field.optionalDate,
      'label': _Field.text,
      'plan_id': _Field.optionalId,
    },
  ),
  'intake_events': (
    key: ['id'],
    fields: {
      'id': _Field.id,
      'schedule_id': _Field.id,
      'scheduled_date': _Field.date,
      'kind': _Field.eventKind,
      'recorded_at': _Field.timestamp,
      'recorded_on': _Field.optionalDate,
      'reported_intake_at': _Field.optionalTimestamp,
    },
  ),
  'slot_reminders': (
    key: ['schedule_id'],
    fields: {
      'schedule_id': _Field.id,
      'enabled': _Field.boolean,
      'reminder_minute': _Field.minute,
      'snooze_minutes': _Field.snooze,
      'changed_at': _Field.timestamp,
    },
  ),
  'app_settings': (
    key: ['id'],
    fields: {
      'id': _Field.singleton,
      'theme_mode': _Field.theme,
      'accent': _Field.accent,
      'language': _Field.language,
    },
  ),
};

enum _Field {
  id,
  optionalId,
  singleton,
  text,
  nonEmpty,
  boolean,
  date,
  optionalDate,
  timestamp,
  optionalTimestamp,
  recurrence,
  minute,
  snooze,
  eventKind,
  theme,
  accent,
  language;

  Object? encode(Object? value) => switch (this) {
    boolean => value == 1,
    date || optionalDate => value == null ? null : _toDate(value as int),
    timestamp ||
    optionalTimestamp => value == null ? null : _toTimestamp(value as int),
    _ => value,
  };

  Object? decode(Object? value) => switch ((this, value)) {
    (id || optionalId, int n) when n > 0 && n <= _maxSafeInteger => n,
    (singleton, 1) => 1,
    (text, String s) => s,
    (nonEmpty, String s) when s.trim().isNotEmpty => s,
    (boolean, bool b) => b ? 1 : 0,
    (date || optionalDate, String day) => _fromDate(day),
    (timestamp || optionalTimestamp, String time) => _fromTimestamp(time),
    (recurrence, int n) when n >= 0 && n <= 127 => n,
    (minute, int n) when n >= 0 && n < 1440 => n,
    (snooze, int n) when n >= 1 && n <= 120 => n,
    (eventKind, 'confirmation' || 'correction') => value,
    (theme, 'system' || 'light' || 'dark') => value,
    (accent, 'green' || 'blue' || 'teal' || 'orange' || 'purple' || 'red') =>
      value,
    (language, 'de' || 'en') => value,
    (optionalId || text || optionalDate || optionalTimestamp || minute, null) =>
      null,
    _ => throw BackupRepository._invalid,
  };
}

const _maxSafeInteger = 9007199254740991;

String _toDate(int day) =>
    LocalDate.fromEpochDay(day).calendarDate.toIso8601String().split('T').first;

int _fromDate(String value) {
  final date = DateTime.parse('${value}T00:00:00Z');
  final day = LocalDate.fromDateTime(date).epochDay;
  if (_toDate(day) != value) throw BackupRepository._invalid;
  return day;
}

// Dart's web DateTime drops sub-millisecond precision. Keep it in portable
// SQLite integers while rendering all timestamps as readable UTC ISO strings.
String _toTimestamp(int micros) {
  final remainder = micros % 1000;
  final millis = (micros - remainder) ~/ 1000;
  final iso = DateTime.fromMillisecondsSinceEpoch(
    millis,
    isUtc: true,
  ).toIso8601String();
  return '${iso.substring(0, iso.length - 1)}'
      '${remainder.toString().padLeft(3, '0')}Z';
}

int _fromTimestamp(Object? value) {
  if (value is! String || value.length < 27 || !value.endsWith('Z')) {
    throw BackupRepository._invalid;
  }
  final end = value.length - 4;
  final remainder = int.parse(value.substring(end, end + 3));
  final date = DateTime.parse('${value.substring(0, end)}Z');
  final micros = date.millisecondsSinceEpoch * 1000 + remainder;
  if (micros.abs() > _maxSafeInteger || _toTimestamp(micros) != value) {
    throw BackupRepository._invalid;
  }
  return micros;
}
