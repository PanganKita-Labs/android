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
can be placed. Social login, cart, chat, notifications, promotions, and merchant
browsing show unavailable feedback. Passwords are neither transmitted nor persisted.
Prices, ratings, quantities, and locations are static reference examples.
Homepage pickup-clock labels and merchant badges are illustrative too; they
do not establish pickup availability or merchant verification.

The supplied artwork is bundled under `app/assets/prototype/`. Typography uses
**Geist Semibold/Bold** for headings, product names, current prices, emphasized
numbers, CTA, action links, and navigation. **Satoshi Regular/Medium** is used
for body copy, metadata, inputs, captions, categories, and badge labels.
Savings badges keep "Hemat" in Satoshi and emphasize the percentage with Geist.

Geist is bundled from the [official project](https://github.com/vercel/geist-font)
with its SIL Open Font License in `app/assets/fonts/Geist-OFL.txt`.
Satoshi comes directly from [Fontshare](https://www.fontshare.com/fonts/satoshi).
Run the setup command above before building or testing. Satoshi's font and
license files are downloaded locally and ignored by Git because its ITF Free
Font License permits app embedding but restricts public font-file redistribution.
CI runs the same setup script. Both families appear in Flutter's license registry.
The full role mapping is in [`docs/DESIGN.md`](docs/DESIGN.md).
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
