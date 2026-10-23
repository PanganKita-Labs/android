# PanganKita Flutter From-Scratch Implementation Plan

**Status:** Fresh-start baseline. Previous Flutter prototype was intentionally
removed as obsolete; this is not a continuation of its six development phases.

## Current application baseline

The Flutter app now contains only `main.dart`, `app/pangan_kita_app.dart`,
`app/pangan_kita_theme.dart`, and one minimal bootstrap test. It displays a
placeholder, not a marketplace, auth flow, reservation feature or business UI.
All previous application implementations, mock repositories, domain models,
fixture images and UI-specific tests have been removed from the active tree.
Old commits remain reachable through Git history and safety backups.

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
