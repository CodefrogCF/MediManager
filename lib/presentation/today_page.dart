import 'dart:async';

import 'package:flutter/material.dart';

import '../data/medication_repository.dart';
import '../domain/local_date.dart';
import 'labels.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({required this.medications, super.key});

  final MedicationRepository medications;

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  late LocalDate _date;
  late Stream<List<DailyIntake>> _intakes;
  late final AppLifecycleListener _lifecycle;
  Timer? _midnight;

  @override
  void initState() {
    super.initState();
    _date = widget.medications.today;
    _intakes = widget.medications.watchDailyIntakes(_date);
    _lifecycle = AppLifecycleListener(
      onResume: _refreshDay,
      onPause: () => _midnight?.cancel(),
    );
    _scheduleRefresh();
  }

  void _scheduleRefresh() {
    _midnight?.cancel();
    final now = DateTime.now();
    final nextDay = DateTime(now.year, now.month, now.day + 1);
    _midnight = Timer(nextDay.difference(now), _refreshDay);
  }

  void _refreshDay() {
    final date = widget.medications.today;
    if (date != _date) {
      setState(() {
        _date = date;
        _intakes = widget.medications.watchDailyIntakes(date);
      });
    }
    _scheduleRefresh();
  }

  @override
  void dispose() {
    _midnight?.cancel();
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('${Labels.today} · ${Labels.date(context, _date)}'),
    ),
    body: StreamBuilder(
      key: ValueKey(_date),
      stream: _intakes,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text(Labels.loadError));
        }
        final scheduled = snapshot.data;
        if (scheduled == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final visible = scheduled
            .where((entry) => entry.medication.isActive)
            .toList();
        if (visible.isEmpty) {
          return const Center(child: Text(Labels.emptyToday));
        }

        return ListView.builder(
          itemCount: visible.length,
          itemBuilder: (context, index) {
            final entry = visible[index];
            final dosage = entry.medication.dosage;
            return ListTile(
              leading: const Icon(Icons.medication_outlined),
              title: Text(entry.medication.name),
              subtitle: Text(
                [
                  ?dosage,
                  Labels.scheduleTime(
                    context,
                    entry.schedule.minutesAfterMidnight,
                  ),
                ].join(' · '),
              ),
            );
          },
        );
      },
    ),
  );
}
