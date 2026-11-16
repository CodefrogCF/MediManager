import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medimanager/data/app_database.dart';
import 'package:medimanager/data/backup_repository.dart';
import 'package:medimanager/data/intake_repository.dart';
import 'package:medimanager/data/medication_repository.dart';
import 'package:medimanager/data/settings_repository.dart';
import 'package:medimanager/domain/intake_event.dart';
import 'package:medimanager/domain/local_date.dart';
import 'package:medimanager/domain/medication.dart';
import 'package:medimanager/main.dart';

void main() {
  test(
    'release restores the previous backup format with both slots and undo',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final backups = BackupRepository(db);
      final bytes = await File('test/fixtures/v0.3-backup.json').readAsBytes();
      final preview = backups.inspect(bytes);
      expect(preview.medicationCount, 1);
      expect(preview.eventCount, 2);
      await backups.restore(preview);

      final day = LocalDate.fromDateTime(DateTime.utc(2026, 4, 3));
      final slots = await MedicationRepository(db).watchDailyIntakes(day).first;
      expect(slots.map((slot) => slot.schedule.label), ['Morning', 'Evening']);
      expect(slots.first.latestEvent!.kind, IntakeEventKind.correction);
      expect(slots.last.latestEvent, isNull);
      final log = await IntakeRepository(db).historyFor(slots.first.intake);
      expect(log.map((entry) => entry.kind), [
        IntakeEventKind.confirmation,
        IntakeEventKind.correction,
      ]);
      expect(log.first.recordedAt, DateTime.utc(2026, 4, 3, 8, 1, 0, 123, 456));
      expect(slots.last.reminder!.snoozeMinutes, 30);
      expect((await SettingsRepository(db).watch.first)!.language, 'en');
    },
  );

  test('day queries read a three-year on-disk intake archive', () async {
    const slotsPerDay = 48;
    const archiveDays = 1095;
    final dir = await Directory.systemTemp.createTemp('medimanager-archive-');
    final file = File('${dir.path}/archive.sqlite');
    addTearDown(() async {
      await for (final entry in dir.list()) {
        await entry.delete();
      }
      await dir.delete();
    });
    final first = LocalDate.fromDateTime(DateTime.utc(2023, 1, 1));
    final recordedAt = DateTime.utc(2026, 4, 1);
    final initial = AppDatabase(NativeDatabase(file));
    try {
      final meds = MedicationRepository(
        initial,
        now: () => DateTime(2023, 1, 1),
      );
      final slots = <int>[];
      for (var index = 0; index < slotsPerDay ~/ 2; index++) {
        final medication = await meds.createMedication(name: 'Sample $index');
        for (final time in [480, 1080]) {
          slots.add(
            await meds.saveSchedule(
              medicationId: medication,
              recurrence: const Recurrence.daily(),
              minutesAfterMidnight: time,
              startsOn: first,
              endsBefore: null,
            ),
          );
        }
      }
      await initial.batch((batch) {
        batch.insertAll(initial.intakeEvents, [
          for (var offset = 0; offset < archiveDays; offset++)
            for (final slot in slots)
              IntakeEventsCompanion.insert(
                scheduleId: slot,
                scheduledDate: first.plusDays(offset),
                kind: IntakeEventKind.confirmation,
                recordedAt: recordedAt,
                recordedOn: Value(LocalDate.fromDateTime(recordedAt)),
              ),
        ]);
      });
    } finally {
      await initial.close();
    }
    final reopened = AppDatabase(NativeDatabase(file));
    addTearDown(reopened.close);
    final medications = MedicationRepository(reopened);
    final timings = <int>[];
    for (var sample = 0; sample < 25; sample++) {
      final query = Stopwatch()..start();
      final rows = await medications
          .watchDailyIntakes(first.plusDays(sample * 43))
          .first;
      timings.add(query.elapsedMicroseconds);
      expect(rows, hasLength(slotsPerDay));
      expect(
        rows.every((row) => row.latestEvent?.isConfirmation == true),
        isTrue,
      );
    }
    final pending = await medications
        .watchDailyIntakes(first.plusDays(archiveDays))
        .first;
    expect(pending, hasLength(slotsPerDay));
    expect(pending.every((row) => row.latestEvent == null), isTrue);
    final count = await reopened
        .customSelect('SELECT COUNT(*) AS total FROM intake_events')
        .getSingle();
    expect(count.read<int>('total'), slotsPerDay * archiveDays);
    timings.sort();
    debugPrint(
      'Archive ${slotsPerDay * archiveDays} events, 25 date queries '
      'including first open. p50 ${timings[12] / 1000} ms, p95 ${timings[23] / 1000} ms.',
    );
  });

  for (final viewport in [const Size(320, 600), const Size(640, 360)]) {
    testWidgets('tracking and archive at $viewport with large text', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = viewport;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final clock = DateTime(2026, 4, 3, 8);
      final meds = MedicationRepository(db, now: () => clock);
      final intakes = IntakeRepository(db, now: () => clock);
      final yesterday = meds.today.plusDays(-1);
      await tester.runAsync(() async {
        final medications = MedicationRepository(
          db,
          now: () => DateTime(2026, 4, 2),
        );
        final medication = await medications.createMedication(
          name: 'Beispielmedikament',
        );
        final slot = await medications.saveSchedule(
          medicationId: medication,
          recurrence: const Recurrence.daily(),
          minutesAfterMidnight: 480,
          startsOn: yesterday,
          endsBefore: null,
          label: 'Morgens',
        );
        await intakes.confirm((scheduleId: slot, scheduledDate: yesterday));
      });
      await tester.pumpWidget(
        MainApp(
          medications: meds,
          intakes: intakes,
          settings: SettingsRepository(db),
          backup: BackupRepository(db),
        ),
      );
      await tester.pumpAndSettle();
      final taken = find.widgetWithText(FilledButton, 'Genommen');
      await tester.ensureVisible(taken);
      await tester.pumpAndSettle();
      await tester.tap(taken);
      await tester.pumpAndSettle();
      expect(find.text('Bestätigt'), findsOneWidget);

      await tester.tap(find.widgetWithText(NavigationDestination, 'Verlauf'));
      await tester.pumpAndSettle();
      expect(find.text('Nachträglich bestätigt'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.calendar_today_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });
  }
}
