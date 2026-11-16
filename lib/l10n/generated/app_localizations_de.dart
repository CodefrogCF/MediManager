// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get app => 'MediManager';

  @override
  String get today => 'Heute';

  @override
  String get reminders => 'Erinnerungen';

  @override
  String get enableReminders => 'Erinnerungen aktivieren';

  @override
  String get remindersPaused => 'Für dieses inaktive Medikament pausiert';

  @override
  String get notificationPermission =>
      'Android-Benachrichtigungen sind deaktiviert.';

  @override
  String get notificationSettings => 'Android-Einstellungen öffnen';

  @override
  String get reminderTime => 'Erinnerungszeit';

  @override
  String get useScheduledTime => 'Uhrzeit aus Einnahmeplan';

  @override
  String get reminderDetails =>
      'Erinnerungen folgen den Tagen des Einnahmeplans. Pläne ohne Uhrzeit brauchen eine eigene Erinnerungszeit.';

  @override
  String get reminderTiming => 'Android kann Erinnerungen verzögern.';

  @override
  String get snoozeInterval => 'Dauer der Verschiebung';

  @override
  String get remindLater => 'Später erinnern';

  @override
  String get snoozeError => 'Die Erinnerung konnte nicht verschoben werden.';

  @override
  String get archive => 'Verlauf';

  @override
  String get medications => 'Medikamente';

  @override
  String get active => 'Aktiv';

  @override
  String get inactive => 'Inaktiv';

  @override
  String get noActiveMedications => 'Keine aktiven Medikamente';

  @override
  String get noInactiveMedications => 'Keine inaktiven Medikamente';

  @override
  String get addMedication => 'Medikament hinzufügen';

  @override
  String get editMedication => 'Medikament bearbeiten';

  @override
  String get name => 'Name';

  @override
  String get nameRequired => 'Gib einen Namen ein.';

  @override
  String get dosage => 'Dosierung (optional)';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get loadError => 'Die Daten konnten nicht geladen werden.';

  @override
  String get saveError => 'Die Änderung konnte nicht gespeichert werden.';

  @override
  String get medicationMissing => 'Dieses Medikament ist nicht mehr verfügbar.';

  @override
  String get activate => 'Aktivieren';

  @override
  String get deactivate => 'Deaktivieren';

  @override
  String get deactivateTitle => 'Medikament deaktivieren?';

  @override
  String get deactivateDetails =>
      'Laufende Pläne enden heute. Künftige Starts entfallen. Der Einnahmeverlauf bleibt verfügbar.';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteTitle => 'Medikament löschen?';

  @override
  String get deleteDetails => 'Das Medikament wird dauerhaft entfernt.';

  @override
  String get deleteWithSchedule =>
      'Dieses Medikament hat gespeicherte Pläne. Du kannst es deaktivieren.';

  @override
  String get schedules => 'Einnahmepläne';

  @override
  String get addSchedule => 'Plan hinzufügen';

  @override
  String get editSchedule => 'Plan bearbeiten';

  @override
  String get noSchedules => 'Keine laufenden oder künftigen Einnahmepläne';

  @override
  String get stopSchedule => 'Plan beenden';

  @override
  String get stopScheduleTitle => 'Einnahmeplan beenden?';

  @override
  String get stopCurrentSchedule => 'Der Plan endet nach dem heutigen Tag.';

  @override
  String get cancelUpcomingSchedule => 'Der geplante Start entfällt.';

  @override
  String get daily => 'Täglich';

  @override
  String get weekly => 'Ausgewählte Wochentage';

  @override
  String get selectWeekday => 'Wähle mindestens einen Wochentag.';

  @override
  String get startDate => 'Erster Tag';

  @override
  String get endDate => 'Letzter Tag (optional)';

  @override
  String get invalidEndDate => 'Der letzte Tag liegt vor dem ersten Tag.';

  @override
  String get time => 'Uhrzeit (optional)';

  @override
  String get noEndDate => 'Kein Enddatum';

  @override
  String get noTime => 'Ohne Uhrzeit';

  @override
  String get removeTime => 'Uhrzeit entfernen';

  @override
  String get removeEndDate => 'Enddatum entfernen';

  @override
  String get emptyToday => 'Heute sind keine Einnahmen geplant.';

  @override
  String get emptyDate => 'Für diesen Tag sind keine Einnahmen geplant.';

  @override
  String get previousDay => 'Vorheriger Tag';

  @override
  String get nextDay => 'Nächster Tag';

  @override
  String get taken => 'Genommen';

  @override
  String get undo => 'Rückgängig';

  @override
  String get confirmedStatus => 'Bestätigt';

  @override
  String get unconfirmedStatus => 'Nicht bestätigt';

  @override
  String get correctedStatus => 'Korrigiert';

  @override
  String get eventHistory => 'Protokoll der Einnahme';

  @override
  String get backfill => 'Nachtragen';

  @override
  String get backfilled => 'Nachträglich bestätigt';

  @override
  String get backfillTitle => 'Einnahme nachtragen';

  @override
  String get reportedTime => 'Einnahmezeit (optional)';

  @override
  String get invalidReportedTime =>
      'Diese Uhrzeit gibt es an diesem Tag in der aktuellen Zeitzone nicht.';

  @override
  String get history => 'Einnahmeverlauf';

  @override
  String get noHistory => 'Keine Einnahmen erfasst.';

  @override
  String get confirmed => 'Einnahme bestätigt';

  @override
  String get corrected => 'Bestätigung zurückgenommen';

  @override
  String get mondayShort => 'Mo';

  @override
  String get tuesdayShort => 'Di';

  @override
  String get wednesdayShort => 'Mi';

  @override
  String get thursdayShort => 'Do';

  @override
  String get fridayShort => 'Fr';

  @override
  String get saturdayShort => 'Sa';

  @override
  String get sundayShort => 'So';

  @override
  String get slotLabel => 'Bezeichnung des Zeitpunkts (optional)';

  @override
  String get settings => 'Einstellungen';

  @override
  String get appearance => 'Darstellung';

  @override
  String get themeMode => 'Designmodus';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Hell';

  @override
  String get darkTheme => 'Dunkel';

  @override
  String get accentColor => 'Akzentfarbe';

  @override
  String get greenAccent => 'Grün';

  @override
  String get blueAccent => 'Blau';

  @override
  String get tealAccent => 'Türkis';

  @override
  String get orangeAccent => 'Orange';

  @override
  String get purpleAccent => 'Violett';

  @override
  String get redAccent => 'Rot';

  @override
  String get language => 'Sprache';

  @override
  String get dataAndPrivacy => 'Daten und Datenschutz';

  @override
  String get about => 'Über MediManager';

  @override
  String get localPrivacy =>
      'Medikamentendaten bleiben auf diesem Gerät oder im Browserprofil. MediManager benötigt kein Konto und lädt keine Medikamentendaten automatisch hoch.';

  @override
  String get appProtection =>
      'Schütze deine Daten auf gemeinsam genutzten Geräten mit der Gerätesperre oder einem eigenen Benutzerprofil.';

  @override
  String get backupPlaintext =>
      'Sicherungen enthalten lesbare, unverschlüsselte Gesundheitsdaten. Wähle einen Speicherort, dem du vertraust.';

  @override
  String get exportBackup => 'Sicherung exportieren';

  @override
  String get importBackup => 'Sicherung wiederherstellen';

  @override
  String get backupSaved => 'Die Sicherung wurde exportiert.';

  @override
  String get backupDownloadStarted =>
      'Der Download der Sicherung wurde gestartet.';

  @override
  String get backupRestored => 'Die Sicherung wurde wiederhergestellt.';

  @override
  String get restoreTitle => 'Lokale Daten ersetzen?';

  @override
  String get restoreWarning =>
      'Die Sicherung ersetzt deine lokalen Daten und Einstellungen. Exportiere bei Bedarf zuerst eine Sicherung deiner aktuellen Daten.';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get deleteAllData => 'Alle lokalen Daten löschen';

  @override
  String get deleteAllTitle => 'Alle lokalen Daten löschen?';

  @override
  String get deleteAllWarning =>
      'Medikamente, Pläne, Einnahmen, Erinnerungen und Einstellungen werden dauerhaft aus MediManager gelöscht. Exportierte Dateien bleiben an ihrem Speicherort.';

  @override
  String get dataDeleted => 'Die lokalen Daten wurden gelöscht.';

  @override
  String get backupInvalid => 'Diese Sicherung ist ungültig oder beschädigt.';

  @override
  String get backupUnsupported =>
      'Diese Version des Sicherungsformats wird nicht unterstützt.';

  @override
  String get backupTooLarge => 'Die Sicherung überschreitet 32 MiB.';

  @override
  String get backupOperationFailed =>
      'Der Datenvorgang konnte nicht abgeschlossen werden.';

  @override
  String get backupBusy => 'Datenvorgang läuft.';

  @override
  String get reminderChannelName => 'Einnahmeerinnerungen';

  @override
  String get reminderChannelDescription =>
      'Optionale Erinnerungen an geplante Einnahmen';

  @override
  String get plannedIntake => 'Geplante Einnahme';

  @override
  String periodFrom(String start) {
    return 'Ab $start';
  }

  @override
  String periodRange(String start, String end) {
    return '$start bis $end';
  }

  @override
  String scheduledFor(String date, String time) {
    return 'Plan: $date, $time';
  }

  @override
  String recordedAt(String timestamp) {
    return 'Erfasst: $timestamp';
  }

  @override
  String reportedAt(String timestamp) {
    return 'Einnahmezeit: $timestamp';
  }

  @override
  String backfillDate(String date) {
    return 'Einnahmedatum: $date';
  }

  @override
  String minutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes Minuten',
      one: '1 Minute',
    );
    return '$_temp0';
  }

  @override
  String snoozed(int minutes) {
    return 'Erinnerung um $minutes Minuten verschoben.';
  }

  @override
  String slotIdentity(int id) {
    return 'Plan $id';
  }

  @override
  String actionFor(String action, String medication, String slot) {
    return '$action für $medication, $slot';
  }

  @override
  String backupSummary(String date, int medications, int events) {
    return 'Sicherung vom $date. $medications Medikamente und $events Einnahmeprotokolle.';
  }

  @override
  String appVersion(String version) {
    return 'Version $version';
  }
}
