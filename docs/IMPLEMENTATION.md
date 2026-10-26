# PanganKita Flutter From-Scratch Implementation Plan

**Status:** Local Flutter prototype imported from the user-supplied ZIP.
This is not a continuation of the retired six development phases.

## Current application baseline

The Flutter app includes splash/welcome, local login and registration forms,
demo OTP verification (code `5102`), simulated password recovery, and a static
food feed with local search, category filters, and read-only product pages. Named
routes live in `app/app_routes.dart`; widgets own their local interaction state.
The supplied images and licensed Geist fonts are bundled assets. Satoshi is
downloaded during setup; text roles follow `docs/DESIGN.md`.

Product cards open `/products/<id>` using the selected local fixture. The detail
page owns temporary favorites, selected reference add-ons, and a bounded 1-10
quantity preview. Adding an item opens `/cart` with that selection. Home also
opens the cart. The app owns one in-memory `DemoCart` for the session; it is
neither persisted nor connected to inventory. Different add-on configurations
remain separate lines. All price arithmetic uses integer rupiah.

The cart supports quantity changes, individual removal, clearing, merchant
groups, illustrative pickup labels, and a zero demo service fee. Notes are a
local input exercise and are not sent or retained after leaving the page.
The `/checkout` page reads the same session cart and shows merchant pickup
labels, a sample pickup person, item details, a QRIS display example, and the
integer-rupiah payment summary. Its acknowledgement checkbox only enables
navigation to a payment preview; it never submits, reserves, charges, or clears items.
The pickup agreement links to an explanatory demo dialog, not a real service
policy. Checkout displays the user-supplied QRIS logo, not a scannable payment
code. The artwork came from Zonalogo; the contributor confirmed permission to
include it in the public repository. Independent rights verification was not
performed.
Empty carts cannot continue. Payment/profile/location actions remain demo
feedback rather than integrations. The review card, add-ons,
location, prices, and pickup clocks remain explicitly illustrative. There is
no actual ordering, reservation, payment, or merchant verification.

After the checkout acknowledgement, the demo button opens `/checkout/status`.
This page follows the middle panel of the payment design while explicitly
showing that no payment or order exists. The QR, countdown, and order ID areas
display "belum tersedia" placeholders. No scannable code, live countdown,
pickup code, or completed-order claim is presented. Back navigation leaves
the cart intact; the Home action returns to discovery without creating state.

These are demonstration flows: no server accounts, SMS/email, persisted
passwords, live location, orders, reservations, or payments are implemented.
The Home bottom navigation opens `/orders`, a preview of the supplied active
orders screen. Its two sample cards are clearly labeled as examples; pickup
codes remain unavailable. Completed and canceled tabs have empty states.
Search, merchant chat, and order details give unavailable feedback. Checkout
does not add entries to this page because it creates no order.
Unavailable integrations show feedback rather than performing remote actions.
Tests cover the demo flows, responsive layouts, typography, and social artwork.

Retained infrastructure: `app/android/`, Flutter/Dart package manifest and
lockfile, strict analyzer/DCL/Dartrics rules, pinned development tool versions,
CI workflows, root/scoped `AGENTS.md` guidance, brand assets, and theme tokens.
No backend integration has been added. Preserve `PRD.md`, research and unrelated
repository subtrees unchanged.

## Implementation stages

1. Receive user-approved screenshot(s) or HTML with the specific task. References
   are provided in the conversation or privately, not committed to Git.
2. Confirm intended screen flow and compare visual references with brand and PRD.
3. Implement a small, usable screen/flow using focused Flutter widgets and
   native layouts; avoid godfiles and speculative infrastructure.
4. Add the smallest real state/data abstraction required by observed behavior;
   create data/domain layers only where there are real responsibilities.
5. Add or replace relevant widget, state and domain tests for new behavior.
6. Render on a device/emulator, compare side-by-side to the supplied screenshot
   at the reference viewport, then check 320/360/390/412 widths and text scale.
7. Run complete CI quality gate; do not claim visual parity from code review.
8. Report exactly what is working, still demo-only and not yet implemented.

Possible future screen order **only when matching approved references are
provided**: Splash -> Welcome -> Login/Register -> OTP/Reset -> Consumer Home.
Do not assume these interfaces constitute real auth or a backend; do not invent
screens or silently restore the obsolete Flutter implementation.

## Engineering quality gates

From `app/`:

```powershell
flutter pub get --enforce-lockfile
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

From repository root:

```powershell
git diff --check
git status --short
```

Do not change CI/linter rules merely to suppress a failure. The bootstrap smoke
test is not evidence for features that have not yet been implemented.

## Git discipline

Start each new workstream on an appropriate focused branch, following the
Conventional branch prefixes and workflow in `AGENTS.md` and `rules.md`.
Before changing branches, inspect `git status --short` and preserve any
existing uncommitted work. Do not encode a temporary cleanup branch name into
lasting repository instructions.

Review the full diff before staging. Commit or push only with explicit user
authorization and after required validation. Keep external screenshots/HTML
out of Git. Follow `.github/PULL_REQUEST_TEMPLATE.md` for every PR.
