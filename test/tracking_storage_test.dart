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
        5,
      );
    },
  );

  test(
    'v4 upgrade preserves independent schedules and their reminder settings',
    () async {
      final v4 = jsonDecode(
        await File('drift_schemas/drift_schema_v4.json').readAsString(),
      ) as Map<String, dynamic>;
      final now = DateTime(2026, 3, 27, 12);
      final date = LocalDate.fromDateTime(now);
      final db = AppDatabase(
        NativeDatabase.memory(
          setup: (raw) {
            for (final entity in v4['fixed_sql'] as List<dynamic>) {
              raw.execute(
                (entity['sql'] as List<dynamic>).single['sql'] as String,
              );
            }
            raw.execute('PRAGMA user_version = 4');
            raw.execute(
              "INSERT INTO medications VALUES (7, 'Vitamin D', NULL, 1, 0)",
            );
            raw.execute(
              "INSERT INTO medication_details VALUES (7, -100000000, 'Vitamin D', NULL)",
            );
            raw.execute(
              '''INSERT INTO medication_schedules VALUES
           (11, 7, 0, 480, ?, NULL, 'Morgens'),
           (12, 7, 0, 480, ?, NULL, 'Morgens')''',
              [date.epochDay, date.epochDay],
            );
            raw.execute(
              'INSERT INTO slot_reminders VALUES (11, 1, 465, 10, 0)',
            );
            raw.execute(
              '''INSERT INTO intake_events
           (id, schedule_id, scheduled_date, kind, recorded_at, recorded_on)
           VALUES (17, 11, ?, 'confirmation', ?, ?)''',
              [date.epochDay, now.microsecondsSinceEpoch, date.epochDay],
            );
          },
        ),
      );
      addTearDown(db.close);
      final medications = MedicationRepository(db, now: () => now);
      final original = await medications.watchDailyIntakes(date).first;
      expect(original.map((slot) => slot.schedule.logicalId), [11, 12]);
      expect(original.first.latestEvent?.id, 17);
      expect(original.first.reminder?.reminderMinute, 465);
      final revised = await medications.saveSchedule(
        medicationId: 7,
        replacesScheduleId: 11,
        recurrence: const Recurrence.daily(),
        minutesAfterMidnight: 540,
        startsOn: date.plusDays(1),
        endsBefore: null,
        label: 'Morgens',
      );
      final plans = await medications.watchPlans(7).first;
      expect(plans.map((plan) => plan.schedule.logicalId), [11, 12]);
      expect(plans.first.schedule.id, revised);
      expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
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
