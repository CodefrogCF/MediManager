import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medimanager/data/app_database.dart';
import 'package:medimanager/data/intake_repository.dart';
import 'package:medimanager/data/medication_repository.dart';
import 'package:medimanager/domain/medication.dart';
import 'package:medimanager/main.dart';

void main() {
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
