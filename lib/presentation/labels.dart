import 'package:flutter/material.dart';

import '../domain/local_date.dart';
import '../domain/medication.dart';

abstract final class Labels {
  static const app = 'MediManager';
  static const today = 'Heute';
  static const reminders = 'Erinnerungen';
  static const enableReminders = 'Erinnerungen aktivieren';
  static const remindersPaused = 'Für dieses inaktive Medikament pausiert';
  static const notificationPermission =
      'Android-Benachrichtigungen sind deaktiviert.';
  static const notificationSettings = 'Android-Einstellungen öffnen';
  static const reminderTime = 'Erinnerungszeit';
  static const useScheduledTime = 'Uhrzeit aus Einnahmeplan';
  static const reminderDetails =
      'Erinnerungen folgen den Tagen des Einnahmeplans. Pläne ohne Uhrzeit brauchen eine eigene Erinnerungszeit.';
  static const reminderTiming = 'Android kann Erinnerungen verzögern.';
  static const snoozeInterval = 'Dauer der Verschiebung';
  static const remindLater = 'Später erinnern';
  static const snoozeError = 'Die Erinnerung konnte nicht verschoben werden.';
  static const archive = 'Verlauf';
  static const medications = 'Medikamente';
  static const active = 'Aktiv';
  static const inactive = 'Inaktiv';
  static const noActiveMedications = 'Keine aktiven Medikamente';
  static const noInactiveMedications = 'Keine inaktiven Medikamente';
  static const addMedication = 'Medikament hinzufügen';
  static const editMedication = 'Medikament bearbeiten';
  static const name = 'Name';
  static const nameRequired = 'Gib einen Namen ein.';
  static const dosage = 'Dosierung (optional)';
  static const save = 'Speichern';
  static const cancel = 'Abbrechen';
  static const loadError = 'Die Daten konnten nicht geladen werden.';
  static const saveError = 'Die Änderung konnte nicht gespeichert werden.';
  static const medicationMissing =
      'Dieses Medikament ist nicht mehr verfügbar.';
  static const activate = 'Aktivieren';
  static const deactivate = 'Deaktivieren';
  static const deactivateTitle = 'Medikament deaktivieren?';
  static const deactivateDetails =
      'Laufende Pläne enden heute. Künftige Starts entfallen. '
      'Der Einnahmeverlauf bleibt verfügbar.';
  static const delete = 'Löschen';
  static const deleteTitle = 'Medikament löschen?';
  static const deleteDetails = 'Das Medikament wird dauerhaft entfernt.';
  static const deleteWithSchedule =
      'Dieses Medikament hat gespeicherte Pläne. Du kannst es deaktivieren.';
  static const schedules = 'Einnahmepläne';
  static const addSchedule = 'Plan hinzufügen';
  static const editSchedule = 'Plan bearbeiten';
  static const noSchedules = 'Keine laufenden oder künftigen Einnahmepläne';
  static const stopSchedule = 'Plan beenden';
  static const stopScheduleTitle = 'Einnahmeplan beenden?';
  static const stopCurrentSchedule = 'Der Plan endet nach dem heutigen Tag.';
  static const cancelUpcomingSchedule = 'Der geplante Start entfällt.';
  static const daily = 'Täglich';
  static const weekly = 'Ausgewählte Wochentage';
  static const selectWeekday = 'Wähle mindestens einen Wochentag.';
  static const startDate = 'Erster Tag';
  static const endDate = 'Letzter Tag (optional)';
  static const invalidEndDate = 'Der letzte Tag liegt vor dem ersten Tag.';
  static const time = 'Uhrzeit (optional)';
  static const noEndDate = 'Kein Enddatum';
  static const noTime = 'Ohne Uhrzeit';
  static const removeTime = 'Uhrzeit entfernen';
  static const removeEndDate = 'Enddatum entfernen';
  static const emptyToday = 'Heute sind keine Einnahmen geplant.';
  static const emptyDate = 'Für diesen Tag sind keine Einnahmen geplant.';
  static const previousDay = 'Vorheriger Tag';
  static const nextDay = 'Nächster Tag';
  static const taken = 'Genommen';
  static const undo = 'Rückgängig';
  static const confirmedStatus = 'Bestätigt';
  static const unconfirmedStatus = 'Nicht bestätigt';
  static const correctedStatus = 'Korrigiert';
  static const eventHistory = 'Protokoll der Einnahme';
  static const backfill = 'Nachtragen';
  static const backfilled = 'Nachträglich bestätigt';
  static const backfillTitle = 'Einnahme nachtragen';
  static const reportedTime = 'Einnahmezeit (optional)';
  static const invalidReportedTime =
      'Diese Uhrzeit gibt es an diesem Tag in der aktuellen Zeitzone nicht.';
  static const history = 'Einnahmeverlauf';
  static const noHistory = 'Keine Einnahmen erfasst.';
  static const confirmed = 'Einnahme bestätigt';
  static const corrected = 'Bestätigung zurückgenommen';
  static const weekdays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];

  static String recurrence(Recurrence recurrence) => recurrence.isDaily
      ? daily
      : recurrence.weekdays.map((day) => weekdays[day - 1]).join(', ');

  static String date(BuildContext context, LocalDate date) =>
      MaterialLocalizations.of(context).formatCompactDate(date.calendarDate);

  static String timeOfDay(BuildContext context, TimeOfDay time) =>
      MaterialLocalizations.of(context)
          .formatTimeOfDay(time, alwaysUse24HourFormat: true);

  static String scheduleTime(BuildContext context, int? minutes) =>
      minutes == null
      ? noTime
      : timeOfDay(
          context,
          TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
        );

  static String timestamp(BuildContext context, DateTime timestamp) {
    final local = timestamp.toLocal();
    return '${date(context, LocalDate.fromDateTime(local))}, '
        '${timeOfDay(context, TimeOfDay.fromDateTime(local))}';
  }

  static String period(String start, String? end) =>
      end == null ? 'Ab $start' : '$start bis $end';

  static String scheduledFor(String date, String time) => 'Plan: $date, $time';
  static String recordedAt(String timestamp) => 'Erfasst: $timestamp';
  static String reportedAt(String timestamp) => 'Einnahmezeit: $timestamp';
  static String backfillDate(String date) => 'Einnahmedatum: $date';
  static String minutes(int minutes) => '$minutes Minuten';
  static String snoozed(int minutes) =>
      'Erinnerung um $minutes Minuten verschoben.';
}
