# MediManager

MediManager is a local medication intake log for Android and the web. It helps
you answer “Did I confirm taking this medication on that date?” You can use
it offline and without an account.

## Track an intake

1. Open **Medications** and add a medication with a name and optional dose
   description. Add a daily or weekday plan for each intake slot. Name slots
   such as Morning and Evening to tell them apart.
2. In **Today**, choose **Taken** after an intake you want to confirm. Each
   slot is independent. Choose **Undo** to reverse a confirmation and keep
   both actions in the log.
3. Open **Archive** and pick a date to see the plans, historical dose labels,
   and confirmation times for that day. Choose **Record intake** to add a
   past confirmation. The archive shows when you recorded it and, if you
   supply one, the reported intake time.

**Unconfirmed** means a slot has no current confirmation. MediManager cannot
verify physical ingestion and provides no medical advice, including guidance
on missed or repeated doses. Consult a qualified healthcare professional about
medication decisions.

## Android reminders

Open a medication's details and choose **Reminders** under a slot. Reminders
follow that slot's weekdays and use its scheduled time or a custom reminder
time. **Taken** records a confirmation. Opening, swiping away, or snoozing a
reminder leaves the intake log unchanged. Tracking remains available when
Android notification permission is denied and in the web app.

Android may delay reminders during battery saving or Doze. Reminders are
rebuilt after reboot, schedule changes, and local clock or time zone changes.
Open the app after an update to migrate any older database. Open it again
after an Android force-stop to let Android resume scheduling.

## Back up, restore, or delete data

Open **Settings** → **Data and privacy**.

- **Export backup** saves a readable JSON file with your medication history,
  plans, reminders, and preferences. Android opens a system file picker. Web
  exports appear in your browser downloads. Files are unencrypted and can
  contain sensitive health information.
- **Restore backup** checks the version, integrity, and contents of a selected
  JSON file up to 32 MiB. Review the preview before confirming replacement of
  your current data. Export your current data first if you want to retain it.
  Android rebuilds eligible reminders after restore.
- **Delete all local data** clears the app's records and preferences after
  confirmation. Remove exported files separately from their saved locations.

Android stores records in the app sandbox and disables Android system
backup. The web app stores records in the current browser profile and site
origin. Clearing that site's data or using another origin affects access to
that copy. A device lock or separate user profile can protect records on
shared devices. See the [privacy policy](web/privacy.html) for data and
permission details.

## Build and release

This repository uses Flutter and Dart with local SQLite through Drift. The
Android app supports API 24 and later. Serve a web release from HTTPS or
localhost, including `sqlite3.wasm` and `drift_worker.js`. The app caches
its files on first use so later visits can work offline. Use a browser profile
that permits persistent site storage. Browser privacy modes and site policies
can prevent that storage from being available.

```sh
flutter pub get
flutter gen-l10n
dart run build_runner build
flutter analyze
flutter test
flutter build web --no-web-resources-cdn
```

See [release preparation and validation](docs/release.md), [release notes](CHANGELOG.md),
and the [MIT licence](LICENSE).
