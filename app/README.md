# PanganKita Flutter app

The mobile interface for [PanganKita](../README.md), a pickup-first surplus-food marketplace concept for Indonesia. This package is an **interactive local demonstration** built with Flutter. It does not connect to production authentication, inventory, payments, maps, or messaging services.

For the product story and screenshots, start with the [root README](../README.md). For all 38 organized UI captures, browse the [screenshot catalog](../docs/screenshots/README.md).

## Development environment

| Tool | Reference |
| --- | --- |
| Flutter | 3.47.4 (pinned in GitHub Actions) |
| Dart | 3.13.3 in the pinned Flutter toolchain; `pubspec.yaml` requires `^3.13.3` |
| Android build JDK | Java 17 in CI |
| Python | Python 3, for the Satoshi asset setup script |
| Dependencies | Locked by `pubspec.lock`; use `--enforce-lockfile` |

### First run on Windows

From the **repository root**:

```powershell
cd app
flutter doctor
python ..\.github\scripts\fetch_satoshi.py
flutter pub get --enforce-lockfile
flutter devices
flutter run -d emulator-5554
```

`emulator-5554` is an example device ID; use the exact identifier from `flutter devices`. A bare numeric port such as `5554` is not a Flutter device ID. If only one supported device is connected, `flutter run` is usually sufficient.

**Already-running emulator:** you can reuse it; no cold boot is required. While `flutter run` is active, `r` performs hot reload and `R` hot restart. Quit the Flutter run session with `q` without shutting down the emulator.

**Missing fonts or incorrect typography:** rerun `python ..\.github\scripts\fetch_satoshi.py` from `app/`, then restart the app. The downloader verifies the expected font hashes and retrieves the license. The downloaded Satoshi font files are intentionally Git-ignored and must not be committed.

**Dependency or lockfile failure:** check your Flutter/Dart versions against CI before changing `pubspec.lock`. Do not bypass `--enforce-lockfile` as an undocumented workaround.

## Project structure today

```text
app/
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── app_routes.dart       # Named routes
│   │   ├── pangan_kita_app.dart  # Top-level composition and DemoCart owner
│   │   └── pangan_kita_theme.dart
│   ├── features/
│   │   ├── onboarding/           # Local form and welcome flows
│   │   └── discovery/            # Current screen implementations / demo state
│   └── shared/                   # Shared UI and formatting helpers
├── assets/
│   ├── brand/
│   ├── fonts/
│   └── prototype/
├── test/                         # Widget and local behavior coverage
├── android/
├── pubspec.yaml
└── pubspec.lock
```

This is an **accurate current-state map**, not the eventual target architecture. `features/discovery/` still houses merchant, cart, order, notification, messaging and profile presentation. Those responsibilities will be separated through focused refactors only after import/state dependencies and tests are checked. Do not create placeholder layers or add a state-management package just to make folders symmetrical.

### State and data boundaries

- `PanganKitaApp` owns a session-only `DemoCart` and selected example area; no persistence is implied.
- `DemoFood` and other local examples provide fixed data for the screens.
- Search, order filters, cart quantities, notification read markers and some form inputs are local interactions, not server operations.
- Checkout screens, order previews, illustrative maps/directions, support and messaging are **not** evidence of real reservations, payments, GPS routes or external communications.

Routing is centralized in `lib/app/app_routes.dart` and `lib/app/pangan_kita_app.dart`. Read the [architecture director](../docs/ARCHITECTURE.md) and applicable [architecture guidance](../docs/architecture/) before making cross-feature changes.

## Validation

From `app/` after font setup and `flutter pub get --enforce-lockfile`:

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos --fatal-warnings
dart run dart_code_linter:metrics analyze --fatal-style --fatal-performance --fatal-warnings lib
dart run dart_code_linter:metrics check-unused-code --analyze-private-members lib
dart run dart_code_linter:metrics check-unused-files lib
dart run dart_code_linter:metrics check-unnecessary-nullable lib
dart run dartrics analyze lib
flutter test --coverage
flutter build apk --debug
```

For a quick targeted iteration, `flutter test test/orders_page_test.dart` is an example. Before declaring a code change ready, restore the full checks required by the repository rules and CI.

GitHub Actions uses the same pinned Flutter version, installs Satoshi separately and runs quality and Android debug-build jobs. Screenshot review complements tests: an image proves a particular UI render, **not** a server-side workflow.

## Working on this project

- Check the [product requirements](../PRD.md), [design contract](../docs/DESIGN.md), [implementation notes](../docs/IMPLEMENTATION.md), root [contribution rules](../rules.md), and [app-specific instructions](AGENTS.md) before changing behavior.
- Work on a focused Git branch; do not mix UI behavior changes, folder moves and documentation updates in one large PR.
- Include affected widget tests and before/after screenshots for visual changes. The [screenshot library](../docs/screenshots/README.md) is organized by flow and should remain link-consistent.
- Keep external design-reference screenshots private unless their inclusion was explicitly approved. Repository captures must not expose personal information.
- Distinguish implemented UI, local simulation and unimplemented backend capabilities in commits and PR descriptions.

**Backend status:** The repository's `backend/` directory currently contains future-facing documentation, not a running service. Please don't add endpoint assumptions or present demo orders as live transactions.
