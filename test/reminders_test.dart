import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medimanager/data/android_reminders.dart';
import 'package:medimanager/data/app_database.dart';
import 'package:medimanager/data/intake_repository.dart';
import 'package:medimanager/data/medication_repository.dart';
import 'package:medimanager/data/reminder_repository.dart';
import 'package:medimanager/domain/medication.dart';
import 'package:medimanager/main.dart';

void main() {
  test(
    'v2 upgrade keeps plans and intake history with reminders off',
    () async {
      final json = jsonDecode(
        await File('drift_schemas/drift_schema_v2.json').readAsString(),
      ) as Map<String, dynamic>;
      final db = AppDatabase(
        NativeDatabase.memory(
          setup: (raw) {
            for (final entity in json['fixed_sql'] as List<dynamic>) {
              raw.execute(
                (entity['sql'] as List<dynamic>).single['sql'] as String,
              );
            }
            raw.execute('PRAGMA user_version = 2');
            raw.execute(
              "INSERT INTO medications VALUES (7, 'Vitamin D', NULL, 1, 0)",
            );
            raw.execute(
              "INSERT INTO medication_details VALUES (7, 20400, 'Vitamin D', NULL)",
            );
            raw.execute(
              'INSERT INTO medication_schedules VALUES (11, 7, 0, 480, 20400, NULL)',
            );
            raw.execute('''
        INSERT INTO intake_events (id, schedule_id, scheduled_date, kind, recorded_at)
        VALUES (12, 11, 20401, 'confirmation', 1762704000000000)
        ''');
          },
        ),
      );
      addTearDown(db.close);
      expect(
        (await db.customSelect('PRAGMA user_version').getSingle()).read<int>(
          'user_version',
        ),
        4,
      );
      expect((await db.select(db.medications).getSingle()).name, 'Vitamin D');
      expect((await db.select(db.medicationSchedules).getSingle()).id, 11);
      expect((await db.select(db.intakeEvents).getSingle()).id, 12);
      expect(await db.select(db.slotReminders).get(), isEmpty);
      expect(await db.select(db.reminderOccurrences).get(), isEmpty);
      expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
    },
  );

  test('preferences are independent and leave the intake log alone', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    var now = DateTime(2026, 11, 16, 8);
    final meds = MedicationRepository(db, now: () => now);
    final reminders = ReminderRepository(db, now: () => now);
    final medication = await meds.createMedication(name: 'Vitamin D');
    final date = meds.today;
    final a = await meds.saveSchedule(
      medicationId: medication,
      recurrence: Recurrence.weekly({DateTime.monday, DateTime.thursday}),
      minutesAfterMidnight: 1080,
      startsOn: date,
      endsBefore: null,
      label: 'Abends',
    );
    final b = await meds.saveSchedule(
      medicationId: medication,
      recurrence: Recurrence.weekly({DateTime.monday, DateTime.thursday}),
      minutesAfterMidnight: 480,
      startsOn: date,
      endsBefore: null,
      label: 'Morgens',
    );
    expect(await reminders.watch(a).first, isNull);
    await reminders.save(
      a,
      enabled: true,
      reminderMinute: 1050,
      snoozeMinutes: 15,
    );
    now = DateTime(2026, 11, 16, 9);
    await reminders.save(
      a,
      enabled: true,
      reminderMinute: 1050,
      snoozeMinutes: 30,
    );
    final planned = (await meds.watchDailyIntakes(date).first).singleWhere(
      (entry) => entry.schedule.id == a,
    );
    expect(planned.reminder!.enabled, isTrue);
    expect(planned.reminder!.reminderMinute, 1050);
    expect(planned.reminder!.snoozeMinutes, 30);
    expect(planned.reminder!.changedAt, DateTime(2026, 11, 16, 8).toUtc());
    expect(await reminders.watch(b).first, isNull);
    expect(await meds.watchDailyIntakes(date.plusDays(1)).first, isEmpty);
    expect(planned.latestEvent, isNull);

    await reminders.save(
      a,
      enabled: false,
      reminderMinute: 1050,
      snoozeMinutes: 30,
    );
    final stillPlanned = (await meds.watchDailyIntakes(date).first).singleWhere(
      (entry) => entry.schedule.id == a,
    );
    expect(stillPlanned.reminder!.enabled, isFalse);
    expect(stillPlanned.latestEvent, isNull);
    expect(await db.select(db.intakeEvents).get(), isEmpty);
  });

  test(
    'v3 reminder settings migrate to all slots without changing history',
    () async {
      final fixture = jsonDecode(
        await File('drift_schemas/drift_schema_v3.json').readAsString(),
      ) as Map<String, dynamic>;
      final db = AppDatabase(
        NativeDatabase.memory(
          setup: (raw) {
            for (final entity in fixture['fixed_sql'] as List<dynamic>) {
              raw.execute(
                (entity['sql'] as List<dynamic>).single['sql'] as String,
              );
            }
            raw.execute('PRAGMA user_version = 3');
            raw.execute(
              "INSERT INTO medications VALUES (3, 'Vitamin D', '1 g', 1, 1000)",
            );
            raw.execute(
              "INSERT INTO medication_details VALUES (3, 20100, 'Vitamin D', '1 g')",
            );
            raw.execute('''
        INSERT INTO medication_schedules VALUES
          (11, 3, 0, 480, 20100, NULL),
          (12, 3, 0, 1080, 20100, NULL)
        ''');
            raw.execute(
              'INSERT INTO medication_reminders VALUES (3, 1, 465, 30, 1234)',
            );
            raw.execute('''
        INSERT INTO intake_events
          (id, schedule_id, scheduled_date, kind, recorded_at, recorded_on)
        VALUES (17, 11, 20101, 'confirmation', 1736726400000000, 20101)
        ''');
            raw.execute(
              "INSERT INTO reminder_occurrences VALUES (11, 20101, NULL, 'token', 17)",
            );
          },
        ),
      );
      addTearDown(db.close);

      final slots = await db.select(db.slotReminders).get();
      expect(slots.map((row) => row.scheduleId), unorderedEquals([11, 12]));
      expect(
        slots.every(
          (row) =>
              row.enabled &&
              row.reminderMinute == 465 &&
              row.snoozeMinutes == 30 &&
              row.changedAt.microsecondsSinceEpoch == 1234,
        ),
        isTrue,
      );
      expect((await db.select(db.intakeEvents).getSingle()).id, 17);
      expect(
        (await db.select(db.reminderOccurrences).getSingle()).latestEventId,
        17,
      );
      expect(await db.select(db.appSettings).get(), isEmpty);
      expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
    },
  );

  testWidgets(
    'denied permission leaves tracking available and snooze has no intake write',
    (tester) async {
      const channel = MethodChannel('medimanager/reminders');
      final messenger = tester.binding.defaultBinaryMessenger;
      final calls = <MethodCall>[];
      var permission = false;
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        return call.method == 'snooze' || permission;
      });
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final now = DateTime(2026, 11, 16, 9);
      final medications = MedicationRepository(db, now: () => now);
      final intakes = IntakeRepository(db, now: () => now);
      final reminders = AndroidReminders(db);
      final occurrence = (await tester.runAsync(() async {
        final id = await medications.createMedication(name: 'Vitamin D');
        final date = medications.today;
        final schedule = await medications.saveSchedule(
          medicationId: id,
          recurrence: const Recurrence.daily(),
          minutesAfterMidnight: 1080,
          startsOn: date,
          endsBefore: null,
        );
        return (scheduleId: schedule, scheduledDate: date);
      }))!;

      await tester.pumpWidget(
        MainApp(
          medications: medications,
          intakes: intakes,
          reminders: reminders,
        ),
      );
      await tester.pumpAndSettle();
      expect(
        calls.where((call) => call.method == 'requestPermission'),
        isEmpty,
      );

      Future<void> tap(Finder finder) async {
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }

      await tap(find.widgetWithText(NavigationDestination, 'Medikamente'));
      await tap(find.text('Vitamin D'));
      await tap(find.text('Erinnerungen'));
      await tap(find.text('Erinnerungen aktivieren'));
      await tap(find.widgetWithText(FilledButton, 'Speichern'));
      expect(
        calls.where((call) => call.method == 'requestPermission'),
        hasLength(1),
      );
      expect(
        find.text('Android-Benachrichtigungen sind deaktiviert.'),
        findsOneWidget,
      );
      await tap(find.byType(BackButton));
      await tap(find.widgetWithText(NavigationDestination, 'Heute'));
      expect(find.text('Genommen'), findsOneWidget);
      expect(find.text('Später erinnern'), findsNothing);

      permission = true;
      reminders.resume();
      await tester.pumpAndSettle();
      await tap(find.text('Später erinnern'));
      expect(calls.singleWhere((call) => call.method == 'snooze').arguments, {
        'schedule': occurrence.scheduleId,
        'day': occurrence.scheduledDate.epochDay,
        'event': 0,
      });
      expect(find.text('Nicht bestätigt'), findsOneWidget);
      expect(
        await tester.runAsync(() => intakes.historyFor(occurrence)),
        isEmpty,
      );

      permission = false;
      reminders.resume();
      await tester.pumpAndSettle();
      await tap(find.text('Genommen'));
      expect(find.text('Bestätigt'), findsOneWidget);
      expect(
        await tester.runAsync(() => intakes.historyFor(occurrence)),
        hasLength(1),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );
}
