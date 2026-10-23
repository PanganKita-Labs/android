# PanganKita AI Agent Contribution Guardrails

**Status:** Active contribution workflow. **Applies to:** Codex, ChatGPT, and any other AI coding agent working in this repository.

This document supplements, but does not replace, the existing `AGENTS.md` hierarchy. It does not authorize a change, a commit, a push, or a pull request. More specific task instructions apply only when they do not weaken product, security, evidence, or engineering safeguards.

## 1. Mandatory pre-contribution reading

**Do not edit code, propose a commit, or start a PR before completing the applicable review.**

1. Read the repository-root `AGENTS.md` **in full**, followed by this `rules.md` **in full**.
2. Find all applicable scoped `AGENTS.md` files along the paths you will edit (`app/AGENTS.md`, `docs/AGENTS.md`, `backend/AGENTS.md`, `research/AGENTS.md`, or deeper instructions if present). Read **each applicable file in full**, not just excerpts. Do not indiscriminately load unrelated folders.
3. Read the relevant requirements and technical documents: `PRD.md`; `docs/ARCHITECTURE.md` and only the applicable `docs/architecture/*.md` guidance; `docs/DESIGN.md` for UI; and `docs/IMPLEMENTATION.md` for the current implementation plan. Where a file is absent, report it—do not reconstruct obsolete instructions from Git history without permission.
4. Inspect current Git state: `git status --short`, `git branch --show-current`, `git log -1 --oneline`, and the diff for any existing changes. **Never discard pre-existing local modifications.**
5. Before contributing to a feature, inspect the actual implementation, imports/callers, state ownership, affected tests, asset declarations, lint configuration, and CI workflows. Read enough of the source to understand existing behavior before proposing changes. For non-trivial cross-file or architectural work, use Graphify first **as directed by root `AGENTS.md`**, then verify conclusions in source.
6. Read `.github/PULL_REQUEST_TEMPLATE.md` **before** preparing a PR description; populate that template faithfully, rather than inventing a generic one.
7. Summarize the observed baseline, task scope, dependencies, risks, and validation plan. If an essential assumption remains unverified, state it rather than guessing.

Do not claim to have read, inspected, executed, visually compared, or verified material that you have not actually accessed.

## 2. Hierarchy and product integrity

Follow the repository instruction hierarchy and source-of-truth order defined in `AGENTS.md` and `PRD.md`. Source code and tests describe **current behavior**; approved requirements describe **desired behavior**. Report contradictions instead of silently rewriting one to match the other.

PanganKita is a hyperlocal, pickup-oriented surplus-food product. Never invent real authentication, merchant verification, payments, inventories, pickup confirmations, maps, safety certifications, environmental impact, or regulatory compliance. Distinguish functioning integrations from placeholders, mocks, and proposals.

## 3. Branch naming — required convention

For a new workstream, use **one focused branch** with a lowercase slash-prefixed type and a short hyphenated description:

