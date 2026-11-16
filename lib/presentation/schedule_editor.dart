import 'package:flutter/material.dart';

import '../domain/local_date.dart';
import '../domain/medication.dart';
import 'labels.dart';

typedef ScheduleDraft = ({
  Recurrence recurrence,
  int? minutesAfterMidnight,
  LocalDate startsOn,
  LocalDate? endsBefore,
  String? label,
});

class ScheduleEditor extends StatefulWidget {
  const ScheduleEditor({required this.today, this.schedule, super.key});

  final LocalDate today;
  final MedicationSchedule? schedule;

  @override
  State<ScheduleEditor> createState() => _ScheduleEditorState();
}

class _ScheduleEditorState extends State<ScheduleEditor> {
  late bool _daily;
  late final Set<int> _weekdays;
  late LocalDate _start;
  LocalDate? _lastDay;
  TimeOfDay? _time;
  String? _error;
  String? _label;

  bool get _started {
    final schedule = widget.schedule;
    return schedule != null && !widget.today.isBefore(schedule.startsOn);
  }

  @override
  void initState() {
    super.initState();
    final schedule = widget.schedule;
    _daily = schedule?.recurrence.isDaily ?? true;
    _label = schedule?.label;
    _weekdays = _daily ? {} : schedule!.recurrence.weekdays;
    _start = schedule?.changeBoundary(widget.today) ?? widget.today;
    _lastDay = schedule?.endsBefore?.plusDays(-1);
    final minutes = schedule?.minutesAfterMidnight;
    if (minutes != null) {
      _time = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = _time;
    final lastDay = _lastDay;
    return AlertDialog(
      scrollable: true,
      title: Text(
        widget.schedule == null
            ? context.l10n.addSchedule
            : context.l10n.editSchedule,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: _label,
            decoration: InputDecoration(labelText: context.l10n.slotLabel),
            onChanged: (label) => _label = label,
          ),
          DropdownButton<bool>(
            isExpanded: true,
            value: _daily,
            items: [
              DropdownMenuItem(value: true, child: Text(context.l10n.daily)),
              DropdownMenuItem(value: false, child: Text(context.l10n.weekly)),
            ],
            onChanged: (daily) => setState(() {
              _daily = daily!;
              _error = null;
            }),
          ),
          if (!_daily)
            Wrap(
              spacing: 6,
              children: [
                for (var day = DateTime.monday; day <= DateTime.sunday; day++)
                  FilterChip(
                    label: Text(Labels.weekdays(context)[day - 1]),
                    selected: _weekdays.contains(day),
                    onSelected: (selected) => setState(() {
                      selected ? _weekdays.add(day) : _weekdays.remove(day);
                      _error = null;
                    }),
                  ),
              ],
            ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(context.l10n.startDate),
            subtitle: Text(Labels.date(context, _start)),
            onTap: _started ? null : _pickStart,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(context.l10n.endDate),
            subtitle: Text(
              lastDay == null
                  ? context.l10n.noEndDate
                  : Labels.date(context, lastDay),
            ),
            onTap: _pickEnd,
            trailing: lastDay == null
                ? null
                : IconButton(
                    tooltip: context.l10n.removeEndDate,
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() {
                      _lastDay = null;
                      _error = null;
                    }),
                  ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(context.l10n.time),
            subtitle: Text(
              time == null
                  ? context.l10n.noTime
                  : Labels.timeOfDay(context, time),
            ),
            onTap: _pickTime,
            trailing: time == null
                ? null
                : IconButton(
                    tooltip: context.l10n.removeTime,
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _time = null),
                  ),
          ),
          if (_error case final error?)
            Text(
              error,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(context.l10n.save)),
      ],
    );
  }

  Future<LocalDate?> _pickDate(LocalDate first, LocalDate initial) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(first)
          ? first.calendarDate
          : initial.calendarDate,
      firstDate: first.calendarDate,
      lastDate: DateTime(first.calendarDate.year + 100, 12, 31),
    );
    return picked == null ? null : LocalDate.fromDateTime(picked);
  }

  Future<void> _pickStart() async {
    final selected = await _pickDate(widget.today, _start);
    if (!mounted || selected == null) return;
    setState(() {
      _start = selected;
      _error = null;
    });
  }

  Future<void> _pickEnd() async {
    final selected = await _pickDate(_start, _lastDay ?? _start);
    if (!mounted || selected == null) return;
    setState(() {
      _lastDay = selected;
      _error = null;
    });
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 8, minute: 0),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (mounted && time != null) setState(() => _time = time);
  }

  void _submit() {
    final lastDay = _lastDay;
    final time = _time;
    if (!_daily && _weekdays.isEmpty) {
      setState(() => _error = context.l10n.selectWeekday);
      return;
    }
    if (lastDay != null && lastDay.isBefore(_start)) {
      setState(() => _error = context.l10n.invalidEndDate);
      return;
    }
    Navigator.pop<ScheduleDraft>(context, (
      recurrence: _daily
          ? const Recurrence.daily()
          : Recurrence.weekly(_weekdays),
      minutesAfterMidnight: time == null ? null : time.hour * 60 + time.minute,
      startsOn: _start,
      endsBefore: lastDay?.plusDays(1),
      label: _label,
    ));
  }
}
