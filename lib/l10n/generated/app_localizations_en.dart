// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app => 'MediManager';

  @override
  String get today => 'Today';

  @override
  String get reminders => 'Reminders';

  @override
  String get enableReminders => 'Enable reminders';

  @override
  String get remindersPaused => 'Paused while this medication is inactive';

  @override
  String get notificationPermission => 'Android notifications are disabled.';

  @override
  String get notificationSettings => 'Open Android notification settings';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String get useScheduledTime => 'Use the planned time';

  @override
  String get reminderDetails =>
      'Reminders follow the days in the intake plan. Set a reminder time for slots without a planned time.';

  @override
  String get reminderTiming =>
      'Android may delay notifications without Alarms & reminders access.';

  @override
  String get allowPreciseReminders => 'Allow on-time reminders';

  @override
  String get snoozeInterval => 'Snooze interval';

  @override
  String get remindLater => 'Remind me later';

  @override
  String get snoozeError => 'Could not snooze the reminder.';

  @override
  String get archive => 'Archive';

  @override
  String get medications => 'Medications';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get noActiveMedications => 'No active medications';

  @override
  String get noInactiveMedications => 'No inactive medications';

  @override
  String get addMedication => 'Add medication';

  @override
  String get editMedication => 'Edit medication';

  @override
  String get name => 'Name';

  @override
  String get nameRequired => 'Enter a name.';

  @override
  String get dosage => 'Dosage (optional)';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get loadError => 'Could not load the data.';

  @override
  String get saveError => 'Could not save the change.';

  @override
  String get medicationMissing => 'This medication is no longer available.';

  @override
  String get activate => 'Activate';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get deactivateTitle => 'Deactivate medication?';

  @override
  String get deactivateDetails =>
      'Current plans end today. Upcoming starts are cancelled. The intake history stays available.';

  @override
  String get delete => 'Delete';

  @override
  String get deleteTitle => 'Delete medication?';

  @override
  String get deleteDetails => 'The medication will be permanently removed.';

  @override
  String get deleteWithSchedule =>
      'This medication has saved plans. You can deactivate it.';

  @override
  String get schedules => 'Intake plans';

  @override
  String get addSchedule => 'Add plan';

  @override
  String get editSchedule => 'Edit plan';

  @override
  String get noSchedules => 'No editable intake plans';

  @override
  String get planChangesFrom => 'Changes apply from';

  @override
  String get stopSchedule => 'End plan';

  @override
  String get stopScheduleTitle => 'End this intake plan?';

  @override
  String get stopCurrentSchedule => 'The plan ends after today.';

  @override
  String get cancelUpcomingSchedule => 'The scheduled start will be cancelled.';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Selected weekdays';

  @override
  String get selectWeekday => 'Select at least one weekday.';

  @override
  String get startDate => 'First day';

  @override
  String get endDate => 'Last day (optional)';

  @override
  String get invalidEndDate => 'The last day is before the first day.';

  @override
  String get time => 'Time (optional)';

  @override
  String get noEndDate => 'No end date';

  @override
  String get noTime => 'No time set';

  @override
  String get removeTime => 'Remove time';

  @override
  String get removeEndDate => 'Remove end date';

  @override
  String get emptyToday => 'There are no intakes planned for today.';

  @override
  String get emptyDate => 'There are no intakes planned for this day.';

  @override
  String get previousDay => 'Previous day';

  @override
  String get nextDay => 'Next day';

  @override
  String get taken => 'Taken';

  @override
  String get undo => 'Undo';

  @override
  String get confirmedStatus => 'Confirmed';

  @override
  String get unconfirmedStatus => 'Unconfirmed';

  @override
  String get correctedStatus => 'Corrected';

  @override
  String get eventHistory => 'Intake log';

  @override
  String get backfill => 'Record intake';

  @override
  String get backfilled => 'Confirmed retrospectively';

  @override
  String get backfillTitle => 'Record a past intake';

  @override
  String get reportedTime => 'Intake time (optional)';

  @override
  String get invalidReportedTime =>
      'This time does not exist on that day in the current time zone.';

  @override
  String get history => 'Intake history';

  @override
  String get noHistory => 'No intakes recorded.';

  @override
  String get confirmed => 'Intake confirmed';

  @override
  String get corrected => 'Confirmation undone';

  @override
  String get mondayShort => 'Mon';

  @override
  String get tuesdayShort => 'Tue';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get thursdayShort => 'Thu';

  @override
  String get fridayShort => 'Fri';

  @override
  String get saturdayShort => 'Sat';

  @override
  String get sundayShort => 'Sun';

  @override
  String get slotLabel => 'Slot name (optional)';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeMode => 'Theme mode';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get accentColor => 'Accent colour';

  @override
  String get greenAccent => 'Green';

  @override
  String get blueAccent => 'Blue';

  @override
  String get tealAccent => 'Teal';

  @override
  String get orangeAccent => 'Orange';

  @override
  String get purpleAccent => 'Purple';

  @override
  String get redAccent => 'Red';

  @override
  String get language => 'Language';

  @override
  String get dataAndPrivacy => 'Data and privacy';

  @override
  String get about => 'About MediManager';

  @override
  String get privacyPolicy => 'Privacy policy and limitations';

  @override
  String get licenses => 'Open-source licences';

  @override
  String get policyData =>
      'MediManager stores the medications, doses, schedules, confirmations, corrections, and preferences you enter. Its operator is CodefrogCF.';

  @override
  String get policyNotifications =>
      'Optional Android reminders use notification permission and can include medication names. You can grant Alarms & reminders access for more precise delivery. The Android notification settings control what is visible on the lock screen. Reboot access lets Android re-arm reminders.';

  @override
  String get policyWeb =>
      'The web host receives normal page requests, which can include your IP address. Your medication records stay in the site\'s browser storage. After the web app has loaded and cached its files, tracking works offline.';

  @override
  String get policyDeletion =>
      'Use Settings → Data and privacy to delete local records or export and restore them. Android system backup is disabled. Downloads and files you save or share remain in their chosen locations.';

  @override
  String get policyMedicalLimitations =>
      'MediManager records your confirmations. An unconfirmed slot has no current confirmation. MediManager cannot verify physical ingestion or provide medical advice, including advice about missed or repeated doses.';

  @override
  String get policyContact =>
      'For privacy questions, contact CodefrogCF through the MediManager repository on GitHub. Keep personal medication information out of public issues.';

  @override
  String get localPrivacy =>
      'Medication data stays on this device or in the browser profile. MediManager uses local storage and does not require an account or automatically upload medication data.';

  @override
  String get appProtection =>
      'Use a device lock or a separate user profile to protect your records on a shared device.';

  @override
  String get backupPlaintext =>
      'Backups contain readable, unencrypted health information. Choose a storage location you trust.';

  @override
  String get exportBackup => 'Export backup';

  @override
  String get importBackup => 'Restore backup';

  @override
  String get backupSaved => 'The backup was exported.';

  @override
  String get backupDownloadStarted => 'The backup download started.';

  @override
  String get backupRestored => 'The backup was restored.';

  @override
  String get restoreTitle => 'Replace local data?';

  @override
  String get restoreWarning =>
      'The backup replaces your local data and settings. Export a backup of your current data first if you want to keep it.';

  @override
  String get restore => 'Restore';

  @override
  String get deleteAllData => 'Delete all local data';

  @override
  String get deleteAllTitle => 'Delete all local data?';

  @override
  String get deleteAllWarning =>
      'Medications, plans, intakes, reminders, and settings will be permanently removed from MediManager. Exported files stay where you saved them.';

  @override
  String get dataDeleted => 'Local data was deleted.';

  @override
  String get backupInvalid => 'This backup is invalid or damaged.';

  @override
  String get backupUnsupported => 'This backup format version is unsupported.';

  @override
  String get backupTooLarge => 'The backup exceeds 32 MiB.';

  @override
  String get backupOperationFailed => 'Could not complete the data operation.';

  @override
  String get backupBusy => 'Data operation in progress.';

  @override
  String get reminderChannelName => 'Intake reminders';

  @override
  String get reminderChannelDescription =>
      'Optional reminders for scheduled intakes';

  @override
  String get plannedIntake => 'Scheduled intake';

  @override
  String periodFrom(String start) {
    return 'From $start';
  }

  @override
  String periodRange(String start, String end) {
    return '$start to $end';
  }

  @override
  String scheduledFor(String date, String time) {
    return 'Planned: $date, $time';
  }

  @override
  String recordedAt(String timestamp) {
    return 'Recorded: $timestamp';
  }

  @override
  String reportedAt(String timestamp) {
    return 'Intake time: $timestamp';
  }

  @override
  String backfillDate(String date) {
    return 'Intake date: $date';
  }

  @override
  String minutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String snoozed(int minutes) {
    return 'Reminder snoozed for $minutes minutes.';
  }

  @override
  String slotIdentity(int id) {
    return 'Plan $id';
  }

  @override
  String actionFor(String action, String medication, String slot) {
    return '$action for $medication, $slot';
  }

  @override
  String backupSummary(String date, int medications, int events) {
    return 'Backup from $date. $medications medications and $events intake events.';
  }

  @override
  String appVersion(String version) {
    return 'Version $version';
  }
}
