import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medimanager/data/app_database.dart';
import 'package:medimanager/data/intake_repository.dart';
import 'package:medimanager/data/medication_repository.dart';
import 'package:medimanager/domain/intake_event.dart';
import 'package:medimanager/domain/local_date.dart';
import 'package:medimanager/domain/medication.dart';
import 'package:medimanager/main.dart';

void main() {
  testWidgets(
    'Friday confirmation survives restart, rollover, undo and backfill',
    (tester) async {
      final directory = await tester.runAsync(
        () => Directory.systemTemp.createTemp('medimanager-workflow-'),
      );
      final file = File('${directory!.path}/workflow.sqlite');
      var db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await file.delete();
        await directory.delete();
      });
      var clock = DateTime(2026, 3, 27, 18, 4);
      final friday = LocalDate.fromDateTime(clock);

      Future<void> openApp() async {
        await tester.runAsync(() => db.customSelect('SELECT 1').getSingle());
        await tester.pumpWidget(
          MainApp(
            medications: MedicationRepository(db, now: () => clock),
            intakes: IntakeRepository(db, now: () => clock),
          ),
        );
        await tester.pumpAndSettle();
      }

      Future<void> restart() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
        await tester.runAsync(db.close);
        db = AppDatabase(NativeDatabase(file));
        await openApp();
      }

      await openApp();
      await _tap(tester, find.text('Medikamente'));
      await _tap(tester, find.byTooltip('Medikament hinzufügen'));
      await tester.enterText(find.byType(TextFormField).first, 'Vitamin D');
      await tester.enterText(find.byType(TextFormField).last, '1 Tablette');
      await _tap(tester, find.text('Speichern'));
      await _tap(tester, find.text('Vitamin D'));
      await _tap(tester, find.byTooltip('Plan hinzufügen'));
      await _tap(tester, find.text('Täglich'));
      await _tap(tester, find.text('Ausgewählte Wochentage').last);
      await _tap(tester, find.widgetWithText(FilterChip, 'Fr'));
      await _tap(tester, find.widgetWithText(ListTile, 'Uhrzeit (optional)'));
      await _setPickerTime(tester, '18', '00');
      await _tap(tester, find.text('Speichern'));
      await _tap(tester, find.byType(BackButton));
      await _tap(tester, find.widgetWithText(NavigationDestination, 'Heute'));
      expect(find.text('Vitamin D'), findsOneWidget);
      expect(find.text('1 Tablette'), findsOneWidget);
      expect(find.text('18:00'), findsOneWidget);
      expect(find.text('Nicht bestätigt'), findsOneWidget);

      await _tap(tester, find.text('Genommen'));
      expect(find.text('Bestätigt'), findsOneWidget);
      expect(find.textContaining('18:04'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Genommen'))
            .onPressed,
        isNull,
      );
      await restart();
      expect(find.text('Bestätigt'), findsOneWidget);

      clock = DateTime(2026, 3, 28);
      await tester.pump(const Duration(hours: 6));
      await tester.pumpAndSettle();
      expect(find.text('Heute sind keine Einnahmen geplant.'), findsOneWidget);
      expect(find.text('Vitamin D'), findsNothing);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      clock = DateTime(2026, 3, 30, 9, 12);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(_displayedDate(tester, clock), findsOneWidget);
      await _tap(tester, find.widgetWithText(NavigationDestination, 'Verlauf'));
      expect(
        find.text('Für diesen Tag sind keine Einnahmen geplant.'),
        findsOneWidget,
      );
      await _tap(tester, find.byTooltip('Vorheriger Tag'));
      await _tap(tester, find.byTooltip('Vorheriger Tag'));
      expect(find.text('Vitamin D'), findsOneWidget);
      expect(find.text('Bestätigt'), findsOneWidget);
      expect(find.textContaining('18:04'), findsOneWidget);

      await _tap(tester, find.text('Rückgängig'));
      expect(find.text('Nicht bestätigt'), findsOneWidget);
      expect(find.text('Korrigiert'), findsOneWidget);
      await _tap(tester, find.byTooltip('Protokoll der Einnahme'));
      expect(find.text('Bestätigt'), findsOneWidget);
      expect(find.textContaining('18:04'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      await _tap(tester, find.text('Nachtragen'));
      expect(find.text('Einnahme nachtragen'), findsOneWidget);
      await _tap(
        tester,
        find.widgetWithText(ListTile, 'Einnahmezeit (optional)'),
      );
      await _setPickerTime(tester, '18', '15');
      await _tap(
        tester,
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(FilledButton, 'Nachtragen'),
        ),
      );
      expect(find.text('Bestätigt'), findsOneWidget);
      expect(find.text('Nachträglich bestätigt'), findsOneWidget);
      expect(find.textContaining('09:12'), findsOneWidget);
      expect(find.textContaining('18:15'), findsOneWidget);

      await restart();
      await _tap(tester, find.widgetWithText(NavigationDestination, 'Verlauf'));
      await _tap(tester, find.byTooltip('Vorheriger Tag'));
      await _tap(tester, find.byTooltip('Vorheriger Tag'));
      expect(find.text('Nachträglich bestätigt'), findsOneWidget);
      final history = await tester.runAsync(() async {
        final schedule = (await db.select(db.medicationSchedules).get()).single;
        return IntakeRepository(db)
            .historyFor((scheduleId: schedule.id, scheduledDate: friday));
      });
      expect(history!.map((event) => event.kind), [
        IntakeEventKind.confirmation,
        IntakeEventKind.correction,
        IntakeEventKind.confirmation,
      ]);
      expect(history.last.recordedOn, LocalDate.fromDateTime(clock));
      expect(history.last.recordedAt, clock.toUtc());
      expect(
        history.last.reportedIntakeAt,
        DateTime(2026, 3, 27, 18, 15).toUtc(),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'failed writes stay pending and a clock signal loads independent new-day state',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      final clockEvents = StreamController<void>.broadcast();
      addTearDown(db.close);
      addTearDown(clockEvents.close);
      var clock = DateTime(2026, 3, 27, 12);
      final medications = MedicationRepository(db, now: () => clock);
      final intakes = IntakeRepository(db, now: () => clock);
      final date = medications.today;
      final ids = await tester.runAsync(() async {
        final ids = <int>[];
        for (final name in ['Präparat A', 'Präparat B']) {
          ids.add(
            await medications.saveSchedule(
              medicationId: await medications.createMedication(name: name),
              recurrence: const Recurrence.daily(),
              minutesAfterMidnight: null,
              startsOn: date,
              endsBefore: null,
            ),
          );
        }
        await db.customStatement('''
        CREATE TRIGGER fail_confirmation BEFORE INSERT ON intake_events
        BEGIN SELECT RAISE(ABORT, 'simulated write failure'); END
        ''');
        return ids;
      });
      await tester.pumpWidget(
        MainApp(
          medications: medications,
          intakes: intakes,
          localClockChanges: clockEvents.stream,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Nicht bestätigt'), findsNWidgets(2));
      await _tap(tester, find.text('Genommen').first);
      expect(
        find.text('Die Änderung konnte nicht gespeichert werden.'),
        findsOneWidget,
      );
      expect(find.text('Nicht bestätigt'), findsNWidgets(2));
      expect(find.text('Bestätigt'), findsNothing);
      final intake = (scheduleId: ids!.first, scheduledDate: date);
      final failedHistory = await tester.runAsync(
        () => intakes.historyFor(intake),
      );
      expect(failedHistory, isEmpty);

      await tester.runAsync(
        () => db.customStatement('DROP TRIGGER fail_confirmation'),
      );
      await _tap(tester, find.text('Genommen').first);
      expect(find.text('Bestätigt'), findsOneWidget);
      expect(find.text('Nicht bestätigt'), findsOneWidget);
      await _tap(tester, find.widgetWithText(NavigationDestination, 'Verlauf'));
      await _tap(tester, find.byTooltip('Nächster Tag'));
      expect(find.text('Bestätigt'), findsOneWidget);
      await _tap(tester, find.text('Rückgängig'));
      await _tap(tester, find.widgetWithText(NavigationDestination, 'Heute'));
      expect(find.text('Nicht bestätigt'), findsNWidgets(2));
      await _tap(tester, find.text('Genommen').first);
      expect(find.text('Bestätigt'), findsOneWidget);

      clock = DateTime(2026, 3, 28, 3);
      clockEvents.add(null);
      await tester.pumpAndSettle();
      expect(_displayedDate(tester, clock), findsOneWidget);
      expect(find.text('Nicht bestätigt'), findsNWidgets(2));
      final history = await tester.runAsync(() => intakes.historyFor(intake));
      expect(history, hasLength(3));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Finder _displayedDate(WidgetTester tester, DateTime date) {
  final context = tester.element(find.byType(NavigationBar));
  return find.text(MaterialLocalizations.of(context).formatCompactDate(date));
}

Future<void> _setPickerTime(
  WidgetTester tester,
  String hour,
  String minute,
) async {
  await _tap(tester, find.byIcon(Icons.keyboard_outlined));
  final picker = find.byType(TimePickerDialog);
  final fields = find.descendant(of: picker, matching: find.byType(TextField));
  await tester.enterText(fields.first, hour);
  await tester.enterText(fields.last, minute);
  final ok = MaterialLocalizations.of(tester.element(picker)).okButtonLabel;
  await _tap(tester, find.widgetWithText(TextButton, ok));
}
