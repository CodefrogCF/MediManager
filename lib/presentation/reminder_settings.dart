import 'package:flutter/material.dart';

import '../data/android_reminders.dart';
import '../data/app_database.dart';
import '../data/reminder_repository.dart';
import 'labels.dart';

class ReminderSettings extends StatefulWidget {
  const ReminderSettings({
    required this.reminders,
    required this.scheduleId,
    required this.slot,
    required this.medicationActive,
    super.key,
  });

  final AndroidReminders reminders;
  final int scheduleId;
  final String slot;
  final bool medicationActive;

  @override
  State<ReminderSettings> createState() => _ReminderSettingsState();
}

class _ReminderSettingsState extends State<ReminderSettings> {
  late final _settings = widget.reminders.settings.watch(widget.scheduleId);

  Future<void> _edit(SlotReminder? previous) async {
    final reminders = widget.reminders;
    final draft = await showDialog<_ReminderDraft>(
      context: context,
      builder: (_) => _ReminderEditor(
        previous: previous,
        reminders: reminders,
        slot: widget.slot,
      ),
    );
    if (!mounted || draft == null) return;
    try {
      await reminders.settings.save(
        widget.scheduleId,
        enabled: draft.enabled,
        reminderMinute: draft.minute,
        snoozeMinutes: draft.snooze,
      );
      if (mounted &&
          draft.enabled &&
          previous?.enabled != true &&
          !reminders.permission.value) {
        await reminders.requestPermission();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.saveError)));
      }
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: _settings,
    builder: (context, snapshot) {
      final current = snapshot.data;
      return ValueListenableBuilder(
        valueListenable: widget.reminders.permission,
        builder: (context, permission, _) => ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: Text(context.l10n.reminders),
          subtitle: Text(switch ((
            snapshot.hasError,
            current?.enabled,
            widget.medicationActive,
            permission,
          )) {
            (true, _, _, _) => context.l10n.loadError,
            (_, true, false, _) => context.l10n.remindersPaused,
            (_, true, _, false) => context.l10n.notificationPermission,
            (_, true, _, true) => _timeLabel(context, current?.reminderMinute),
            _ => context.l10n.inactive,
          }),
          trailing: const Icon(Icons.chevron_right),
          onTap:
              snapshot.hasError ||
                  snapshot.connectionState == ConnectionState.waiting
              ? null
              : () => _edit(current),
        ),
      );
    },
  );
}

typedef _ReminderDraft = ({bool enabled, int? minute, int snooze});

class _ReminderEditor extends StatefulWidget {
  const _ReminderEditor({
    required this.previous,
    required this.reminders,
    required this.slot,
  });

  final SlotReminder? previous;
  final AndroidReminders reminders;
  final String slot;

  @override
  State<_ReminderEditor> createState() => _ReminderEditorState();
}

class _ReminderEditorState extends State<_ReminderEditor> {
  late bool _enabled = widget.previous?.enabled ?? false;
  late int? _minute = widget.previous?.reminderMinute;
  late int _snooze =
      widget.previous?.snoozeMinutes ?? ReminderRepository.defaultSnoozeMinutes;

  Future<void> _pickTime() async {
    final minute = _minute;
    final selected = await showTimePicker(
      context: context,
      initialTime: minute == null
          ? const TimeOfDay(hour: 8, minute: 0)
          : TimeOfDay(hour: minute ~/ 60, minute: minute % 60),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (mounted && selected != null) {
      setState(() => _minute = selected.hour * 60 + selected.minute);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    title: Text(context.l10n.reminders),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.slot),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(context.l10n.enableReminders),
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(context.l10n.reminderTime),
          subtitle: Text(_timeLabel(context, _minute)),
          onTap: _enabled ? _pickTime : null,
          trailing: _enabled && _minute != null
              ? IconButton(
                  tooltip: context.l10n.useScheduledTime,
                  onPressed: () => setState(() => _minute = null),
                  icon: const Icon(Icons.clear),
                )
              : null,
        ),
        DropdownButtonFormField<int>(
          initialValue: _snooze,
          decoration: InputDecoration(labelText: context.l10n.snoozeInterval),
          items: [
            for (final minutes in {
              ...ReminderRepository.snoozeOptions,
              _snooze,
            }.toList()..sort())
              DropdownMenuItem(
                value: minutes,
                child: Text(context.l10n.minutes(minutes)),
              ),
          ],
          onChanged: _enabled
              ? (value) => setState(() => _snooze = value!)
              : null,
        ),
        if (_enabled) ...[
          const SizedBox(height: 12),
          Text(context.l10n.reminderDetails),
          ValueListenableBuilder(
            valueListenable: widget.reminders.exactAlarmsAllowed,
            builder: (context, allowed, _) => allowed
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.reminderTiming),
                      TextButton(
                        onPressed: widget.reminders.openExactAlarmSettings,
                        child: Text(context.l10n.allowPreciseReminders),
                      ),
                    ],
                  ),
          ),
          if (widget.previous?.enabled == true)
            ValueListenableBuilder(
              valueListenable: widget.reminders.permission,
              builder: (_, allowed, _) => allowed
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: widget.reminders.openSettings,
                      child: Text(context.l10n.notificationSettings),
                    ),
            ),
        ],
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.cancel),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, (
          enabled: _enabled,
          minute: _minute,
          snooze: _snooze,
        )),
        child: Text(context.l10n.save),
      ),
    ],
  );
}

String _timeLabel(BuildContext context, int? minute) => minute == null
    ? context.l10n.useScheduledTime
    : Labels.scheduleTime(context, minute);
