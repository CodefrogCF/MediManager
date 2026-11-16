# MediManager

## Core Design Principle

MediManager is not primarily a medication reminder app.

Its primary purpose is to provide a reliable record of
whether a user explicitly confirmed taking a medication.

A dismissed notification is not an intake confirmation.

An unconfirmed intake does not necessarily mean that
the medication was not taken.

Intake history must remain accessible, accurate, and
understandable across days, application restarts, and
medication schedule changes.

Reminders are optional. Reliable intake tracking is not.

## Android reminders

Add separate intake plans for the same medication, for example morning
and evening, with optional labels. Each plan has its own confirmations,
history, and **Erinnerungen** settings in the medication details. Reminders
follow the plan's days and use its time or a custom reminder time. Each
slot has its own snooze interval.

**Genommen** records a confirmation. Opening, dismissing, or postponing
a notification leaves the intake log unchanged. Android may delay
alarms during battery saving or Doze. Reminders are rebuilt after
reboot, schedule changes, or a change to the local clock or time zone.
A snooze can carry across midnight and expires if it is over 24 hours overdue.
Tracking is available with notifications disabled and in the web app.

## Settings and local data

Open **Einstellungen** / **Settings** from the toolbar to choose German
or English, follow the system appearance or use a light or dark theme,
and select an accent colour.

**Daten und Datenschutz** / **Data and privacy** lets you export, restore,
and delete local data. Backups are readable UTF-8 JSON containing medication
details, schedule versions, reminder preferences, intake events, and
appearance and language settings. The versioned format includes a SHA-256
checksum of the JSON payload. The 32 MiB limit applies to export and import.
Backups are unencrypted and contain health information. Android uses the
system file picker. On the web, exports go to the browser's downloads.

Restore shows a preview and requires confirmation before replacing the local
database. A failed restore leaves the previous data available. Device-specific
notification tokens and snoozes are cleared, and Android rebuilds eligible
reminders from the restored settings. Deletion requires confirmation and
clears the app's records and preferences. Exported files stay at their chosen
locations.

MediManager stores medication records in the Android app sandbox or under the
web app's origin in the current browser profile. The app uses no accounts,
analytics, or automatic uploads. Clearing browser site data removes that
copy. For a shared device, use the device screen lock or a separate OS or
browser profile. An app-level PIN would add a second lock and would leave
exported files outside its protection. MediManager uses the existing device
or profile controls.

## Web build

Run `flutter run -d chrome` for development. The app bundles Roboto
for both development and release.

Run `flutter build web --no-web-resources-cdn` to bundle the renderer
with the release. Serve `build/web` from HTTPS or
localhost, including `sqlite3.wasm` and `drift_worker.js`. The browser
caches the app after the initial visit and keeps intake data in SQLite
storage scoped to that browser profile and origin.
