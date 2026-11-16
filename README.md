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

Configure **Erinnerungen** in a medication's details. Reminders follow
the days in its intake plans and use each plan's time or a custom
reminder time. The snooze interval is configurable per medication.

**Genommen** records a confirmation. Opening, dismissing, or postponing
a notification leaves the intake log unchanged. Android may delay
alarms during battery saving or Doze. Reminders are rebuilt after
reboot, schedule changes, or a change to the local clock or time zone.
A snooze can carry across midnight and expires if it is over 24 hours overdue.
Tracking is available with notifications disabled and in the web app.

## Web build

Run `flutter run -d chrome` for development. The app bundles Roboto
for both development and release.

Run `flutter build web --no-web-resources-cdn` to bundle the renderer
with the release. Serve `build/web` from HTTPS or
localhost, including `sqlite3.wasm` and `drift_worker.js`. The browser
caches the app after the initial visit and keeps intake data in SQLite
storage scoped to that browser profile and origin.
