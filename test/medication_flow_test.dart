import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medimanager/data/app_database.dart';
import 'package:medimanager/data/intake_repository.dart';
import 'package:medimanager/data/medication_repository.dart';
import 'package:medimanager/domain/medication.dart';
import 'package:medimanager/main.dart';

void main() {
  testWidgets('editing a plan keeps one editable entry and preserves today', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final now = DateTime(2026, 3, 27, 12);
    final medications = MedicationRepository(db, now: () => now);
    final intakes = IntakeRepository(db, now: () => now);
    final today = medications.today;
    final (medication, morning) = (await tester.runAsync(() async {
      final medication = await medications.createMedication(name: 'Vitamin D');
      final morning = await medications.saveSchedule(
        medicationId: medication,
        recurrence: const Recurrence.daily(),
        minutesAfterMidnight: 480,
        startsOn: today,
        endsBefore: null,
      );
      await medications.saveSchedule(
        medicationId: medication,
        recurrence: const Recurrence.daily(),
        minutesAfterMidnight: 1200,
        startsOn: today,
        endsBefore: null,
        label: 'Abends',
      );
      // Older versions stored closed and future schedules as separate rows.
      await medications.saveSchedule(
        medicationId: medication,
        recurrence: const Recurrence.daily(),
        minutesAfterMidnight: 720,
        startsOn: today,
        endsBefore: today.plusDays(1),
        label: 'Endet heute',
      );
      await intakes.confirm((scheduleId: morning, scheduledDate: today));
      return (medication, morning);
    }))!;

    await tester.pumpWidget(
      MainApp(medications: medications, intakes: intakes),
    );
    await tester.pumpAndSettle();

    Future<void> tap(Finder finder) async {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    await tap(find.text('Medikamente'));
    await tap(find.text('Vitamin D'));
    expect(find.text('Endet heute'), findsNothing);
    final title = 'Plan $morning';
    final plan = find.widgetWithText(ListTile, title);
    final planMenu = find.descendant(
      of: plan,
      matching: find.byType(PopupMenuButton<bool>),
    );
    await tap(planMenu);
    await tap(find.text('Plan bearbeiten'));
    expect(find.text('Änderungen gelten ab'), findsOneWidget);
    await tap(find.byTooltip('Uhrzeit entfernen'));
    await tap(find.text('Speichern'));
    expect(find.text(title), findsOneWidget);
    expect(planMenu, findsOneWidget);
    expect(find.text('Abends'), findsOneWidget);
    expect(find.text('Täglich'), findsNWidgets(2));
    expect(find.textContaining('Ohne Uhrzeit'), findsOneWidget);

    await tap(planMenu);
    await tap(find.text('Plan bearbeiten'));
    await tap(find.text('Speichern'));
    final schedules = await tester.runAsync(
      () => medications.watchSchedules(medication).first,
    );
    expect(schedules, hasLength(4));
    final current = await tester.runAsync(
      () => medications.watchDailyIntakes(today).first,
    );
    final original = current!.singleWhere(
      (slot) => slot.schedule.id == morning,
    );
    expect(original.schedule.minutesAfterMidnight, 480);
    expect(original.latestEvent?.isConfirmation, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets(
    'manage a medication, see its scheduled date, and open inactive history',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final now = DateTime(2026, 3, 27, 12);
      final medications = MedicationRepository(db, now: () => now);
      final intakes = IntakeRepository(db, now: () => now);

      await tester.runAsync(() async {
        final other = await medications.createMedication(
          name: 'Sonntagspräparat',
        );
        await medications.saveSchedule(
          medicationId: other,
          recurrence: Recurrence.weekly({DateTime.sunday}),
          minutesAfterMidnight: null,
          startsOn: medications.today,
          endsBefore: null,
        );
      });

      await tester.pumpWidget(
        MainApp(medications: medications, intakes: intakes),
      );
      await tester.pumpAndSettle();
      expect(find.text('Heute sind keine Einnahmen geplant.'), findsOneWidget);
      expect(find.text('Sonntagspräparat'), findsNothing);

      await tester.tap(find.text('Medikamente'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Medikament hinzufügen'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Speichern'));
      await tester.pumpAndSettle();
      expect(find.text('Gib einen Namen ein.'), findsOneWidget);
      await tester.enterText(
        find.byType(TextFormField).first,
        'Freitagspräparat',
      );
      await tester.tap(find.text('Speichern'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Freitagspräparat'));
      await tester.pumpAndSettle();
      await _openMedicationMenu(tester);
      await tester.tap(find.text('Medikament bearbeiten'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).last, '1 Tablette');
      await tester.tap(find.text('Speichern'));
      await tester.pumpAndSettle();
      expect(find.text('1 Tablette'), findsOneWidget);

      await tester.tap(find.byTooltip('Plan hinzufügen'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Täglich'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ausgewählte Wochentage').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Speichern'));
      await tester.pumpAndSettle();
      expect(find.text('Wähle mindestens einen Wochentag.'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilterChip, 'Fr'));
      await tester.tap(find.text('Speichern'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Fr'), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(NavigationDestination).first);
      await tester.pumpAndSettle();
      expect(find.text('Freitagspräparat'), findsOneWidget);
      expect(find.text('Sonntagspräparat'), findsNothing);
      expect(find.text('Einnahme bestätigt'), findsNothing);

      await tester.tap(find.text('Genommen'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Rückgängig'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Medikamente'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Freitagspräparat'));
      await tester.pumpAndSettle();
      await _openMedicationMenu(tester);
      await tester.tap(find.text('Deaktivieren'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Deaktivieren'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('Freitagspräparat'), findsNothing);

      await tester.tap(find.text('Inaktiv'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Freitagspräparat'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Einnahmeverlauf'));
      await tester.pumpAndSettle();
      expect(find.text('Einnahme bestätigt'), findsOneWidget);
      expect(find.text('Bestätigung zurückgenommen'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );
}

Future<void> _openMedicationMenu(WidgetTester tester) async {
  await tester.tap(
    find.descendant(
      of: find.byType(AppBar),
      matching: find.byWidgetPredicate((widget) => widget is PopupMenuButton),
    ),
  );
  await tester.pumpAndSettle();
}
