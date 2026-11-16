import 'package:flutter/material.dart';

import '../data/android_reminders.dart';
import '../data/intake_repository.dart';
import '../data/medication_repository.dart';
import '../domain/intake_event.dart';
import '../domain/medication.dart';
import 'labels.dart';
import 'reminder_settings.dart';
import 'schedule_editor.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({
    required this.medications,
    required this.intakes,
    this.reminders,
    this.onSettings,
    super.key,
  });

  final MedicationRepository medications;
  final IntakeRepository intakes;
  final AndroidReminders? reminders;
  final VoidCallback? onSettings;

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  late final _rows = widget.medications.watchMedications();
  var _activeOnly = true;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(context.l10n.medications),
      actions: [
        if (widget.onSettings != null)
          IconButton(
            tooltip: context.l10n.settings,
            onPressed: widget.onSettings,
            icon: const Icon(Icons.settings_outlined),
          ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      tooltip: context.l10n.addMedication,
      onPressed: _addMedication,
      child: const Icon(Icons.add),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: true, label: Text(context.l10n.active)),
              ButtonSegment(value: false, label: Text(context.l10n.inactive)),
            ],
            selected: {_activeOnly},
            onSelectionChanged: (selection) =>
                setState(() => _activeOnly = selection.single),
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: _rows,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(context.l10n.loadError));
              }
              final data = snapshot.data;
              if (data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              final visible = data
                  .where((medication) => medication.isActive == _activeOnly)
                  .toList();
              if (visible.isEmpty) {
                return Center(
                  child: Text(
                    _activeOnly
                        ? context.l10n.noActiveMedications
                        : context.l10n.noInactiveMedications,
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final medication = visible[index];
                  final dosage = medication.dosage;
                  return ListTile(
                    title: Text(medication.name),
                    subtitle: dosage == null ? null : Text(dosage),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _MedicationDetail(
                          id: medication.id,
                          medications: widget.medications,
                          intakes: widget.intakes,
                          reminders: widget.reminders,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  );

  Future<void> _addMedication() async {
    final draft = await _editMedication(context);
    if (draft == null || !mounted) return;
    await _save(context, () async {
      await widget.medications.createMedication(
        name: draft.name,
        dosage: draft.dosage,
      );
      if (mounted) setState(() => _activeOnly = true);
    });
  }
}

enum _MedicationAction { edit, toggleActive, delete }

class _MedicationDetail extends StatefulWidget {
  const _MedicationDetail({
    required this.id,
    required this.medications,
    required this.intakes,
    this.reminders,
  });

  final int id;
  final MedicationRepository medications;
  final IntakeRepository intakes;
  final AndroidReminders? reminders;

  @override
  State<_MedicationDetail> createState() => _MedicationDetailState();
}

class _MedicationDetailState extends State<_MedicationDetail> {
  late final _medication = widget.medications.watchMedication(widget.id);
  late final _schedules = widget.medications.watchSchedules(widget.id);

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: _medication,
    builder: (context, snapshot) {
      final medication = snapshot.data;
      return Scaffold(
        appBar: AppBar(
          title: Text(medication?.name ?? context.l10n.medications),
          actions: [
            if (medication != null)
              PopupMenuButton<_MedicationAction>(
                onSelected: (value) =>
                    _applyMedicationAction(value, medication),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: _MedicationAction.edit,
                    child: Text(context.l10n.editMedication),
                  ),
                  PopupMenuItem(
                    value: _MedicationAction.toggleActive,
                    child: Text(
                      medication.isActive
                          ? context.l10n.deactivate
                          : context.l10n.activate,
                    ),
                  ),
                  PopupMenuItem(
                    value: _MedicationAction.delete,
                    child: Text(context.l10n.delete),
                  ),
                ],
              ),
          ],
        ),
        body: _body(snapshot),
      );
    },
  );

  Widget _body(AsyncSnapshot<Medication?> snapshot) {
    if (snapshot.hasError) return Center(child: Text(context.l10n.loadError));
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    final medication = snapshot.data;
    if (medication == null) {
      return Center(child: Text(context.l10n.medicationMissing));
    }
    final dosage = medication.dosage;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        ListTile(
          title: Text(
            medication.isActive ? context.l10n.active : context.l10n.inactive,
          ),
          subtitle: dosage == null ? null : Text(dosage),
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: Text(context.l10n.history),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push<void>(
            context,
            MaterialPageRoute(
              builder: (_) => _IntakeHistory(
                entries: widget.intakes.watchForMedication(medication.id),
              ),
            ),
          ),
        ),
        const Divider(),
        ListTile(
          title: Text(context.l10n.schedules),
          trailing: medication.isActive
              ? IconButton(
                  tooltip: context.l10n.addSchedule,
                  icon: const Icon(Icons.add),
                  onPressed: () => _editSchedule(),
                )
              : null,
        ),
        StreamBuilder(
          stream: _schedules,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ListTile(title: Text(context.l10n.loadError));
            }
            final schedules = snapshot.data;
            if (schedules == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final today = widget.medications.today;
            final current = schedules.where(
              (schedule) => schedule.isCurrentOrUpcoming(today),
            );
            if (current.isEmpty) {
              return ListTile(title: Text(context.l10n.noSchedules));
            }
            return Column(
              children: [
                for (final schedule in current) ...[
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Labels.slot(context, schedule)),
                        Text(Labels.recurrence(context, schedule.recurrence)),
                      ],
                    ),
                    subtitle: Text(
                      [
                        Labels.scheduleTime(
                          context,
                          schedule.minutesAfterMidnight,
                        ),
                        Labels.period(
                          context,
                          Labels.date(context, schedule.startsOn),
                          schedule.endsBefore == null
                              ? null
                              : Labels.date(
                                  context,
                                  schedule.endsBefore!.plusDays(-1),
                                ),
                        ),
                      ].join('\n'),
                    ),
                    trailing: medication.isActive && schedule.canChange(today)
                        ? PopupMenuButton<bool>(
                            onSelected: (edit) => edit
                                ? _editSchedule(schedule)
                                : _stopSchedule(schedule),
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                value: true,
                                child: Text(context.l10n.editSchedule),
                              ),
                              PopupMenuItem(
                                value: false,
                                child: Text(context.l10n.stopSchedule),
                              ),
                            ],
                          )
                        : null,
                  ),
                  if (widget.reminders case final reminders?)
                    ReminderSettings(
                      key: ValueKey(schedule.id),
                      reminders: reminders,
                      scheduleId: schedule.id,
                      slot: Labels.slot(context, schedule),
                      medicationActive: medication.isActive,
                    ),
                  const Divider(),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _applyMedicationAction(
    _MedicationAction action,
    Medication medication,
  ) async {
    switch (action) {
      case _MedicationAction.edit:
        final draft = await _editMedication(context, medication);
        if (draft == null || !mounted) return;
        await _save(
          context,
          () => widget.medications.updateMedication(
            medication.id,
            name: draft.name,
            dosage: draft.dosage,
          ),
        );
      case _MedicationAction.toggleActive:
        if (medication.isActive) {
          final accepted = await _confirm(
            context,
            context.l10n.deactivateTitle,
            context.l10n.deactivateDetails,
            context.l10n.deactivate,
          );
          if (!accepted || !mounted) return;
        }
        await _save(
          context,
          () =>
              widget.medications.setActive(medication.id, !medication.isActive),
        );
      case _MedicationAction.delete:
        final accepted = await _confirm(
          context,
          context.l10n.deleteTitle,
          context.l10n.deleteDetails,
          context.l10n.delete,
        );
        if (!accepted || !mounted) return;
        await _save(context, () async {
          final deleted = await widget.medications.deleteMedication(
            medication.id,
          );
          if (!mounted) return;
          if (deleted) {
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.deleteWithSchedule)),
            );
          }
        });
    }
  }

  Future<void> _editSchedule([MedicationSchedule? schedule]) async {
    final draft = await showDialog<ScheduleDraft>(
      context: context,
      builder: (_) =>
          ScheduleEditor(today: widget.medications.today, schedule: schedule),
    );
    if (draft == null || !mounted) return;
    await _save(context, () async {
      await widget.medications.saveSchedule(
        medicationId: widget.id,
        replacesScheduleId: schedule?.id,
        recurrence: draft.recurrence,
        minutesAfterMidnight: draft.minutesAfterMidnight,
        startsOn: draft.startsOn,
        endsBefore: draft.endsBefore,
        label: draft.label,
      );
    });
  }

  Future<void> _stopSchedule(MedicationSchedule schedule) async {
    final accepted = await _confirm(
      context,
      context.l10n.stopScheduleTitle,
      widget.medications.today.isBefore(schedule.startsOn)
          ? context.l10n.cancelUpcomingSchedule
          : context.l10n.stopCurrentSchedule,
      context.l10n.stopSchedule,
    );
    if (!accepted || !mounted) return;
    await _save(context, () => widget.medications.stopSchedule(schedule.id));
  }
}

