# Architecture Decisions & Current Boundaries

Read `docs/ARCHITECTURE.md` first.

This document records current architectural guardrails and how significant
changes should be evaluated.

## Current implementation boundary

The active application is a **branded Flutter bootstrap** with a single smoke
test. Previous feature UI, mock repositories, domain models, fixtures, local
state transitions, and feature-specific tests were intentionally retired. No
backend, real authentication, location integration, payment, analytics,
merchant verification, or marketplace flow exists in the active source tree.

Feature-first patterns and mock examples elsewhere in this documentation are
**prospective engineering guidance**, not a record of currently working code.
Introduce only the features and supporting dependencies approved for the task;
preserve the established brand, accessibility, product truth and quality gates.

## Dependency policy

Add a package only when it provides clear value over:

- Dart standard library;
- Flutter SDK;
- a small amount of straightforward maintainable code.

Evaluate:

- maintenance activity;
- license;
- Flutter/Dart compatibility;
- platform support;
- transitive dependency weight;
- API stability;
- architectural lock-in.

Do not add a package solely to avoid a small helper.

## Code generation

Do not introduce code generation without a demonstrated benefit.

Possible future reasons:

- serialization;
- routing;
- immutable-model generation.

Code generation adds:

- toolchain complexity;
- build steps;
- dependency coupling;
- repository noise.

Prefer handwritten models when models are introduced, unless generation
clearly improves maintainability.

## State-management framework

No state-management package is currently mandated.

Adding one is an architectural decision, not an implementation convenience.

A proposal should explain:

- what existing state problem cannot remain simple;
- why native/current ownership is insufficient;
- why the selected package fits the problem;
- migration cost;
- testing impact.

## Dependency injection framework

No DI framework is currently required.

Constructor injection is preferred.

Do not add a service locator or DI container merely to centralize object
construction.

## Persistence

When a real feature needs state, a simple in-memory owner may be sufficient.

Do not add persistent local storage unless restart durability becomes a current
requirement.

## Backend

Flutter must remain independent of any unapproved backend implementation.

Introduce real networking only in an explicitly approved integration task.

## Authentication

No production authentication exists; add it only under approved requirements
and appropriate security review.

Do not introduce fake JWT, token-refresh, OAuth, or secure-session systems.

## Payment

The PRD describes reservation with payment at pickup as an intended MVP
product flow; neither is implemented in the active Flutter baseline.

Do not create payment/wallet/settlement architecture without an approved current requirement.

## Maps and geolocation

An approved UI-only task may use a clearly labeled static location example.
No live geolocation exists. Do not add a maps SDK solely to reproduce a screenshot.

## Analytics

Do not add production analytics until a provider/privacy model is deliberately
chosen.

When instrumentation is eventually introduced, provider-specific calls should
not be scattered directly through UI widgets.

## WebSockets / real-time infrastructure

Do not introduce WebSocket/event-stream infrastructure without an approved
real-time requirement. No former local state transitions remain implemented.

## Significant architecture changes

A significant change should document:

```text
problem
current limitation
options considered
chosen change
trade-offs
migration impact
```

Examples requiring deliberate review:

- state-management framework;
- DI framework;
- persistence;
- networking;
- code generation;
- changed feature boundaries;
- new cross-feature dependency;
- changed repository contracts;
- major routing architecture change.

Do not silently introduce a second architectural style.

## Stop conditions

Stop and report instead of guessing when:

- PRD and architecture appear incompatible;
- a change requires production infrastructure outside the approved task;
- a new dependency materially changes architecture;
- a cross-feature cycle appears necessary;
- the only way forward seems to require a global singleton/service locator;
- the architecture rules conflict with strict quality gates;
- a requested abstraction has no clear current responsibility.

## Current non-goals

Do not add merely for future readiness:

```text
generic use-case framework
event bus
service locator
offline database
generic caching layer
fake HTTP stack
WebSocket layer
payment abstraction
auth token system
analytics provider abstraction
deep-link platform
codegen framework
```

Future needs may change these decisions. When they do, update architecture
deliberately rather than bypassing the documented boundary.