```text
<type>/<short-kebab-case-description>
```

Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`, `research`.

Examples:

```text
feat/consumer-login-flow
fix/auth-keyboard-overflow
refactor/ui-widget-boundaries
docs/update-visual-contract
chore/flutter-fresh-start
ci/validate-dart-lints
```

Branch names are a **repository convention inspired by Conventional Commits**, not an official part of the Conventional Commits specification. Prefer descriptive, lowercase names; avoid ambiguous names such as `update`, `final`, `test123`, or `new-branch`. Before creating a branch, verify the active branch, local changes, target base, and whether an appropriate branch already exists. **Never switch branches, reset, rebase, delete branches, or rewrite history without considering the current working tree and obtaining authorization when appropriate.**

## 4. Commit messages — Conventional Commits

Use the canonical format:

```text
<type>(<optional-scope>): <imperative description>
```

Examples:

```text
feat(auth): implement responsive login screen
fix(ui): prevent registration form overflow
refactor(discovery): split listing layout from query state
test(app): cover initial branded bootstrap
docs(design): define screenshot parity checks
chore(flutter): remove obsolete prototype screens
```

Use a specific scope only when useful. Keep the subject truthful, concise, and imperative. Use `!` plus a `BREAKING CHANGE:` footer when a truly incompatible interface or behavior is introduced. Do not use `feat` for documentation-only changes. Do not mix unrelated changes in one commit. Review staged content with `git diff --cached --check` and `git diff --cached` before committing. **Do not stage, commit, amend, push, or force-push unless the user explicitly authorizes it.**

## 5. Pull requests — use the actual repository template

Before creating or drafting a PR, open `.github/PULL_REQUEST_TEMPLATE.md` and retain its actual sections, including:

- Description; Changes; Type of change; Areas affected.
- Verification with **commands actually run and truthful results**.
- Screenshots or evidence for visible UI changes (attach to PR when appropriate; do not place reference assets in the source repository unless explicitly approved).
- Product and domain integrity; Mobile quality; Security and privacy.
- Checklist and Related issue.

Use a focused **Conventional Commit-compatible PR title**, especially when squash merges are used. Mark irrelevant checklist items as not applicable or explain them; never tick checks that did not pass. Clearly disclose limitations, testing gaps, mock-only behavior, compatibility concerns, and any outstanding failures. Do not create, request reviews on, or merge a PR without user approval. Never merge with failed required CI.

## 6. Flutter implementation and screenshot fidelity

The existing Flutter implementation is a **fresh-start baseline**. Do not resurrect old prototype features or navigation solely because they exist in Git history. Implement only current, approved requirements.

When the user supplies a screenshot or HTML reference **with the task**, use `docs/DESIGN.md` as the conversion contract. Recreate the **application UI** as close to 1:1 as practical at the reference viewport: geometry, hierarchy, colors, text treatment, icons, spacing, sizing, and content order. Do not redraw operating-system status bars, battery/Wi-Fi icons, or gesture navigation bars as Flutter widgets. Build responsively using idiomatic Flutter, `Scaffold`/`SafeArea`, relevant constraints, sensible scrolling, accessible semantics, keyboard insets, and supported text scaling. Visually compare actual Flutter output with the provided reference before claiming parity. Do not assume a screenshot alone proves runtime behavior.

**References stay outside the repository unless the user explicitly approves committing them.** Do not create `docs/design/reference/` or reintroduce stale Stitch phase plans merely because previous history used those paths.

Preserve the approved PanganKita brand identity and brand guidelines—logos, palette, typography decisions, and asset integrity. Do not treat an unapproved screenshot's incidental color or font difference as an automatic brand change. Never claim a font is installed unless its licensed font asset and Flutter configuration exist.

## 7. Architecture, readability, and maintainability

- No godfiles or god widgets. Separate screens, state, business logic, and data access by responsibility; keep components cohesive and named clearly.
- No arbitrary file-count goals and no premature extraction. Shared abstractions need evidence of stable common behavior and ownership, not merely similar-looking code.
- Evaluate changes before implementing: **KEEP / DEFER / REJECT** are acceptable conclusions for refactors, dependencies, or feature additions.
- Prefer KISS, YAGNI, narrowly applied DRY, composition, type safety, and explicit lifecycle/state ownership. Preserve validated boundaries and avoid cross-feature cycles.
- Use Google-style Dart documentation comments for public APIs and non-obvious contracts where appropriate; do not add ceremonial comments to obvious code.
- Do not introduce packages, rewrite configurations, upgrade toolchains, bypass lints, or weaken CI merely to make a change easier. Keep changes proportional to the requested scope.
- Review concurrency, cancellation, failure paths, accessibility, compatibility, security, privacy, and data integrity when relevant.

## 8. Required validation and evidence

For Flutter changes, run the current quality gate defined by `AGENTS.md`, `app/AGENTS.md`, and `.github/workflows/quality.yml`. As currently configured, from `app/`:

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

Then from repository root run `git diff --check`. For UI changes, verify representative widths (320/360/390/412 logical pixels), keyboard insets, text scaling, overflow, tap targets, and screenshot parity. For changes that affect Android packaging, run the relevant Flutter build checks. For documentation-only changes, follow the narrower validation guidance in `docs/AGENTS.md`.

Never claim success if a check has not actually passed. Fix code-level problems at the code level, **not** by suppressing warnings or weakening the quality gate. Refresh Graphify only when required by root `AGENTS.md`, after validation.

## 9. Safe work, review, and reporting

- Start with a read-only audit when change scope or dependencies are unclear.
- Do not overwrite unrelated edits, delete unknown untracked files, commit local caches, or expose credentials, tokens, participant data, backups, or private research.
- Prefer reversible, narrow edits. Before scripted deletion, back up affected files, inspect what exists, reject unexpected states, and provide a recovery path. Avoid `git reset --hard`, `git clean -fd`, or forced branch operations without explicit approval.
- Keep documentation synchronized with actual implementation, not historical aspirations.
- Before finalizing: inspect the entire diff; check tests and formatting; identify what was and was not validated; note uncertainty; and report files changed, important design decisions, residual risks, and the current Git branch.
- Do not automatically commit, push, open a PR, request reviewers, or merge; obtain explicit authorization for each action where required by the user and repository rules.

**Contribution entry criterion:** Read the instructions, inspect the relevant code and tests, understand the request, and validate the proposed change **before** calling it ready.
