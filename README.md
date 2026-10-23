# PanganKita Flutter app

PanganKita is a pickup-first surplus-food project for Indonesia. The current
Flutter application is intentionally reset to a **minimal branded bootstrap**
for a new screenshot-driven implementation. The previous prototype screens,
mock repositories and flows have been removed from the active source tree.

## Run

Using the pinned Flutter version from `app/AGENTS.md`:

```powershell
cd app
flutter pub get --enforce-lockfile
flutter run
```

The current app displays only a placeholder. No authentication, discovery,
reservation, merchant dashboard, payment or backend integration exists in the
new active implementation yet. Brand theme/assets, CI, lint and tooling remain.

Read [`PRD.md`](PRD.md), [`docs/DESIGN.md`](docs/DESIGN.md),
[`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) and
[`docs/IMPLEMENTATION.md`](docs/IMPLEMENTATION.md) before adding screens.
Provide approved reference screenshots in a development task; they are not
committed to this repository. Follow screenshot fidelity, accessibility and
no-godfile requirements in `docs/DESIGN.md` and `app/AGENTS.md`.

## Quality

From `app/`:

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos --fatal-warnings
dart run dart_code_linter:metrics analyze --fatal-style --fatal-performance --fatal-warnings lib
dart run dart_code_linter:metrics check-unused-code --analyze-private-members lib
dart run dart_code_linter:metrics check-unused-files lib
dart run dart_code_linter:metrics check-unnecessary-nullable lib
dart run dartrics analyze lib
flutter test --coverage
```

For an Android smoke build, run `flutter build apk --debug`. The GitHub Actions
workflow remains unchanged.
