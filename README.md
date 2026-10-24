# PanganKita Flutter app

PanganKita is a pickup-first surplus-food project for Indonesia. The current
Flutter application now includes the user-supplied Flutter prototype.
It includes splash/welcome, login, registration,
local OTP verification (demo code **5102**), password recovery, and a searchable
home feed with category filters and food detail sheets.

## Run

Using the pinned Flutter version from `app/AGENTS.md`:

```powershell
cd app
python ../.github/scripts/fetch_satoshi.py
flutter pub get --enforce-lockfile
flutter run
```

All authentication and listing content is **local demonstration only**.
No server accounts are created, no SMS/email is sent, and no orders or payments
can be placed. Social login, cart, chat, notifications, and merchant browsing
show unavailable feedback. Passwords are neither transmitted nor persisted.
Prices, ratings, quantities, and locations are static reference examples.

The supplied artwork is bundled under `app/assets/prototype/`. Social logos
and interface symbols use the artwork included in the ZIP. Brand colors
use the existing project theme. Typography uses bundled **Liberation Sans**
(regular and bold), an Arial-compatible font. It is not the proprietary Arial
font. Its SIL Open Font License and
copyright notices are included in `app/assets/fonts/OFL.txt` and registered
with Flutter's license registry. The welcome screen's Daftar label uses
**Satoshi Bold (700)** from [Fontshare](https://www.fontshare.com/fonts/satoshi).
Run the setup command above before building or testing. Satoshi's font and
license are downloaded locally and ignored by Git because the ITF Free Font
License permits app embedding but restricts font-file redistribution through
public repositories. Both CI workflows run the same setup script. Geist Sans
remains unbundled.
No new package dependencies were added.

Read [`PRD.md`](PRD.md), [`docs/DESIGN.md`](docs/DESIGN.md),
[`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) and
[`docs/IMPLEMENTATION.md`](docs/IMPLEMENTATION.md) before extending the app.

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
workflows fetch Satoshi directly from its official source before validation.
