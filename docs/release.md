# MediManager 1.0.0 release guide

## Release builds

Use Flutter 3.47 and Dart 3.13 with the repository's lockfile. The Android
package is `com.codefrog.medimanager`, with minimum API 24, target API 36,
and version code 4. The web release needs HTTPS or localhost and bundles
its own SQLite, worker, renderer, and fonts.

```sh
flutter pub get
flutter gen-l10n
dart run build_runner build
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build appbundle --release
flutter build apk --release --split-per-abi
flutter build web --release --no-web-resources-cdn
```

For a publishable Android build, configure the distribution key through an
ignored `android/key.properties` file or set `MEDIMANAGER_SIGNING_PROPERTIES`
to the location of a private properties file. Supply `storeFile`,
`storePassword`, `keyAlias`, and `keyPassword`. A relative `storeFile` is
resolved beside the properties file. On Windows, use forward slashes or
escape backslashes in the properties file. An unconfigured release build
produces unsigned artifacts. Update an existing install with the signing
identity that install expects. Use the Play upload key for Play App Signing.
For direct downloads from GitHub Releases, attach the APK built with your
distribution signing key. Keep that key for later GitHub Releases so users
can install updates over their existing app.
[Flutter Android release guide](https://docs.flutter.dev/deployment/android)

Deploy all of `build/web` under the chosen HTTPS origin. Preserve the origin
when updating the web release because the browser scopes records to that
origin. Set `--base-href /path/` when deploying under a subdirectory. Use the
deployed `privacy.html` URL for the public policy. Verify that
`sqlite3.wasm` is served as `application/wasm` and that a reload works offline
after the app completes its first online load.

## Assets and listing text

- [Launcher artwork](../assets/images/medimanager.png)
- [512 × 512 listing icon](../web/icons/Icon-512.png)
- [Today screenshot](screenshots/today.png) and [Archive screenshot](screenshots/archive.png)
- [Release notes](../CHANGELOG.md), [privacy policy](../web/privacy.html),
  and [MIT licence](../LICENSE). The bundled Roboto font has its own
  [licence](../assets/fonts/Roboto-LICENSE.txt).

The screenshots contain synthetic data. Short listing description

> Offline medication intake log with an archive of your confirmations.

MediManager lets you create separate intake slots, record and undo confirmations,
view past dates, and export a portable local backup. Android users can opt in to
reminders per slot. MediManager is a personal log and cannot verify physical
ingestion, diagnose or treat a condition, or provide medical advice. Consult a
qualified healthcare professional for medical decisions.

## Platform checks

[GitHub Actions](../.github/workflows/ci.yml) checks generated code, formatting,
analysis, and the Flutter suite for pull requests and pushes to `main`.
Successful builds provide the offline web files, an unsigned Android bundle,
and an installable release-mode QA APK. Each workflow run creates its own
QA signing key. Install that APK on a fresh test emulator. Android emulator
checks run separately from the hosted workflow.

Use a fresh disposable Android emulator with English system UI. The script
uses a synthetic JSON backup and changes only the test emulator's settings.
Add `--previous-apk` to test an upgrade from 0.3.0 signed with the same QA key.
Add `--reboot` to check scheduling during forced Doze and after a device reboot.
Add `--screenshots docs/screenshots` to capture the Today and Archive screens.

```sh
python tool/android_release_check.py --serial emulator-5554 --apk path/to/qa-release.apk
```

Before shipping, use the intended distribution signature, verify the package
and APK alignment, and check a physical Android device with its battery
restrictions. Check browser offline reload, export and restore, and record
which browsers and Android versions were exercised.
[Android 16 KB page-size guide](https://developer.android.com/guide/practices/page-sizes)

For a Google Play rollout, complete the current store listing and disclosure
forms and submit the production-signed bundle through your publishing account.
Review the [target API requirement](https://developer.android.com/google/play/requirements/target-sdk),
[health app declaration](https://support.google.com/googleplay/android-developer/answer/14738291),
and [preview asset requirements](https://support.google.com/googleplay/android-developer/answer/9866151).

## 1.0.0 validation record

| Check | Result |
| --- | --- |
| Flutter 3.47.0 and Dart 3.13.0 on Windows | Formatting, localization and Drift generation, analysis, and all 27 automated tests passed. |
| Responsive layouts | Today and Archive ran at logical sizes 320 × 600 and 640 × 360 with 200% text. |
| SQLite archive | A targeted Windows run read 25 days from a 52,560-event on-disk archive. Median query time was 6.4 ms and the 95th percentile was 10.7 ms. The timings include one first open. |
| Android 12 emulator (API 31, x86-64) | In-place upgrade from v0.3.0 preserved slots, history, and the language preference. Swiping away a real evening notification produced no event. Tracking and backup export worked offline after an app restart. |
| Android 16 emulator (API 36, x86-64) | Tracking and restore worked with notification permission denied. Dismissing the grouped reminders left both intakes pending. The alarm stayed scheduled during forced Doze and re-armed before app launch after reboot. Today, Archive, and offline export preserved the separate slot states. |
| Desktop Chrome | The release served the bilingual policy and completed an offline reload, v0.3-format restore, one-slot confirmation, and backup export. |
| Android package | Release APK and unsigned app bundle built. The QA APK signature and 16 KB ZIP alignment passed verification. The ARM64 and x86-64 loadable ELF segments met 16 KB alignment. |
| GitHub Actions | Workflow YAML, the QA APK step's shell syntax, and the enforced-lockfile command passed local validation. The hosted run is pending. |

Physical devices, the Android API 24 runtime boundary, and 16 KB runtime were
outside this test run. The browser runtime check used Chrome.