class _IntakeHistory extends StatelessWidget {
  const _IntakeHistory({required this.entries});

  final Stream<List<MedicationIntakeEvent>> entries;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.history)),
    body: StreamBuilder(
      stream: entries,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(context.l10n.loadError));
        }
        final rows = snapshot.data;
        if (rows == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (rows.isEmpty) return Center(child: Text(context.l10n.noHistory));
        return ListView.builder(
          itemCount: rows.length,
          itemBuilder: (context, index) {
            final entry = rows[index];
            final event = entry.event;
            final reported = event.reportedIntakeAt;
            return ListTile(
              title: Text(switch (event.kind) {
                IntakeEventKind.confirmation => context.l10n.confirmed,
                IntakeEventKind.correction => context.l10n.corrected,
              }),
              subtitle: Text(
                [
                  entry.details.name,
                  ?entry.details.dosage,
                  Labels.slot(context, entry.schedule),
                  context.l10n.scheduledFor(
                    Labels.date(context, event.scheduledDate),
                    Labels.scheduleTime(
                      context,
                      entry.schedule.minutesAfterMidnight,
                    ),
                  ),
                  context.l10n.recordedAt(
                    Labels.timestamp(context, event.recordedAt),
                  ),
                  if (reported != null)
                    context.l10n.reportedAt(
                      Labels.timestamp(context, reported),
                    ),
                ].join('\n'),
              ),
            );
          },
        );
      },
    ),
  );
}

