# PanganKita App Agent Instructions

Applies to every file under `app/`. Read the repository-root `AGENTS.md`
and `rules.md` first. For Dart implementation under `app/lib/`, also read
[`lib/AGENTS.md`](lib/AGENTS.md). Do not treat a nested rule as permission
to weaken a repository-wide security, evidence, or authorization safeguard.

This file contains only **app-wide** instructions. Detailed source-design rules
belong in `lib/AGENTS.md`; architectural explanations belong in
[the architecture director](../docs/ARCHITECTURE.md), not duplicated here.

## Current scope and evidence

- This checkout contains a Flutter Android demonstration. Account, merchant,
  inventory, reservation, maps, messaging, order, payment, and notification
  screens use local fixtures or previews, not production integrations.
- Never claim an integration, eligibility or safety certification, authenticated
  identity, payment, merchant verification, live availability, or measured impact
  unless its implementation and evidence establish it.
- `backend/` is not an operational server. Future server-authoritative concerns
  such as authorization, reservation concurrency, expiry, and inventory truth
  must not be implemented as client-only authority.
- Protect credentials, signing keys, private user or merchant data, and precise
  location. Use synthetic fixtures and do not commit private captures or
  generated local Graphify output.

## Architecture and ownership

- Follow [Flutter architecture](../docs/ARCHITECTURE.md) for meaningful
  structural changes and [implementation boundaries](../docs/architecture/decisions-and-boundaries.md)
  before adding new integrations or frameworks.
- Keep a shallow feature-first structure. Add a layer, package, abstraction or
  folder only for a demonstrated responsibility; avoid god files, ceremonial
  directories, uncontrolled global state, and unrelated refactoring.
- `main.dart` should initialize the approved runtime and start the app, not own
  feature behavior. Keep state within its smallest appropriate owner and dispose
  owned resources. Treat controller/lifecycle contracts as real API behavior.
- Prefer well-typed models and explicit state transitions. Client-side checks
  improve UX but cannot replace future backend validation or authorization.

## Dependencies, assets, and toolchain

- Current pinned Flutter baseline: **3.47.4**, with Dart **3.13.3**. Check
  `.github/workflows/quality.yml` before changing pins.
- Prefer Flutter/Dart platform APIs or existing packages before adding one.
  Review maintenance, licenses, overlapping responsibilities, lockfiles,
  affected tests, and CI when dependencies change. Do not upgrade unrelated
  packages as part of a focused task.
- Dependabot already exists at `../.github/dependabot.yml`. Review its actual
  configuration; do not propose installing it as though it were absent.
- Preserve license/attribution restrictions. Satoshi is downloaded and
  SHA-256-verified for local builds; do not commit its fetched font files.
- Preserve ARB catalogs unless the task explicitly changes localization.
  Never hand-edit generated localization Dart; regenerate it from the sources.

## Quality gates

For executable Flutter/Dart changes, run focused affected tests first. Then
from `app/`, unless scope-specific requirements are stricter:

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos --fatal-warnings
dart run dart_code_linter:metrics analyze --fatal-style --fatal-performance --fatal-warnings lib
dart run dart_code_linter:metrics check-unused-code --analyze-private-members lib
dart run dart_code_linter:metrics check-unused-files lib
dart run dart_code_linter:metrics check-unnecessary-nullable lib
dart run dartrics analyze --snapshot none --strict-dismiss --fatal-warnings lib
flutter test --coverage
```

- Use the canonical Dart formatter. Strict analyzer, DCL and Dartrics rules
  must not be weakened to hide issues. Avoid meaningless helper extraction,
  blanket ignores and metric gaming.
- `public_member_api_docs` is enforced for public non-overriding declarations.
  When documenting API contracts, run `dart doc --dry-run .` and verify
  comments against implementation, not merely the documentation count.
- For source changes, prefer deterministic unit tests for domain/validation
  rules and widget tests for user-observable state, accessibility and routing.
  Use integration tests only when real boundaries exist. Never claim a future
  reservation E2E suite currently exists.
- The existing Android API **24/29/35/36** launch-smoke workflow tests startup
  coverage, **not** complete end-to-end behavior. Run relevant Android build,
  launch-smoke, or manual device validation for platform-impacting changes.
- For documentation-only work, check `git diff --check` and affected Markdown
  links or examples. Run broader tests only when the edit changes executable
  examples or the task requires them. Never mark an unexecuted check as passed.
- CI is authoritative for its exact commit. See
  [testing and quality guidance](../docs/architecture/testing-and-quality.md)
  and the current workflows, especially `quality.yml`, `android-build.yml`,
  `android-smoke.yml`, `i18n.yml`, `check-mojibake.yml`,
  `lychee.yml`, and `workflow-lint.yml`.

## Testing and platform safety

- Do not optimize for meaningless 100% coverage. Prioritize correctness of
  quantity, pricing, permissions, state transitions, form validation, and
  negative cases. Use isolated data, no production accounts or private assets.
- Handle accessibility, larger text, focus, empty/error states and reduced
  motion where changes affect the user interface; detailed implementation
  guidance lives in [`lib/AGENTS.md`](lib/AGENTS.md).
- Do not modify Gradle, signing, Android SDK configuration, platform permissions,
  Kotlin, or native integration without a concrete need. Platform changes need
  Android build validation and appropriate compatibility checks.
- Do not swallow errors, leak sensitive values to logs, or invent success
  feedback for unsupported operations.

## Completion and reporting

Review the entire diff, run the applicable quality checks, refresh Graphify
only when changed source relationships warrant it, and report exactly which
commands passed, failed, or were unavailable. Preserve unrelated work. Do not
merge or push without the user's authorization under the root instructions.
