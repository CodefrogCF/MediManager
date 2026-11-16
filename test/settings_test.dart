import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medimanager/data/app_database.dart';
import 'package:medimanager/data/backup_repository.dart';
import 'package:medimanager/data/intake_repository.dart';
import 'package:medimanager/data/medication_repository.dart';
import 'package:medimanager/data/settings_repository.dart';
import 'package:medimanager/domain/medication.dart';
import 'package:medimanager/main.dart';

void main() {
  testWidgets('restore preview leaves current records intact until accepted', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final now = DateTime(2026, 4, 3);
    final meds = MedicationRepository(db, now: () => now);
    final backups = BackupRepository(db, now: () => now);
    final bytes = await tester.runAsync(() async {
      await meds.createMedication(name: 'In backup');
      final bytes = await backups.export();
      await backups.deleteAll();
      await meds.createMedication(name: 'On device');
      return bytes;
    });
    const channel = MethodChannel('medimanager/backup');
    final messenger = tester.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'pickBackup');
      return bytes;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
    await tester.pumpWidget(
      MainApp(
        medications: meds,
        intakes: IntakeRepository(db, now: () => now),
        settings: SettingsRepository(db),
        backup: backups,
      ),
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.byTooltip('Einstellungen'));
    await _tap(tester, find.text('Daten und Datenschutz'));
    final restore = find.text('Sicherung wiederherstellen');
    await _tap(tester, restore);
    expect(find.text('Lokale Daten ersetzen?'), findsOneWidget);
    await _tap(tester, find.text('Abbrechen'));
    expect(
      (await tester.runAsync(() => meds.watchMedications().first))!.single.name,
      'On device',
    );

    await _tap(tester, restore);
    await _tap(tester, find.widgetWithText(FilledButton, 'Wiederherstellen'));
    expect(find.text('Die Sicherung wurde wiederhergestellt.'), findsOneWidget);
    expect(
      (await tester.runAsync(() => meds.watchMedications().first))!.single.name,
      'In backup',
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets(
    'language and TerraManager appearance persist across app launch',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final now = DateTime(2026, 4, 3, 9);
      final meds = MedicationRepository(db, now: () => now);
      final intakes = IntakeRepository(db, now: () => now);
      await tester.runAsync(() => db.customSelect('SELECT 1').getSingle());

      Future<void> open() async {
        await tester.pumpWidget(
          MainApp(
            medications: meds,
            intakes: intakes,
            settings: SettingsRepository(db),
          ),
        );
        await tester.pumpAndSettle();
      }

      await open();
      final app = find.byType(MaterialApp);
      expect(tester.widget<MaterialApp>(app).themeMode, ThemeMode.system);
      expect(
        tester.widget<MaterialApp>(app).theme!.colorScheme,
        ColorScheme.fromSeed(seedColor: const Color(0xFF00A331)),
      );
      await _tap(tester, find.byTooltip('Einstellungen'));
      await _tap(tester, find.text('Designmodus'));
      await _tap(tester, find.text('Dunkel'));
      await _tap(tester, find.text('Akzentfarbe'));
      await _tap(tester, find.text('Türkis'));
      await _tap(tester, find.text('Sprache'));
      await _tap(tester, find.text('English'));
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Accent colour'), findsOneWidget);
      expect(tester.widget<MaterialApp>(app).themeMode, ThemeMode.dark);
      expect(
        tester.widget<MaterialApp>(app).darkTheme!.colorScheme,
        ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await open();
      expect(find.byTooltip('Settings'), findsOneWidget);
      expect(tester.widget<MaterialApp>(app).themeMode, ThemeMode.dark);
      expect(tester.widget<MaterialApp>(app).locale, const Locale('en'));
      await _tap(tester, find.byTooltip('Settings'));
      await _tap(tester, find.text('Theme mode'));
      await _tap(tester, find.text('Light'));
      expect(tester.widget<MaterialApp>(app).themeMode, ThemeMode.light);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'large text and distinct slot semantics keep one-tap confirmation',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(360, 740);
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final semantics = tester.ensureSemantics();
      final now = DateTime(2026, 4, 3, 9);
      final meds = MedicationRepository(db, now: () => now);
      await tester.runAsync(() async {
        final medication = await meds.createMedication(name: 'Vitamin D');
        for (final slot in [('Morning', 480), ('Evening', 1080)]) {
          await meds.saveSchedule(
            medicationId: medication,
            recurrence: const Recurrence.daily(),
            minutesAfterMidnight: slot.$2,
            startsOn: meds.today,
            endsBefore: null,
            label: slot.$1,
          );
        }
        await SettingsRepository(db).save(language: 'en');
      });

      await tester.pumpWidget(
        MainApp(
          medications: meds,
          intakes: IntakeRepository(db, now: () => now),
          settings: SettingsRepository(db),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final morning = find.bySemanticsLabel('Taken for Vitamin D, Morning');
      expect(morning, findsOneWidget);
      expect(
        tester.getSize(find.widgetWithText(FilledButton, 'Taken').first).height,
        greaterThanOrEqualTo(48),
      );
      await _tap(tester, morning);
      expect(find.text('Confirmed'), findsOneWidget);
      expect(find.text('Unconfirmed'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Undo for Vitamin D, Morning'),
        findsOneWidget,
      );
      semantics.dispose();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  testWidgets('deletion requires explicit confirmation', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final now = DateTime(2026, 4, 3);
    final meds = MedicationRepository(db, now: () => now);
    await tester.runAsync(() => meds.createMedication(name: 'Vitamin D'));
    await tester.pumpWidget(
      MainApp(
        medications: meds,
        intakes: IntakeRepository(db, now: () => now),
        settings: SettingsRepository(db),
        backup: BackupRepository(db),
      ),
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.byTooltip('Einstellungen'));
    await _tap(tester, find.text('Daten und Datenschutz'));
    final delete = find.text('Alle lokalen Daten löschen');
    await _tap(tester, delete);
    await _tap(tester, find.text('Abbrechen'));
    expect(
      await tester.runAsync(() => meds.watchMedications().first),
      hasLength(1),
    );
    await _tap(tester, delete);
    await _tap(tester, find.widgetWithText(FilledButton, 'Löschen'));
    expect(find.text('Die lokalen Daten wurden gelöscht.'), findsOneWidget);
    expect(await tester.runAsync(() => meds.watchMedications().first), isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
