import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/app_database.dart';
import 'data/intake_repository.dart';
import 'data/medication_repository.dart';
import 'presentation/labels.dart';
import 'presentation/medication_page.dart';
import 'presentation/today_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase.open();
  runApp(
    MainApp(
      medications: MedicationRepository(database),
      intakes: IntakeRepository(database),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({required this.medications, required this.intakes, super.key});

  final MedicationRepository medications;
  final IntakeRepository intakes;

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF206656);
    return MaterialApp(
      title: Labels.app,
      locale: const Locale('de'),
      supportedLocales: const [Locale('de')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(colorSchemeSeed: seed, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: seed,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: _HomePage(medications: medications, intakes: intakes),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({required this.medications, required this.intakes});

  final MedicationRepository medications;
  final IntakeRepository intakes;

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: _selected == 0
        ? TodayPage(medications: widget.medications)
        : MedicationPage(
            medications: widget.medications,
            intakes: widget.intakes,
          ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _selected,
      onDestinationSelected: (index) => setState(() => _selected = index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.today_outlined),
          label: Labels.today,
        ),
        NavigationDestination(
          icon: Icon(Icons.medication_outlined),
          label: Labels.medications,
        ),
      ],
    ),
  );
}
