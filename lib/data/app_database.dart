import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../domain/intake_event.dart';
import '../domain/local_date.dart';
import '../domain/medication.dart';

part 'app_database.g.dart';

@UseRowClass(Medication)
class Medications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get dosage => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get createdAt => integer().map(const _UtcTimestampConverter())();

  @override
  List<String> get customConstraints => ['CHECK (length(trim(name)) > 0)'];
}

class MedicationDetails extends Table {
  IntColumn get medicationId =>
      integer().references(Medications, #id, onDelete: KeyAction.cascade)();
  IntColumn get startsOn => integer().map(const _LocalDateConverter())();
  TextColumn get name => text()();
  TextColumn get dosage => text().nullable()();

  @override
  Set<Column> get primaryKey => {medicationId, startsOn};
}

@UseRowClass(MedicationSchedule)
@TableIndex(
  name: 'schedules_by_medication',
  columns: {#medicationId, #startsOn},
)
class MedicationSchedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicationId =>
      integer().references(Medications, #id, onDelete: KeyAction.restrict)();
  IntColumn get recurrence => integer().map(const _RecurrenceConverter())();
  IntColumn get minutesAfterMidnight => integer().nullable()();
  IntColumn get startsOn => integer().map(const _LocalDateConverter())();

  // An equal start and end cancels an upcoming schedule without removing its ID.
  IntColumn get endsBefore =>
      integer().nullable().map(const _LocalDateConverter())();
  TextColumn get label => text().nullable()();
  IntColumn get planId =>
      integer().nullable().references(MedicationSchedules, #id)();

  @override
  List<String> get customConstraints => [
    'CHECK (recurrence BETWEEN 0 AND 127)',
    'CHECK (minutes_after_midnight BETWEEN 0 AND 1439)',
    'CHECK (ends_before >= starts_on)',
  ];
}

@UseRowClass(IntakeEvent)
@TableIndex(
  name: 'events_by_intake',
  columns: {#scheduleId, #scheduledDate, #id},
)
class IntakeEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get scheduleId => integer().references(
    MedicationSchedules,
    #id,
    onDelete: KeyAction.restrict,
  )();
  IntColumn get scheduledDate => integer().map(const _LocalDateConverter())();
  TextColumn get kind => textEnum<IntakeEventKind>()();
  IntColumn get recordedAt => integer().map(const _UtcTimestampConverter())();
  IntColumn get recordedOn =>
      integer().nullable().map(const _LocalDateConverter())();
  IntColumn get reportedIntakeAt =>
      integer().nullable().map(const _UtcTimestampConverter())();

  @override
  List<String> get customConstraints => [
    "CHECK (kind IN ('confirmation', 'correction'))",
    "CHECK (kind = 'confirmation' OR reported_intake_at IS NULL)",
  ];
}

class SlotReminders extends Table {
  IntColumn get scheduleId => integer().references(
    MedicationSchedules,
    #id,
    onDelete: KeyAction.cascade,
  )();
  BoolColumn get enabled => boolean()();
  IntColumn get reminderMinute => integer().nullable()();
  IntColumn get snoozeMinutes => integer()();
  IntColumn get changedAt => integer().map(const _UtcTimestampConverter())();

  @override
  Set<Column> get primaryKey => {scheduleId};

  @override
  List<String> get customConstraints => [
    'CHECK (reminder_minute BETWEEN 0 AND 1439)',
    'CHECK (snooze_minutes BETWEEN 1 AND 120)',
  ];
}

class ReminderOccurrences extends Table {
  IntColumn get scheduleId => integer().references(
    MedicationSchedules,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get scheduledDate => integer().map(const _LocalDateConverter())();
  IntColumn get snoozedUntil =>
      integer().nullable().map(const _UtcTimestampConverter())();
  TextColumn get actionToken => text().nullable()();
  IntColumn get latestEventId => integer()();

  @override
  Set<Column> get primaryKey => {scheduleId, scheduledDate};
}

class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get themeMode => text()();
  TextColumn get accent => text()();
  TextColumn get language => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (id = 1)',
    "CHECK (theme_mode IN ('system', 'light', 'dark'))",
    "CHECK (accent IN ('green', 'blue', 'teal', 'orange', 'purple', 'red'))",
    "CHECK (language IN ('de', 'en'))",
  ];
}

@DriftDatabase(
  tables: [
    Medications,
    MedicationDetails,
    MedicationSchedules,
    IntakeEvents,
    SlotReminders,
    ReminderOccurrences,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  // The initial details apply to every existing occurrence of a medication.
  static const initialDetailsDate = LocalDate.fromEpochDay(-100000000);

  AppDatabase.open()
    : this(
        driftDatabase(
          name: 'medimanager',
          native: DriftNativeOptions(
            setup: (database) {
              // Android's reminder receiver uses a separate SQLite process.
              database.execute('PRAGMA busy_timeout = 2500');
              database.execute('PRAGMA journal_mode = WAL');
            },
          ),
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
            onResult: (result) {
              final storage = result.chosenImplementation;
              if (storage == WasmStorageImplementation.inMemory ||
                  storage == WasmStorageImplementation.unsafeIndexedDb) {
                unawaited(result.resolvedExecutor.close());
                throw UnsupportedError(
                  'Reliable browser storage is unavailable',
                );
              }
            },
          ),
        ),
      );

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 1 || from > 4 || to != 5) {
        throw UnsupportedError('Unsupported database migration $from to $to');
      }
      await transaction(() async {
        if (from == 1) {
          await m.createTable(medicationDetails);
          await customStatement(
            '''
            INSERT INTO medication_details (medication_id, starts_on, name, dosage)
            SELECT id, ?, name, dosage FROM medications
            ''',
            [initialDetailsDate.epochDay],
          );
          await m.addColumn(intakeEvents, intakeEvents.recordedOn);
        }
        if (from < 3) await m.createTable(reminderOccurrences);
        if (from < 4) {
          await m.addColumn(medicationSchedules, medicationSchedules.label);
          await m.createTable(slotReminders);
          await m.createTable(appSettings);
        }
        if (from == 3) {
          await customStatement('''
            INSERT INTO slot_reminders
              (schedule_id, enabled, reminder_minute, snooze_minutes, changed_at)
            SELECT s.id, r.enabled, r.reminder_minute, r.snooze_minutes, r.changed_at
            FROM medication_reminders r
            JOIN medication_schedules s ON s.medication_id = r.medication_id
            ''');
          await customStatement('DROP TABLE medication_reminders');
        }
        await m.addColumn(medicationSchedules, medicationSchedules.planId);
      });
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA secure_delete = ON');
    },
  );

  Expression<bool> detailsOn(
    Expression<int> medicationId,
    Expression<int> day,
  ) {
    final earlier = alias(medicationDetails, 'earlier_details');
    final latest = selectOnly(earlier)
      ..addColumns([earlier.startsOn])
      ..where(
        earlier.medicationId.equalsExp(medicationId) &
            earlier.startsOn.isSmallerOrEqual(day),
      )
      ..orderBy([OrderingTerm.desc(earlier.startsOn)])
      ..limit(1);
    return medicationDetails.medicationId.equalsExp(medicationId) &
        medicationDetails.startsOn.equalsExp(subqueryExpression(latest));
  }
}

class _LocalDateConverter extends TypeConverter<LocalDate, int> {
  const _LocalDateConverter();

  @override
  LocalDate fromSql(int fromDb) => LocalDate.fromEpochDay(fromDb);

  @override
  int toSql(LocalDate value) => value.epochDay;
}

class _UtcTimestampConverter extends TypeConverter<DateTime, int> {
  const _UtcTimestampConverter();

  @override
  DateTime fromSql(int fromDb) =>
      DateTime.fromMicrosecondsSinceEpoch(fromDb, isUtc: true);

  @override
  int toSql(DateTime value) => value.microsecondsSinceEpoch;
}

class _RecurrenceConverter extends TypeConverter<Recurrence, int> {
  const _RecurrenceConverter();

  @override
  Recurrence fromSql(int fromDb) => Recurrence.fromMask(fromDb);

  @override
  int toSql(Recurrence value) => value.weekdayMask;
}
