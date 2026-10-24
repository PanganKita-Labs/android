# PanganKita Flutter Architecture

**Document:** `docs/ARCHITECTURE.md`
**Product:** PanganKita
**Status:** Active architecture director / local Flutter prototype
**Scope:** Flutter application architecture

> Build the smallest architecture that keeps PanganKita easy to understand,
> test, and change.

## Purpose

This file is the architecture director.

Detailed execution rules live under `docs/architecture/`.

Do not load every architecture document for every task. Read only the files
relevant to the current structural decision.

## Source-of-truth order

When instructions conflict:

1. `PRD.md`
2. Official PanganKita Brand Guidelines
3. `AGENTS.md`, `rules.md`, and applicable scoped `AGENTS.md`
4. `app/AGENTS.md`
5. `docs/ARCHITECTURE.md`
6. relevant `docs/architecture/*.md`
7. `docs/DESIGN.md` - active screenshot-to-Flutter contract
8. `docs/IMPLEMENTATION.md` - current implementation plan
9. approved screenshots/HTML supplied with the task (not committed to Git)

Architecture supports product behavior. It must not silently redefine the PRD.

## Architectural style

PanganKita uses:

> **Feature-first organization with lightweight internal layering.**

The intended feature shape is:

```text
feature/
├── data/
├── domain/
└── presentation/
```

Create a layer only when it contains real responsibilities.

Do not create empty folders or abstractions merely to make the repository look
symmetrical.

## Core principles

Use these principles pragmatically:

```text
KISS  → choose the smallest correct design
YAGNI → do not build speculative infrastructure
DRY   → remove meaningful duplication, not all duplication
SOLID → use boundaries where they solve real problems
```

Prefer composition over deep application-specific inheritance.

> Duplication is sometimes cheaper than the wrong abstraction.

## Architecture routing

Read the relevant scoped document before structural work:

| Work | Required architecture file |
|---|---|
| KISS, YAGNI, DRY, SOLID, abstraction thresholds, anti-overengineering | `architecture/foundations.md` |
| Folder structure, feature ownership, dependency direction, core/shared, barrels | `architecture/project-structure.md` |
| Repositories, mock data, state ownership, DI, DTOs, persistence, backend seams | `architecture/state-and-data.md` |
| Widget boundaries, presentation responsibilities, navigation, naming, utilities | `architecture/ui-and-widgets.md` |
| Unit/widget/E2E boundaries, test doubles, quality gates, Graphify | `architecture/testing-and-quality.md` |
| Dependencies, codegen, auth/payment/maps/analytics boundaries, architecture changes | `architecture/decisions-and-boundaries.md` |

For cross-cutting work, read each relevant file.

Do not load unrelated architecture files merely for completeness.

## High-level dependency direction

Within a feature, prefer:

```text
presentation
     ↓
   domain
     ↑
    data
```

Conceptually:

```text
UI
↓
feature state owner
↓
repository contract
↑
a data implementation only when justified
a real backend integration only when approved
```

Cross-feature dependencies should remain narrow and acyclic.

Prefer:

```text
feature
  ↓
shared/core
```

Avoid feature dependency cycles.

## Current implementation baseline

The active Flutter source implements a **local demonstration prototype**:

```text
app/lib/main.dart
app/lib/app/app_routes.dart
app/lib/app/pangan_kita_app.dart
app/lib/app/pangan_kita_theme.dart
app/lib/features/onboarding/
app/lib/features/discovery/
app/lib/shared/
app/test/widget_test.dart
app/test/reference_typography_test.dart
app/test/social_sign_in_test.dart
```

App composition owns named routes and the theme. Onboarding owns splash,
welcome, local form validation, demo OTP, and simulated password recovery.
Discovery owns static listing examples, local search/category filtering, and
read-only detail sheets. Shared widgets provide reference icons and feedback
for unavailable integrations. State remains local to the relevant widgets.

There is no server authentication, persistence, live location, ordering,
reservation, payment, or backend integration. Tests exercise demo navigation,
validation, search, responsive layouts, typography, and social artwork; they
do not establish production authentication or transaction correctness.

Brand foundations, Android/Flutter configuration, lint/complexity rules, CI,
and the scoped engineering and architecture contracts remain in force.

## Future implementation boundaries

The feature-first diagrams and repository/state patterns in this document are
**design guidance for future work**, not a claim that every layer or integration
already exists. Add a layer, contract, fake, or feature directory only when it
solves a current requirement. Test it when introduced. Approved reference
screenshots are supplied with the task, not stored in the repository.

Do not invent live backend, auth, payments, geolocation, regulatory compliance,
food-safety guarantees, or impact reporting to make a screenshot interactive.

## Barrel policy summary

Controlled barrel files are allowed.

> Barrel files are boundaries, not convenience dumping grounds.

Use them only to expose a deliberate public feature surface.

Do not create:

- barrel files for every folder;
- mega `core.dart` / `shared.dart` barrels;
- long re-export chains;
- exports that hide circular dependencies.

## State-management summary

Use the simplest state ownership appropriate to scope.

```text
local visual state
→ local Flutter state

shared feature state
→ explicit feature-level owner

cross-feature state
→ only when a demonstrated requirement exists
```

No state-management package is mandated yet.

Do not add Riverpod, Bloc, Provider, Redux, MobX, GetX, or another framework
merely because the app may grow.

## Architecture-change rule

Significant changes require explicit justification.

Examples:

- adding a state-management framework;
- adding dependency injection;
- adding persistence;
- introducing real networking;
- changing feature boundaries;
- adding code generation;
- changing repository contracts.

For non-trivial structural work, use Graphify as required by repository agent
instructions before making broad changes.

## Conflict resolution

If a scoped architecture document conflicts with this director, preserve this
director and the higher source-of-truth order.

If architecture conflicts with the PRD, the PRD wins.

If a structural decision is not covered, choose the smallest design consistent
with existing boundaries rather than inventing a new architecture style.

Do not silently guess when the choice would materially affect the codebase.

## Definition of architectural quality

The architecture is healthy when a developer can quickly answer:

- Where does this feature live?
- Who owns this state?
- Where does this data come from?
- Which implementation can be replaced later?
- What may this feature depend on?
- Why does this abstraction exist?
- How should this behavior be tested?

without tracing through unnecessary layers.

PanganKita architecture should be:

```text
predictable
small
explicit
testable
easy to navigate
replaceable where genuinely needed
```

The goal is not architectural sophistication.

The goal is to make PanganKita easy to build correctly.
