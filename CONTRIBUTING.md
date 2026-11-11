# Contributing to PanganKita

Thank you for helping improve PanganKita. This repository currently contains a
**Flutter Android demonstration**, not a production reservation, authentication,
merchant, payment, or food-safety service. Keep changes and descriptions within
that implemented boundary.

## Ways to contribute

Contributions do **not** need to be code. We welcome fixes to the README and
other documentation, clearer setup instructions, reproducible bug reports,
accessibility reviews, UI feedback, translation improvements, meaningful tests,
and evidence-backed research. Small, well-explained improvements are valuable.
Use an issue for discussion or a focused pull request for an actionable change;
do not claim a feature is implemented when you are only proposing it.

## International collaboration and localization

PanganKita starts with Indonesia's surplus-food and pickup context, but the
idea of reducing food waste is not limited to one country. We welcome people
who want to study, fork, translate, or adapt the project for their communities,
subject to [Apache-2.0](LICENSE) and applicable third-party asset rights.
International collaborators do not need to be based in Indonesia.

The Flutter demonstration currently includes Indonesian (default), English,
and Simplified Chinese, using the ARB catalogs in `app/lib/i18n/arb/`. New
languages and corrections to existing translations are especially welcome.
When changing localization, keep placeholders and key meaning consistent,
review accessibility text and food-related terminology with a fluent speaker
where possible, and update generated-localization configuration and the
existing `i18n consistency` checks if supported languages or catalogs change.
Do not hand-edit generated Dart files. Validate source coverage using
`python3 app/tool/check_i18n.py` and follow the relevant
[app instructions](app/AGENTS.md).

An additional language does **not** imply that merchant operations, payments,
food eligibility, location data, legal compliance, or country-specific
formatting are ready in that country. Present any regional behavior as a
proposal until it is implemented and tested; do not invent regulatory claims.

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

**Licensing:** Contributors may license only work they own or are authorized
to contribute. The repository uses [Apache License 2.0](LICENSE) for such
licensed source code, with project and maintainer attribution in [NOTICE](NOTICE).
Preserve applicable notices when redistributing that code. The project's
non-commercial educational purpose does not restrict commercial reuse under
Apache-2.0 and does not grant permission for third-party menu photos, branding,
fonts, or other assets. Confirm their individual permissions first.

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

## Code and documentation standards

- Write clean, readable, maintainable code with clear names and small,
  cohesive responsibilities. Avoid unnecessary duplication, dead code,
  god widgets, speculative layers, and abstractions without real reuse.
  Apply KISS, YAGNI, and DRY with judgment, following the
  [architecture guide](docs/ARCHITECTURE.md) and existing quality gates.
- Preserve feature boundaries, state ownership, localization, accessibility,
  and deterministic testability. Add or update meaningful tests for behavior
  changes; never weaken analyzer, linter, or complexity checks to hide defects.
- Write concise, task-oriented documentation, using the
  [Google developer documentation style guide](https://developers.google.com/style)
  as an editorial reference. Prefer active voice, descriptive headings and
  links, accessible image descriptions, and accurate, runnable examples.
  Update relevant docs with the code and remove outdated or repeated claims.
- Keep the root README an overview and this file the canonical contribution
  workflow. For source API comments, follow the
  [Dart and Python documentation conventions](docs/architecture/code-documentation.md)
  rather than adding comments that merely restate obvious code.
- Before adding or reusing images, menu photographs, icons, fonts, logos, or
  screenshots, record the creator, source, license or explicit permission,
  required credit, and rights to distribute them in Git and compiled APKs.
  Unknown provenance is not permission: replace or omit unverified material.
  Consult the [release asset checklist](docs/RELEASING.md#asset-provenance-and-redistribution).

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

## AI-assisted contributions and human accountability

We welcome responsible use of AI tools, including coding assistants and
autonomous agents. Using AI does not disqualify a contribution, but the
submitter remains accountable for its content, correctness, security,
licensing, and maintainability.

Every PR must disclose its AI involvement in the
[PR template](.github/PULL_REQUEST_TEMPLATE.md): **none**, **AI-assisted**,
or **mostly/fully agent-generated**. When AI was used, briefly identify the
tool(s), affected areas, what the human reviewed, and verification actually
performed. Do not paste private prompts, credentials, or chat transcripts.

A responsible human must understand the change, provide a meaningful rationale,
review the complete diff, report real validation results and limitations, and
participate in maintainer discussion. A generated PR description, automated
comments, passing CI, or an unattended agent is not a substitute for human
communication or review. Reviewers may ask for clarification or changes.

Maintainers **may close without substantive code review** a PR submitted by
an unattended agent or otherwise showing **no meaningful human participation**.
This is a case-by-case engagement standard, not an automatic ban on AI-written
code or a claim that maintainers can reliably detect AI use. Contributors can
open a new, responsibly reviewed PR with human context and evidence.

## Pull requests and review

- Use the [actual PR template](.github/PULL_REQUEST_TEMPLATE.md).
- Describe the problem, exact files and behavior affected, verification
  commands/results, screenshots for visual UI changes, and limitations.
- Mark irrelevant checks **not applicable**; leave unexecuted checks
  unchecked. Do not claim that demonstration flows are production services.
- Identify risks involving privacy, location, authentication, pricing,
  reservations, food-safety representations, and licensing when applicable.
- For new or changed third-party assets, supply verifiable source and permission
  evidence in the PR; don't rely on a prototype or non-commercial disclaimer.
- When a change is user-visible or release-relevant, describe it in the PR;
  maintainers record noteworthy changes in [CHANGELOG.md](CHANGELOG.md) when
  preparing a version, without marking unreleased work as published.
- Keep the PR reviewable and wait for required GitHub Actions and maintainer
  approval before merging.
- Disclose AI involvement and human verification as described above, whether
  the change is code, documentation, translation, or research.
- The [repository rules](rules.md) and scoped agent instructions may impose
  additional requirements on AI-assisted contributions.

## Feedback and community

Non-sensitive bugs and proposals belong in the
[issue templates](.github/ISSUE_TEMPLATE/).
Respect the [code of conduct](CODE_OF_CONDUCT.md); for suspected
vulnerabilities use [private-reporting guidance](SECURITY.md).
Do not post secrets, exploit details, or personal information publicly.
