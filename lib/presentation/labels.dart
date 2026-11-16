import 'package:flutter/material.dart';

import '../domain/local_date.dart';
import '../domain/medication.dart';
import '../l10n/generated/app_localizations.dart';

extension LocalizedContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

abstract final class Labels {
  static List<String> weekdays(BuildContext context) {
    final l10n = context.l10n;
    return [
      l10n.mondayShort,
      l10n.tuesdayShort,
      l10n.wednesdayShort,
      l10n.thursdayShort,
      l10n.fridayShort,
      l10n.saturdayShort,
      l10n.sundayShort,
    ];
  }

  static String recurrence(BuildContext context, Recurrence recurrence) =>
      recurrence.isDaily
      ? context.l10n.daily
      : recurrence.weekdays.map((day) => weekdays(context)[day - 1]).join(', ');

  static String date(BuildContext context, LocalDate date) =>
      MaterialLocalizations.of(context).formatCompactDate(date.calendarDate);

  static String timeOfDay(BuildContext context, TimeOfDay time) =>
      MaterialLocalizations.of(context)
          .formatTimeOfDay(time, alwaysUse24HourFormat: true);

  static String scheduleTime(BuildContext context, int? minutes) =>
      minutes == null
      ? context.l10n.noTime
      : timeOfDay(
          context,
          TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
        );

  static String timestamp(BuildContext context, DateTime timestamp) {
    final local = timestamp.toLocal();
    return '${date(context, LocalDate.fromDateTime(local))}, '
        '${timeOfDay(context, TimeOfDay.fromDateTime(local))}';
  }

  static String period(BuildContext context, String start, String? end) =>
      end == null
      ? context.l10n.periodFrom(start)
      : context.l10n.periodRange(start, end);

  static String slot(BuildContext context, MedicationSchedule schedule) =>
      schedule.label ?? context.l10n.slotIdentity(schedule.id);
}
