import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medimanager/data/app_database.dart';
import 'package:medimanager/data/backup_repository.dart';
import 'package:medimanager/data/intake_repository.dart';
import 'package:medimanager/data/medication_repository.dart';
import 'package:medimanager/data/reminder_repository.dart';
import 'package:medimanager/data/settings_repository.dart';
import 'package:medimanager/domain/intake_event.dart';
import 'package:medimanager/domain/medication.dart';

void main() {
  test(
    'portable backup round-trips slots, historical context, and corrections',
    () async {
      final source = AppDatabase(NativeDatabase.memory());
      final destination = AppDatabase(NativeDatabase.memory());
      addTearDown(source.close);
      addTearDown(destination.close);
      var clock = DateTime(2026, 4, 3, 8, 1, 2, 123, 456);
      final meds = MedicationRepository(source, now: () => clock);
      final intakes = IntakeRepository(source, now: () => clock);
      final friday = meds.today;
      final id = await meds.createMedication(
        name: 'Vitamin D',
        dosage: '1 Tropfen',
      );
      final morning = await meds.saveSchedule(
        medicationId: id,
        recurrence: const Recurrence.daily(),
        minutesAfterMidnight: 480,
        startsOn: friday,
        endsBefore: null,
        label: 'Morgens',
      );
      final evening = await meds.saveSchedule(
        medicationId: id,
        recurrence: const Recurrence.daily(),
        minutesAfterMidnight: 1080,
        startsOn: friday,
        endsBefore: null,
        label: 'Abends',
      );
      await ReminderRepository(
        source,
        now: () => clock,
      ).save(evening, enabled: true, reminderMinute: 1065, snoozeMinutes: 15);
      final occurrence = (scheduleId: morning, scheduledDate: friday);
      await intakes.confirm(occurrence);
      final onFriday = await meds.watchDailyIntakes(friday).first;
      expect(onFriday.map((slot) => slot.latestEvent?.isConfirmation), [
        true,
        null,
      ]);
      await intakes.correct(occurrence);
      clock = DateTime(2026, 4, 4, 9);
      await intakes.confirm(
        occurrence,
        reportedIntakeAt: DateTime(2026, 4, 3, 8),
      );
      await meds.updateMedication(id, name: 'Vitamin D3', dosage: '2 Tropfen');
      final replacement = await meds.saveSchedule(
        medicationId: id,
        replacesScheduleId: evening,
        recurrence: const Recurrence.daily(),
        minutesAfterMidnight: 1200,
        startsOn: friday.plusDays(2),
        endsBefore: null,
        label: 'Spät',
      );
      expect(
        (await ReminderRepository(
          source,
        ).watch(replacement).first)!.reminderMinute,
        1065,
      );
      clock = DateTime(2026, 4, 6, 9);
      await meds.setActive(id, false);
      await SettingsRepository(source)
          .save(themeMode: 'dark', accent: 'teal', language: 'en');
      await source.customStatement(
        'INSERT INTO reminder_occurrences VALUES (?, ?, NULL, ?, 0)',
        [evening, friday.epochDay, 'private-device-token'],
      );
      final bytes = await BackupRepository(source, now: () => clock).export();
      final readable = utf8.decode(bytes);
      expect(readable, contains('2026-04-03'));
      expect(readable, contains('123456Z'));
      expect(readable, contains('1 Tropfen'));
      expect(readable, isNot(contains('private-device-token')));

      final restored = BackupRepository(destination, now: () => clock);
      final preview = restored.inspect(bytes);
      expect(preview.medicationCount, 1);
      expect(preview.eventCount, 3);
      await restored.restore(preview);
      expect(await restored.export(), bytes);
      expect(
        await destination.select(destination.reminderOccurrences).get(),
        isEmpty,
      );
      expect(
        (await SettingsRepository(destination).watch.first)!.language,
        'en',
      );

      final archived = await MedicationRepository(destination)
          .watchDailyIntakes(friday)
          .first;
      expect(archived.map((slot) => slot.schedule.label), [
        'Morgens',
        'Abends',
      ]);
      expect(archived.map((slot) => slot.schedule.minutesAfterMidnight), [
        480,
        1080,
      ]);
      expect(archived.map((slot) => slot.latestEvent?.isConfirmation), [
        true,
        null,
      ]);
      expect(
        archived.every(
          (slot) =>
              slot.details.name == 'Vitamin D' &&
              slot.details.dosage == '1 Tropfen' &&
              !slot.medication.isActive,
        ),
        isTrue,
      );
      final archive = await IntakeRepository(destination)
          .watchForMedication(id)
          .first;
      expect(archive.map((entry) => entry.event.kind), [
        IntakeEventKind.confirmation,
        IntakeEventKind.correction,
        IntakeEventKind.confirmation,
      ]);
      expect(
        archive.every((entry) => entry.details.name == 'Vitamin D'),
        isTrue,
      );
      expect(
        archive.first.event.reportedIntakeAt,
        DateTime(2026, 4, 3, 8).toUtc(),
      );
    },
  );

  test(
    'rejects corrupt, unsupported, duplicate and orphaned rows before restore',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final meds = MedicationRepository(db);
      final repository = BackupRepository(db);
      await meds.createMedication(name: 'Original');
      final bytes = await repository.export();
      Map<String, dynamic> envelope() =>
          jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      Matcher fails(BackupProblem problem) => throwsA(
        isA<BackupException>().having(
          (error) => error.problem,
          'problem',
          problem,
        ),
      );

      expect(
        () => repository.inspect(Uint8List.fromList([0xFF])),
        fails(BackupProblem.invalid),
      );
      expect(
        () => BackupRepository.checkSize(BackupRepository.maxBytes + 1),
        fails(BackupProblem.tooLarge),
      );
      expect(
        () => repository.inspect(_encode(envelope()..['version'] = 2)),
        fails(BackupProblem.unsupported),
      );
      expect(
        () => repository.inspect(_encode(envelope()..['sha256'] = 'bad')),
        fails(BackupProblem.invalid),
      );

      final duplicate = envelope();
      final rows = duplicate['payload']['tables']['medications'] as List;
      rows.add(rows.single);
      expect(
        () => repository.inspect(_signed(duplicate)),
        fails(BackupProblem.invalid),
      );

      final orphan = envelope();
      orphan['payload']['tables']['medication_details'][0]['medication_id'] =
          999;
      expect(
        () => repository.inspect(_signed(orphan)),
        fails(BackupProblem.invalid),
      );
      expect((await meds.watchMedications().first).single.name, 'Original');
    },
  );

  test('a failed restore preserves existing data and successful deletion clears it', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final meds = MedicationRepository(db);
    final repository = BackupRepository(db);
    await meds.createMedication(name: 'In backup');
    final backup = repository.inspect(await repository.export());
    await repository.deleteAll();
    await meds.createMedication(name: 'On device');
    await SettingsRepository(db).save(language: 'en');
    await db.customStatement("""
      CREATE TRIGGER test_reject_import BEFORE INSERT ON medications
      WHEN NEW.name = 'In backup' BEGIN
        SELECT RAISE(ABORT, 'test: failed import');
      END
      """);
    await expectLater(repository.restore(backup), throwsException);
    expect((await meds.watchMedications().first).single.name, 'On device');
    expect((await SettingsRepository(db).watch.first)?.language, 'en');
    await repository.deleteAll();
    expect(await meds.watchMedications().first, isEmpty);
    expect(await SettingsRepository(db).watch.first, isNull);
    expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
  });
}

Uint8List _encode(Map<String, dynamic> envelope) =>
    Uint8List.fromList(utf8.encode(jsonEncode(envelope)));

Uint8List _signed(Map<String, dynamic> envelope) {
  envelope['sha256'] = sha256
      .convert(utf8.encode(jsonEncode(envelope['payload'])))
      .toString();
  return _encode(envelope);
}
