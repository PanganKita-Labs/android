# Contributing to PanganKita

Thank you for helping improve PanganKita. This repository currently contains a
**Flutter Android demonstration**, not a production reservation, authentication,
merchant, payment, or food-safety service. Keep changes and descriptions within
that implemented boundary.

## Before contributing

- Read [the project overview](README.md), [product requirements](PRD.md), and
  [Flutter architecture](docs/ARCHITECTURE.md) when relevant.
- Read [the code of conduct](CODE_OF_CONDUCT.md) before participating.
- For vulnerabilities, follow [the security policy](SECURITY.md) instead of
  publishing exploit details in an issue or pull request.
- Consult [existing issues](https://github.com/PanganKita-Labs/android/issues)
  before proposing overlapping work.
- Read [`rules.md`](rules.md) and the [root agent guidance](AGENTS.md) when
  using an AI coding agent. Follow applicable scoped `AGENTS.md` files; do not
  treat agent instructions as a substitute for human review.

**Licensing:** The repository currently has no repository-wide `LICENSE`.
Public visibility does not grant permission to redistribute its content, and
individual fonts and assets have separate terms. Maintainers should establish
an approved project license before promising general reuse rights. Do not add
assets or code you lack rights to contribute.

## Local setup (Windows / PowerShell)

Use the currently pinned versions: Flutter **3.47.4** with Dart **3.13.3**,
Android SDK, Java 17 for Android builds, and Python 3 for licensed font setup.
These match [the app guide](app/README.md) and GitHub Actions at the time of
this document; check the current workflow if the pins change.

From the repository root:

```powershell
cd app
flutter --version
python ..\.github\scripts\fetch_satoshi.py
flutter pub get --enforce-lockfile
flutter devices
flutter run
```

The font fetcher downloads hash-verified Satoshi weights and license for
**local use**. Do not stage downloaded font binaries, credentials, generated
local graphs, build outputs, or private data. Refer to
[the Flutter app guide](app/README.md) for troubleshooting and device selection.

The `backend/` folder contains future-facing documentation, not a runnable API.
Do not invent backend setup instructions.

## Make a focused change

1. Start from current `main` on a dedicated branch, such as
   `fix/example-issue` or `docs/clarify-setup`.
2. Inspect implementation, callers, and existing tests before editing.
3. Keep runtime changes, documentation cleanup, dependency upgrades, and
   unrelated formatting in separate scopes.
4. Prefer deterministic tests and clearly distinguish **fixture/demo** behavior
   from live integrations.
5. Use [the Dart documentation conventions](docs/architecture/code-documentation.md)
   for meaningful API contracts; avoid redundant comments.
6. Use Conventional Commits, for example `docs(contributing): clarify setup`.
   Never rewrite or force-push someone else's history without authorization.

## Validation matches the change

For Flutter source changes, run from `app/`:

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

When public APIs or documentation contracts change, also run
`dart doc --dry-run .`. Android build or emulator checks are required when
affected by the change; do not equate unit tests with device compatibility.

For *pure Markdown/policy changes*, do not run the entire Flutter suite
without reason. Check whitespace and relevant links (the repository uses
Lychee in CI). From the repository root:

```powershell
git diff --check
```

CI results are evidence only for the exact commit checked. Do not claim a
command passed if it was not executed, and do not weaken quality gates to
make a pull request green.

## Pull requests and review

- Use the [actual PR template](.github/PULL_REQUEST_TEMPLATE.md).
- Describe the problem, exact files and behavior affected, verification
  commands/results, screenshots for visual UI changes, and limitations.
- Mark irrelevant checks **not applicable**; leave unexecuted checks
  unchecked. Do not claim that demonstration flows are production services.
- Identify risks involving privacy, location, authentication, pricing,
  reservations, food-safety representations, and licensing when applicable.
- Keep the PR reviewable and wait for required GitHub Actions and maintainer
  approval before merging.
- The [repository rules](rules.md) and scoped agent instructions may impose
  additional requirements on AI-assisted contributions.

## Feedback and community

Non-sensitive bugs and proposals belong in the
[issue templates](.github/ISSUE_TEMPLATE/).
Respect the [code of conduct](CODE_OF_CONDUCT.md); for suspected
vulnerabilities use [private-reporting guidance](SECURITY.md).
Do not post secrets, exploit details, or personal information publicly.
