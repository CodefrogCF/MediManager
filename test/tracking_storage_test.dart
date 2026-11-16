import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medimanager/data/app_database.dart';
import 'package:medimanager/data/intake_repository.dart';
import 'package:medimanager/data/medication_repository.dart';
import 'package:medimanager/domain/intake_event.dart';
import 'package:medimanager/domain/local_date.dart';
import 'package:medimanager/domain/medication.dart';

void main() {
  test(
    'v1 upgrade keeps schedule IDs, inactive medications and all events',
    () async {
      final json = jsonDecode(
        await File('drift_schemas/drift_schema_v1.json').readAsString(),
      ) as Map<String, dynamic>;
      final directory = await Directory.systemTemp.createTemp(
        'medimanager-v1-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/legacy.sqlite');
      final friday = LocalDate.fromDateTime(DateTime(2026, 3, 27));
      final time = DateTime.utc(2026, 3, 27, 18, 4);
      final reported = time.subtract(const Duration(minutes: 5));
      final db = AppDatabase(
        NativeDatabase(
          file,
          setup: (raw) {
            for (final entity in json['fixed_sql'] as List<dynamic>) {
              raw.execute(
                (entity['sql'] as List<dynamic>).single['sql'] as String,
              );
            }
            raw.execute('PRAGMA user_version = 1');
            raw.execute('INSERT INTO medications VALUES (7, ?, ?, 0, ?)', [
              'Vitamin D',
              '1 Tablette',
              time.microsecondsSinceEpoch,
            ]);
            raw.execute(
              'INSERT INTO medication_schedules VALUES (11, 7, 16, 1080, ?, ?)',
              [friday.epochDay, friday.plusDays(1).epochDay],
            );
            raw.execute(
              'INSERT INTO intake_events VALUES (17, 11, ?, ?, ?, ?)',
              [
                friday.epochDay,
                'confirmation',
                time.microsecondsSinceEpoch,
                reported.microsecondsSinceEpoch,
              ],
            );
            raw.execute(
              'INSERT INTO intake_events VALUES (18, 11, ?, ?, ?, NULL)',
              [
                friday.epochDay,
                'correction',
                time.add(const Duration(minutes: 1)).microsecondsSinceEpoch,
              ],
            );
          },
        ),
      );
      addTearDown(db.close);
      final monday = DateTime(2026, 3, 30, 10);
      final medications = MedicationRepository(db, now: () => monday);
      final intakes = IntakeRepository(db, now: () => monday);
      final entry = (await medications.watchDailyIntakes(friday).first).single;
      expect(entry.medication.id, 7);
      expect(entry.medication.isActive, isFalse);
      expect(entry.details.name, 'Vitamin D');
      expect(entry.details.dosage, '1 Tablette');
      expect(entry.intake, (scheduleId: 11, scheduledDate: friday));
      expect(entry.latestEvent!.id, 18);
      expect(entry.latestEvent!.isConfirmation, isFalse);
      final events = await intakes.historyFor(entry.intake);
      expect(events.map((event) => event.id), [17, 18]);
      expect(events.first.recordedAt, time);
      expect(events.first.reportedIntakeAt, reported);
      expect(events.every((event) => event.recordedOn == null), isTrue);
      expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);

      final newEvent = await intakes.confirm(entry.intake);
      expect(newEvent, greaterThan(18));
      final latest = (await intakes.historyFor(entry.intake)).last;
      expect(latest.recordedOn, medications.today);
      expect(latest.isRetrospective, isTrue);
      expect(
        (await db.customSelect('PRAGMA user_version').getSingle()).read<int>(
          'user_version',
        ),
        2,
      );
    },
  );

  test('past details, scheduled time and confirmation survive edits and deactivation', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    var now = DateTime(2026, 3, 27, 18);
    final medications = MedicationRepository(db, now: () => now);
    final intakes = IntakeRepository(db, now: () => now);
    final friday = medications.today;
    final sunday = friday.plusDays(2);
    final medicationId = await medications.createMedication(
      name: 'Vitamin D',
      dosage: '1 Tablette',
    );
    final schedule = await medications.saveSchedule(
      medicationId: medicationId,
      recurrence: const Recurrence.daily(),
      minutesAfterMidnight: 1080,
      startsOn: friday,
      endsBefore: null,
    );
    final intake = (scheduleId: schedule, scheduledDate: friday);
    final original = await intakes.confirm(intake);
    now = DateTime(2026, 3, 28, 12);
    await medications.updateMedication(medicationId, name: 'Vitamin D neu');
    final updatedSchedule = await medications.saveSchedule(
      medicationId: medicationId,
      replacesScheduleId: schedule,
      recurrence: const Recurrence.daily(),
      minutesAfterMidnight: 480,
      startsOn: sunday,
      endsBefore: null,
    );
    now = DateTime(2026, 3, 30, 12);
    await medications.setActive(medicationId, false);

    final old = (await medications.watchDailyIntakes(friday).first).single;
    expect(old.details.name, 'Vitamin D');
    expect(old.details.dosage, '1 Tablette');
    expect(old.schedule.minutesAfterMidnight, 1080);
    expect(old.latestEvent!.id, original);
    expect(old.medication.isActive, isFalse);
    final newDay = (await medications.watchDailyIntakes(sunday).first).single;
    expect(newDay.details.name, 'Vitamin D neu');
    expect(newDay.details.dosage, isNull);
    expect(newDay.schedule.id, updatedSchedule);
    expect(newDay.schedule.minutesAfterMidnight, 480);
    expect(newDay.latestEvent, isNull);
    expect(
      await medications.watchDailyIntakes(medications.today.plusDays(1)).first,
      isEmpty,
    );

    final correction = intakes.correct(
      intake,
      expectedConfirmationId: original,
    );
    final duplicate = intakes.correct(intake, expectedConfirmationId: original);
    await Future.wait([correction, expectLater(duplicate, throwsStateError)]);
    final corrected =
        (await medications.watchDailyIntakes(friday).first).single.latestEvent!;
    expect(corrected.kind, IntakeEventKind.correction);
    final confirmation = await intakes.confirm(intake);
    await expectLater(
      intakes.correct(intake, expectedConfirmationId: original),
      throwsStateError,
    );
    final latest =
        (await medications.watchDailyIntakes(friday).first).single.latestEvent!;
    expect(latest.id, confirmation);
    expect(latest.isRetrospective, isTrue);
    expect(await intakes.historyFor(intake), hasLength(3));
  });
}
