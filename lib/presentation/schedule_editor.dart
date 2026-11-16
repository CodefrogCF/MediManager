import 'package:flutter/material.dart';

import '../domain/local_date.dart';
import '../domain/medication.dart';
import 'labels.dart';

typedef ScheduleDraft = ({
  Recurrence recurrence,
  int? minutesAfterMidnight,
  LocalDate startsOn,
  LocalDate? endsBefore,
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

  bool get _started {
    final schedule = widget.schedule;
    return schedule != null && !widget.today.isBefore(schedule.startsOn);
  }

  @override
  void initState() {
    super.initState();
    final schedule = widget.schedule;
    _daily = schedule?.recurrence.isDaily ?? true;
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
        widget.schedule == null ? Labels.addSchedule : Labels.editSchedule,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<bool>(
            isExpanded: true,
            value: _daily,
            items: const [
              DropdownMenuItem(value: true, child: Text(Labels.daily)),
              DropdownMenuItem(value: false, child: Text(Labels.weekly)),
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
                    label: Text(Labels.weekdays[day - 1]),
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
            title: const Text(Labels.startDate),
            subtitle: Text(Labels.date(context, _start)),
            onTap: _started ? null : _pickStart,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(Labels.endDate),
            subtitle: Text(
              lastDay == null
                  ? Labels.noEndDate
                  : Labels.date(context, lastDay),
            ),
            onTap: _pickEnd,
            trailing: lastDay == null
                ? null
                : IconButton(
                    tooltip: Labels.removeEndDate,
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() {
                      _lastDay = null;
                      _error = null;
                    }),
                  ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(Labels.time),
            subtitle: Text(
              time == null ? Labels.noTime : Labels.timeOfDay(context, time),
            ),
            onTap: _pickTime,
            trailing: time == null
                ? null
                : IconButton(
                    tooltip: Labels.removeTime,
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
          child: const Text(Labels.cancel),
        ),
        FilledButton(onPressed: _submit, child: const Text(Labels.save)),
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
      setState(() => _error = Labels.selectWeekday);
      return;
    }
    if (lastDay != null && lastDay.isBefore(_start)) {
      setState(() => _error = Labels.invalidEndDate);
      return;
    }
    Navigator.pop<ScheduleDraft>(context, (
      recurrence: _daily
          ? const Recurrence.daily()
          : Recurrence.weekly(_weekdays),
      minutesAfterMidnight: time == null ? null : time.hour * 60 + time.minute,
      startsOn: _start,
      endsBefore: lastDay?.plusDays(1),
    ));
  }
}