typedef _MedicationDraft = ({String name, String? dosage});

Future<_MedicationDraft?> _editMedication(
  BuildContext context, [
  Medication? medication,
]) {
  final key = GlobalKey<FormState>();
  var name = '';
  String? dosage;
  return showDialog<_MedicationDraft>(
    context: context,
    builder: (context) => AlertDialog(
      scrollable: true,
      title: Text(
        medication == null
            ? context.l10n.addMedication
            : context.l10n.editMedication,
      ),
      content: Form(
        key: key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: medication?.name,
              decoration: InputDecoration(labelText: context.l10n.name),
              autofocus: true,
              textInputAction: TextInputAction.next,
              validator: (value) => value == null || value.trim().isEmpty
                  ? context.l10n.nameRequired
                  : null,
              onSaved: (value) => name = value!,
            ),
            TextFormField(
              initialValue: medication?.dosage,
              decoration: InputDecoration(labelText: context.l10n.dosage),
              onSaved: (value) => dosage = value,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final form = key.currentState!;
            if (!form.validate()) return;
            form.save();
            Navigator.pop<_MedicationDraft>(context, (
              name: name,
              dosage: dosage,
            ));
          },
          child: Text(context.l10n.save),
        ),
      ],
    ),
  );
}

Future<bool> _confirm(
  BuildContext context,
  String title,
  String details,
  String action,
) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(details),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(action),
          ),
        ],
      ),
    ) ??
    false;

Future<void> _save(BuildContext context, Future<void> Function() action) async {
  try {
    await action();
  } catch (_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.saveError)));
  }
}
