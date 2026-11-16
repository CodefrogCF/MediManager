import 'package:flutter/material.dart';

import '../data/android_reminders.dart';
import '../data/intake_repository.dart';
import '../data/medication_repository.dart';
import '../domain/intake_event.dart';
import '../domain/local_date.dart';
import 'labels.dart';

/// Both tabs render the same date-filtered occurrences and event state.
class IntakeDayPage extends StatefulWidget {
  const IntakeDayPage({
    required this.date,
    required this.today,
    required this.medications,
    required this.intakes,
    this.onDateSelected,
    this.reminders,
    super.key,
  });

  final LocalDate date;
  final LocalDate today;
  final MedicationRepository medications;
  final IntakeRepository intakes;
  final ValueChanged<LocalDate>? onDateSelected;
  final AndroidReminders? reminders;

  @override
  State<IntakeDayPage> createState() => _IntakeDayPageState();
}

class _IntakeDayPageState extends State<IntakeDayPage> {
  static final _firstDate = LocalDate.fromDateTime(DateTime(1));
  late final _entries = widget.medications.watchDailyIntakes(widget.date);

  bool get _archive => widget.onDateSelected != null;

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.date.calendarDate,
      firstDate: _firstDate.calendarDate,
      lastDate: widget.today.calendarDate,
      currentDate: widget.today.calendarDate,
    );
    if (mounted && picked != null) {
      widget.onDateSelected!(LocalDate.fromDateTime(picked));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(_archive ? Labels.archive : Labels.today)),
    body: Column(
      children: [
        if (_archive)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  tooltip: Labels.previousDay,
                  onPressed: _firstDate.isBefore(widget.date)
                      ? () => widget.onDateSelected!(widget.date.plusDays(-1))
                      : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: _selectDate,
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(Labels.date(context, widget.date)),
                  ),
                ),
                IconButton(
                  tooltip: Labels.nextDay,
                  onPressed: widget.date.isBefore(widget.today)
                      ? () => widget.onDateSelected!(widget.date.plusDays(1))
                      : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(Labels.date(context, widget.date)),
          ),
        Expanded(
          child: StreamBuilder(
            stream: _entries,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text(Labels.loadError));
              }
              final entries = snapshot.data;
              if (entries == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (entries.isEmpty) {
                return Center(
                  child: Text(_archive ? Labels.emptyDate : Labels.emptyToday),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return _IntakeCard(
                    key: ValueKey(entry.intake),
                    entry: entry,
                    intakes: widget.intakes,
                    reminders: widget.reminders,
                    retrospective: widget.date.isBefore(widget.today),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}

class _IntakeCard extends StatefulWidget {
  const _IntakeCard({
    required this.entry,
    required this.intakes,
    required this.retrospective,
    required this.reminders,
    super.key,
  });

  final DailyIntake entry;
  final IntakeRepository intakes;
  final bool retrospective;
  final AndroidReminders? reminders;

  @override
  State<_IntakeCard> createState() => _IntakeCardState();
}

class _IntakeCardState extends State<_IntakeCard> {
  bool _saving = false;
  int _awaitingEvent = 0;

  bool get _busy =>
      _saving || (widget.entry.latestEvent?.id ?? 0) < _awaitingEvent;

  Future<void> _apply(IntakeEvent? confirmation) async {
    if (_busy) return;
    setState(() => _saving = true);
    try {
      final intake = widget.entry.intake;
      DateTime? reportedAt;
      if (confirmation == null && widget.retrospective) {
        final report = await showDialog<({DateTime? reportedAt})>(
          context: context,
          builder: (_) => _RetrospectiveDialog(date: intake.scheduledDate),
        );
        if (!mounted || report == null) return;
        reportedAt = report.reportedAt;
      }
      _awaitingEvent = confirmation == null
          ? await widget.intakes.confirm(intake, reportedIntakeAt: reportedAt)
          : await widget.intakes.correct(
              intake,
              expectedConfirmationId: confirmation.id,
            );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text(Labels.saveError)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showEvents() {
    final events = widget.intakes.historyFor(widget.entry.intake);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) => FutureBuilder(
        future: events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text(Labels.loadError));
          }
          final history = snapshot.data;
          if (history == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: [
              const ListTile(title: Text(Labels.eventHistory)),
              for (final event in history.reversed)
                ListTile(
                  title: Text(
                    event.isConfirmation
                        ? Labels.confirmedStatus
                        : Labels.correctedStatus,
                  ),
                  subtitle: Text(_eventDetails(context, event).join('\n')),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _snooze(AndroidReminders reminders, int minutes) async {
    if (_busy) return;
    setState(() => _saving = true);
    try {
      final entry = widget.entry;
      final saved = await reminders.snooze(
        entry.intake,
        entry.latestEvent?.id ?? 0,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(saved ? Labels.snoozed(minutes) : Labels.snoozeError),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final latest = entry.latestEvent;
    final confirmation = latest?.isConfirmation == true ? latest : null;
    final dosage = entry.details.dosage;
    final minutes = entry.schedule.minutesAfterMidnight;
    final reminders = widget.reminders;
    final reminder = entry.reminder;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.details.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (dosage != null) Text(dosage),
            if (minutes != null) Text(Labels.scheduleTime(context, minutes)),
            const SizedBox(height: 8),
            Text(
              confirmation == null
                  ? Labels.unconfirmedStatus
                  : Labels.confirmedStatus,
            ),
            if (latest != null) ...[
              if (!latest.isConfirmation) const Text(Labels.correctedStatus),
              for (final line in _eventDetails(context, latest)) Text(line),
            ],
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (!widget.retrospective || confirmation == null)
                  FilledButton(
                    onPressed: _busy || confirmation != null
                        ? null
                        : () => _apply(null),
                    child: Text(
                      widget.retrospective ? Labels.backfill : Labels.taken,
                    ),
                  ),
                if (confirmation != null)
                  TextButton(
                    onPressed: _busy ? null : () => _apply(confirmation),
                    child: const Text(Labels.undo),
                  ),
                if (confirmation == null &&
                    !widget.retrospective &&
                    entry.medication.isActive &&
                    reminder?.enabled == true &&
                    reminders != null)
                  ValueListenableBuilder(
                    valueListenable: reminders.permission,
                    builder: (context, allowed, _) => allowed
                        ? TextButton(
                            onPressed: _busy
                                ? null
                                : () => _snooze(
                                    reminders,
                                    reminder!.snoozeMinutes,
                                  ),
                            child: const Text(Labels.remindLater),
                          )
                        : const SizedBox.shrink(),
                  ),
                if (latest != null)
                  IconButton(
                    tooltip: Labels.eventHistory,
                    onPressed: _busy ? null : _showEvents,
                    icon: const Icon(Icons.history),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<String> _eventDetails(BuildContext context, IntakeEvent event) => [
  if (event.isConfirmation && event.isRetrospective) Labels.backfilled,
  Labels.recordedAt(Labels.timestamp(context, event.recordedAt)),
  if (event.reportedIntakeAt case final reported?)
    Labels.reportedAt(Labels.timestamp(context, reported)),
];

class _RetrospectiveDialog extends StatefulWidget {
  const _RetrospectiveDialog({required this.date});

  final LocalDate date;

  @override
  State<_RetrospectiveDialog> createState() => _RetrospectiveDialogState();
}

class _RetrospectiveDialogState extends State<_RetrospectiveDialog> {
  DateTime? _reportedAt;
  bool _invalidTime = false;

  Future<void> _pickTime() async {
    final reported = _reportedAt;
    final picked = await showTimePicker(
      context: context,
      initialTime: reported == null
          ? const TimeOfDay(hour: 12, minute: 0)
          : TimeOfDay.fromDateTime(reported),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (!mounted || picked == null) return;
    final date = widget.date.calendarDate;
    final timestamp = DateTime(
      date.year,
      date.month,
      date.day,
      picked.hour,
      picked.minute,
    );
    setState(() {
      _invalidTime =
          LocalDate.fromDateTime(timestamp) != widget.date ||
          timestamp.hour != picked.hour ||
          timestamp.minute != picked.minute;
      if (!_invalidTime) _reportedAt = timestamp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reported = _reportedAt;
    return AlertDialog(
      scrollable: true,
      title: const Text(Labels.backfillTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Labels.backfillDate(Labels.date(context, widget.date))),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(Labels.reportedTime),
            subtitle: Text(
              reported == null
                  ? Labels.noTime
                  : Labels.timeOfDay(context, TimeOfDay.fromDateTime(reported)),
            ),
            onTap: _pickTime,
            trailing: reported != null || _invalidTime
                ? IconButton(
                    tooltip: Labels.removeTime,
                    onPressed: () => setState(() {
                      _reportedAt = null;
                      _invalidTime = false;
                    }),
                    icon: const Icon(Icons.clear),
                  )
                : null,
          ),
          if (_invalidTime)
            Text(
              Labels.invalidReportedTime,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(Labels.cancel),
        ),
        FilledButton(
          onPressed: _invalidTime
              ? null
              : () => Navigator.pop(context, (reportedAt: reported)),
          child: const Text(Labels.backfill),
        ),
      ],
    );
  }
}
