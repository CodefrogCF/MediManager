import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @app.
  ///
  /// In en, this message translates to:
  /// **'MediManager'**
  String get app;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @enableReminders.
  ///
  /// In en, this message translates to:
  /// **'Enable reminders'**
  String get enableReminders;

  /// No description provided for @remindersPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused while this medication is inactive'**
  String get remindersPaused;

  /// No description provided for @notificationPermission.
  ///
  /// In en, this message translates to:
  /// **'Android notifications are disabled.'**
  String get notificationPermission;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Android notification settings'**
  String get notificationSettings;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderTime;

  /// No description provided for @useScheduledTime.
  ///
  /// In en, this message translates to:
  /// **'Use the planned time'**
  String get useScheduledTime;

  /// No description provided for @reminderDetails.
  ///
  /// In en, this message translates to:
  /// **'Reminders follow the days in the intake plan. Set a reminder time for slots without a planned time.'**
  String get reminderDetails;

  /// No description provided for @reminderTiming.
  ///
  /// In en, this message translates to:
  /// **'Android may delay reminders.'**
  String get reminderTiming;

  /// No description provided for @snoozeInterval.
  ///
  /// In en, this message translates to:
  /// **'Snooze interval'**
  String get snoozeInterval;

  /// No description provided for @remindLater.
  ///
  /// In en, this message translates to:
  /// **'Remind me later'**
  String get remindLater;

  /// No description provided for @snoozeError.
  ///
  /// In en, this message translates to:
  /// **'Could not snooze the reminder.'**
  String get snoozeError;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @medications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medications;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @noActiveMedications.
  ///
  /// In en, this message translates to:
  /// **'No active medications'**
  String get noActiveMedications;

  /// No description provided for @noInactiveMedications.
  ///
  /// In en, this message translates to:
  /// **'No inactive medications'**
  String get noInactiveMedications;

  /// No description provided for @addMedication.
  ///
  /// In en, this message translates to:
  /// **'Add medication'**
  String get addMedication;

  /// No description provided for @editMedication.
  ///
  /// In en, this message translates to:
  /// **'Edit medication'**
  String get editMedication;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name.'**
  String get nameRequired;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage (optional)'**
  String get dosage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the data.'**
  String get loadError;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the change.'**
  String get saveError;

  /// No description provided for @medicationMissing.
  ///
  /// In en, this message translates to:
  /// **'This medication is no longer available.'**
  String get medicationMissing;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @deactivateTitle.
  ///
  /// In en, this message translates to:
  /// **'Deactivate medication?'**
  String get deactivateTitle;

  /// No description provided for @deactivateDetails.
  ///
  /// In en, this message translates to:
  /// **'Current plans end today. Upcoming starts are cancelled. The intake history stays available.'**
  String get deactivateDetails;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete medication?'**
  String get deleteTitle;

  /// No description provided for @deleteDetails.
  ///
  /// In en, this message translates to:
  /// **'The medication will be permanently removed.'**
  String get deleteDetails;

  /// No description provided for @deleteWithSchedule.
  ///
  /// In en, this message translates to:
  /// **'This medication has saved plans. You can deactivate it.'**
  String get deleteWithSchedule;

  /// No description provided for @schedules.
  ///
  /// In en, this message translates to:
  /// **'Intake plans'**
  String get schedules;

  /// No description provided for @addSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add plan'**
  String get addSchedule;

  /// No description provided for @editSchedule.
  ///
  /// In en, this message translates to:
  /// **'Edit plan'**
  String get editSchedule;

  /// No description provided for @noSchedules.
  ///
  /// In en, this message translates to:
  /// **'No editable intake plans'**
  String get noSchedules;

  /// No description provided for @planChangesFrom.
  ///
  /// In en, this message translates to:
  /// **'Changes apply from'**
  String get planChangesFrom;

  /// No description provided for @stopSchedule.
  ///
  /// In en, this message translates to:
  /// **'End plan'**
  String get stopSchedule;

  /// No description provided for @stopScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'End this intake plan?'**
  String get stopScheduleTitle;

  /// No description provided for @stopCurrentSchedule.
  ///
  /// In en, this message translates to:
  /// **'The plan ends after today.'**
  String get stopCurrentSchedule;

  /// No description provided for @cancelUpcomingSchedule.
  ///
  /// In en, this message translates to:
  /// **'The scheduled start will be cancelled.'**
  String get cancelUpcomingSchedule;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Selected weekdays'**
  String get weekly;

  /// No description provided for @selectWeekday.
  ///
  /// In en, this message translates to:
  /// **'Select at least one weekday.'**
  String get selectWeekday;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'First day'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'Last day (optional)'**
  String get endDate;

  /// No description provided for @invalidEndDate.
  ///
  /// In en, this message translates to:
  /// **'The last day is before the first day.'**
  String get invalidEndDate;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time (optional)'**
  String get time;

  /// No description provided for @noEndDate.
  ///
  /// In en, this message translates to:
  /// **'No end date'**
  String get noEndDate;

  /// No description provided for @noTime.
  ///
  /// In en, this message translates to:
  /// **'No time set'**
  String get noTime;

  /// No description provided for @removeTime.
  ///
  /// In en, this message translates to:
  /// **'Remove time'**
  String get removeTime;

  /// No description provided for @removeEndDate.
  ///
  /// In en, this message translates to:
  /// **'Remove end date'**
  String get removeEndDate;

  /// No description provided for @emptyToday.
  ///
  /// In en, this message translates to:
  /// **'There are no intakes planned for today.'**
  String get emptyToday;

  /// No description provided for @emptyDate.
  ///
  /// In en, this message translates to:
  /// **'There are no intakes planned for this day.'**
  String get emptyDate;

  /// No description provided for @previousDay.
  ///
  /// In en, this message translates to:
  /// **'Previous day'**
  String get previousDay;

  /// No description provided for @nextDay.
  ///
  /// In en, this message translates to:
  /// **'Next day'**
  String get nextDay;

  /// No description provided for @taken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get taken;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @confirmedStatus.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmedStatus;

  /// No description provided for @unconfirmedStatus.
  ///
  /// In en, this message translates to:
  /// **'Unconfirmed'**
  String get unconfirmedStatus;

  /// No description provided for @correctedStatus.
  ///
  /// In en, this message translates to:
  /// **'Corrected'**
  String get correctedStatus;

  /// No description provided for @eventHistory.
  ///
  /// In en, this message translates to:
  /// **'Intake log'**
  String get eventHistory;

  /// No description provided for @backfill.
  ///
  /// In en, this message translates to:
  /// **'Record intake'**
  String get backfill;

  /// No description provided for @backfilled.
  ///
  /// In en, this message translates to:
  /// **'Confirmed retrospectively'**
  String get backfilled;

  /// No description provided for @backfillTitle.
  ///
  /// In en, this message translates to:
  /// **'Record a past intake'**
  String get backfillTitle;

  /// No description provided for @reportedTime.
  ///
  /// In en, this message translates to:
  /// **'Intake time (optional)'**
  String get reportedTime;

  /// No description provided for @invalidReportedTime.
  ///
  /// In en, this message translates to:
  /// **'This time does not exist on that day in the current time zone.'**
  String get invalidReportedTime;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'Intake history'**
  String get history;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No intakes recorded.'**
  String get noHistory;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Intake confirmed'**
  String get confirmed;

  /// No description provided for @corrected.
  ///
  /// In en, this message translates to:
  /// **'Confirmation undone'**
  String get corrected;

  /// No description provided for @mondayShort.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mondayShort;

  /// No description provided for @tuesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesdayShort;

  /// No description provided for @wednesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesdayShort;

  /// No description provided for @thursdayShort.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursdayShort;

  /// No description provided for @fridayShort.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fridayShort;

  /// No description provided for @saturdayShort.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturdayShort;

  /// No description provided for @sundayShort.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sundayShort;

  /// No description provided for @slotLabel.
  ///
  /// In en, this message translates to:
  /// **'Slot name (optional)'**
  String get slotLabel;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get themeMode;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent colour'**
  String get accentColor;

  /// No description provided for @greenAccent.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get greenAccent;

  /// No description provided for @blueAccent.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blueAccent;

  /// No description provided for @tealAccent.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get tealAccent;

  /// No description provided for @orangeAccent.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orangeAccent;

  /// No description provided for @purpleAccent.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get purpleAccent;

  /// No description provided for @redAccent.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get redAccent;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @dataAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data and privacy'**
  String get dataAndPrivacy;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About MediManager'**
  String get about;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy and limitations'**
  String get privacyPolicy;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licences'**
  String get licenses;

  /// No description provided for @policyData.
  ///
  /// In en, this message translates to:
  /// **'MediManager stores the medications, doses, schedules, confirmations, corrections, and preferences you enter. Its operator is CodefrogCF.'**
  String get policyData;

  /// No description provided for @policyNotifications.
  ///
  /// In en, this message translates to:
  /// **'Optional Android reminders use notification permission and can include medication names. The Android notification settings control what is visible on the lock screen. Reboot access lets Android re-arm reminders.'**
  String get policyNotifications;

  /// No description provided for @policyWeb.
  ///
  /// In en, this message translates to:
  /// **'The web host receives normal page requests, which can include your IP address. Your medication records stay in the site\'s browser storage. After the web app has loaded and cached its files, tracking works offline.'**
  String get policyWeb;

  /// No description provided for @policyDeletion.
  ///
  /// In en, this message translates to:
  /// **'Use Settings → Data and privacy to delete local records or export and restore them. Android system backup is disabled. Downloads and files you save or share remain in their chosen locations.'**
  String get policyDeletion;

  /// No description provided for @policyMedicalLimitations.
  ///
  /// In en, this message translates to:
  /// **'MediManager records your confirmations. An unconfirmed slot has no current confirmation. MediManager cannot verify physical ingestion or provide medical advice, including advice about missed or repeated doses.'**
  String get policyMedicalLimitations;

  /// No description provided for @policyContact.
  ///
  /// In en, this message translates to:
  /// **'For privacy questions, contact CodefrogCF through the MediManager repository on GitHub. Keep personal medication information out of public issues.'**
  String get policyContact;

  /// No description provided for @localPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Medication data stays on this device or in the browser profile. MediManager uses local storage and does not require an account or automatically upload medication data.'**
  String get localPrivacy;

  /// No description provided for @appProtection.
  ///
  /// In en, this message translates to:
  /// **'Use a device lock or a separate user profile to protect your records on a shared device.'**
  String get appProtection;

  /// No description provided for @backupPlaintext.
  ///
  /// In en, this message translates to:
  /// **'Backups contain readable, unencrypted health information. Choose a storage location you trust.'**
  String get backupPlaintext;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackup;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get importBackup;

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'The backup was exported.'**
  String get backupSaved;

  /// No description provided for @backupDownloadStarted.
  ///
  /// In en, this message translates to:
  /// **'The backup download started.'**
  String get backupDownloadStarted;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'The backup was restored.'**
  String get backupRestored;

  /// No description provided for @restoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace local data?'**
  String get restoreTitle;

  /// No description provided for @restoreWarning.
  ///
  /// In en, this message translates to:
  /// **'The backup replaces your local data and settings. Export a backup of your current data first if you want to keep it.'**
  String get restoreWarning;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @deleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete all local data'**
  String get deleteAllData;

  /// No description provided for @deleteAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all local data?'**
  String get deleteAllTitle;

  /// No description provided for @deleteAllWarning.
  ///
  /// In en, this message translates to:
  /// **'Medications, plans, intakes, reminders, and settings will be permanently removed from MediManager. Exported files stay where you saved them.'**
  String get deleteAllWarning;

  /// No description provided for @dataDeleted.
  ///
  /// In en, this message translates to:
  /// **'Local data was deleted.'**
  String get dataDeleted;

  /// No description provided for @backupInvalid.
  ///
  /// In en, this message translates to:
  /// **'This backup is invalid or damaged.'**
  String get backupInvalid;

  /// No description provided for @backupUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This backup format version is unsupported.'**
  String get backupUnsupported;

  /// No description provided for @backupTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The backup exceeds 32 MiB.'**
  String get backupTooLarge;

  /// No description provided for @backupOperationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the data operation.'**
  String get backupOperationFailed;

  /// No description provided for @backupBusy.
  ///
  /// In en, this message translates to:
  /// **'Data operation in progress.'**
  String get backupBusy;

  /// No description provided for @reminderChannelName.
  ///
  /// In en, this message translates to:
  /// **'Intake reminders'**
  String get reminderChannelName;

  /// No description provided for @reminderChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Optional reminders for scheduled intakes'**
  String get reminderChannelDescription;

  /// No description provided for @plannedIntake.
  ///
  /// In en, this message translates to:
  /// **'Scheduled intake'**
  String get plannedIntake;

  /// No description provided for @periodFrom.
  ///
  /// In en, this message translates to:
  /// **'From {start}'**
  String periodFrom(String start);

  /// No description provided for @periodRange.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String periodRange(String start, String end);

  /// No description provided for @scheduledFor.
  ///
  /// In en, this message translates to:
  /// **'Planned: {date}, {time}'**
  String scheduledFor(String date, String time);

  /// No description provided for @recordedAt.
  ///
  /// In en, this message translates to:
  /// **'Recorded: {timestamp}'**
  String recordedAt(String timestamp);

  /// No description provided for @reportedAt.
  ///
  /// In en, this message translates to:
  /// **'Intake time: {timestamp}'**
  String reportedAt(String timestamp);

  /// No description provided for @backfillDate.
  ///
  /// In en, this message translates to:
  /// **'Intake date: {date}'**
  String backfillDate(String date);

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, one{1 minute} other{{minutes} minutes}}'**
  String minutes(int minutes);

  /// No description provided for @snoozed.
  ///
  /// In en, this message translates to:
  /// **'Reminder snoozed for {minutes} minutes.'**
  String snoozed(int minutes);

  /// No description provided for @slotIdentity.
  ///
  /// In en, this message translates to:
  /// **'Plan {id}'**
  String slotIdentity(int id);

  /// No description provided for @actionFor.
  ///
  /// In en, this message translates to:
  /// **'{action} for {medication}, {slot}'**
  String actionFor(String action, String medication, String slot);

  /// No description provided for @backupSummary.
  ///
  /// In en, this message translates to:
  /// **'Backup from {date}. {medications} medications and {events} intake events.'**
  String backupSummary(String date, int medications, int events);

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
