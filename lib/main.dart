import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/android_reminders.dart';
import 'data/app_database.dart';
import 'data/intake_repository.dart';
import 'data/medication_repository.dart';
import 'domain/local_date.dart';
import 'presentation/intake_day_page.dart';
import 'presentation/labels.dart';
import 'presentation/medication_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase.open();
  final android = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  runApp(
    MainApp(
      medications: MedicationRepository(database),
      intakes: IntakeRepository(database),
      reminders: android ? AndroidReminders(database) : null,
      localClockChanges: android
          ? const EventChannel('medimanager/clock_changes')
                .receiveBroadcastStream()
          : null,
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({
    required this.medications,
    required this.intakes,
    this.localClockChanges,
    this.reminders,
    super.key,
  });

  final MedicationRepository medications;
  final IntakeRepository intakes;
  final Stream<Object?>? localClockChanges;
  final AndroidReminders? reminders;

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
      home: _HomePage(
        medications: medications,
        intakes: intakes,
        localClockChanges: localClockChanges,
        reminders: reminders,
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({
    required this.medications,
    required this.intakes,
    required this.localClockChanges,
    this.reminders,
  });

  final MedicationRepository medications;
  final IntakeRepository intakes;
  final Stream<Object?>? localClockChanges;
  final AndroidReminders? reminders;

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  int _selected = 0;
  late LocalDate _today;
  LocalDate? _archiveDate;
  late final AppLifecycleListener _lifecycle;
  StreamSubscription<Object?>? _clockEvents;
  Timer? _midnight;
  late bool _foreground;

  @override
  void initState() {
    super.initState();
    _today = widget.medications.today;
    final lifecycleState = WidgetsBinding.instance.lifecycleState;
    _foreground =
        lifecycleState == null || lifecycleState == AppLifecycleState.resumed;
    _lifecycle = AppLifecycleListener(
      onStateChange: (state) {
        _foreground = state == AppLifecycleState.resumed;
        if (_foreground) {
          _refreshClock();
          widget.reminders?.resume();
        } else {
          _midnight?.cancel();
        }
      },
    );
    _clockEvents = widget.localClockChanges?.listen((event) {
      if (event == AndroidReminders.dataChanged) {
        widget.reminders?.externalChanges();
      } else {
        _refreshClock();
      }
    });
    widget.reminders?.start();
    _refreshClock();
  }

  void _refreshClock() {
    if (!_foreground) return;
    final now = widget.medications.localNow;
    final date = LocalDate.fromDateTime(now);
    if (date != _today) setState(() => _today = date);
    _midnight?.cancel();
    final nextDay = DateTime(now.year, now.month, now.day + 1);
    _midnight = Timer(nextDay.difference(now), _refreshClock);
  }

  @override
  void dispose() {
    _midnight?.cancel();
    _lifecycle.dispose();
    unawaited(_clockEvents?.cancel());
    widget.reminders?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final archive = _selected == 2;
    final previous = _archiveDate ?? _today.plusDays(-1);
    final date = archive && !_today.isBefore(previous) ? previous : _today;
    return Scaffold(
      body: _selected == 1
          ? MedicationPage(
              medications: widget.medications,
              intakes: widget.intakes,
              reminders: widget.reminders,
            )
          : IntakeDayPage(
              key: ValueKey((_selected, date)),
              date: date,
              today: _today,
              medications: widget.medications,
              intakes: widget.intakes,
              reminders: widget.reminders,
              onDateSelected: archive
                  ? (selected) => setState(() => _archiveDate = selected)
                  : null,
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selected,
        onDestinationSelected: (index) {
          _refreshClock();
          setState(() {
            if (index == 2) _archiveDate ??= _today.plusDays(-1);
            _selected = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            label: Labels.today,
          ),
          NavigationDestination(
            icon: Icon(Icons.medication_outlined),
            label: Labels.medications,
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: Labels.archive,
          ),
        ],
      ),
    );
  }
}
