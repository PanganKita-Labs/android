# State, Data & Repository Architecture

Read `docs/ARCHITECTURE.md` first.

This document defines state ownership, repository seams, mock-data rules, DTO
policy, dependency injection, time handling, and potential data-source boundaries.

**Current implementation:** no domain/data features, repositories, fixtures, or
feature state exist. Examples below are hypothetical until implemented.

## State ownership

Use the simplest state ownership appropriate to scope and lifetime.

### Local visual state

Use local Flutter state for things such as:

- selected chip;
- temporary expansion;
- text-field visibility;
- local form interaction.

A `StatefulWidget` is acceptable when it is the simplest correct tool.

Do not introduce a state-management framework for trivial local state.

### Feature state

Use one explicit feature-level state owner when several screens/widgets need to
coordinate meaningful state.

Examples:

- current reservation;
- merchant listing draft;
- reservation queue;
- local listing mutations.

The exact implementation may be:

- controller;
- notifier;
- view model;
- another small idiomatic Dart/Flutter mechanism.

Choose based on current complexity.

### Cross-feature state

Introduce cross-feature state only when a demonstrated requirement exists.

Do not create global mutable application state preemptively.

## State-management package policy

This architecture does **not** currently mandate:

```text
Riverpod
Bloc
Provider
Redux
MobX
GetX
```

Do not add one merely because the application may grow.

If simple/native state becomes insufficient, choose a package through an
explicit architecture decision based on current requirements.

## Repository pattern

Introduce a repository contract only when it provides a real source-of-truth
boundary, test seam, or justified choice of implementations. Do not build
interfaces solely because a future backend is imaginable.

**Illustrative example (not implemented):**

```text
ListingRepository
    ↑
MockListingRepository (only for an approved deterministic prototype)
    or
ApiListingRepository (only for an approved backend integration)
```

Do not automatically add service/use-case/manager/facade layers around a
repository.

## Optional mock data and fixtures

If a future approved task genuinely needs local-only demo data, keep it
explicitly illustrative and deterministic. A possible shape is:

```text
presentation
    ↓
typed model / feature state
    ↓
(optional) repository contract
    ↓
mock data source / fixtures
```

Keep fixture values out of production widgets. Merchant, listing, price,
quantity, pickup time and reservation examples must be clearly labeled demo
content, not verified operations. No fixtures or such repositories exist now.

## Models

Models should represent meaningful product concepts.

Examples:

```text
Listing
MerchantSummary
Reservation
PickupWindow
```

Prefer focused immutable data structures.

Use enums/sealed state when they make invalid state harder to represent.

State names should match the PRD.

Avoid generic speculative bases:

```text
BaseEntity
BaseModel
SerializableEntity
AbstractDomainObject
```

## DTO policy

DTOs are unnecessary until a real serialization or external data boundary justifies them.

Introduce DTOs when:

- a real external API exists;
- external representation differs from domain representation;
- serialization concerns would otherwise leak upward.

Future:

```text
API JSON
↓
DTO
↓
domain model
↓
presentation
```

Do not expose raw API maps/JSON to widgets.

## Dependency injection

Do not introduce a DI framework unless a real complexity problem
requires it.

Prefer constructor injection.

Conceptually:

```dart
DiscoverController(repository: listingRepository)
```

Top-level application composition may construct explicit dependencies when
real feature requirements justify them.

Avoid hidden global service locators.

## Time and deadlines

Time is core to PanganKita.

Do not scatter calls to the system clock throughout domain logic.

When behavior materially depends on current time:

- pass the time into pure logic; or
- use a tiny replaceable clock abstraction when repeated use justifies it.

This keeps expiration/deadline behavior deterministic in tests.

Do not create a large time service solely for formatting.

## Persistence

When state is needed, in-memory state may be sufficient for an approved UI-only demo.

Do not add SQLite, Hive, Isar, or another persistence layer only to make the
UI-only demo appear production-ready.

Add persistence when a current requirement needs restart durability.

When persistence becomes necessary, define:

- what persists;
- why;
- expected lifetime;
- migration expectations.

## Backend boundary

The Flutter client must not assume an unapproved backend implementation.

Flutter should depend on narrow domain/repository contracts instead of concrete
HTTP details.

Illustrative future seam (not implemented):

```text
MockListingRepository
        ↓ replace
ApiListingRepository
```

without redesigning feature widgets.

## Authentication boundary

No authentication or authorization feature currently exists. When an approved
reference includes Login, Daftar, or OTP, UI-only implementation is not proof
of a real identity service. Do not invent fake JWTs, refresh-token machinery,
OAuth providers, or secure-session claims to support a visual mockup.

The previous local consumer/business role-switching demo was intentionally
removed; do not recreate it merely because this architecture once described it.

## Payment boundary

The PRD describes a pickup-oriented marketplace; any payment-at-pickup behavior
is a **product direction**, not an implemented payment integration.

Do not create a payment repository, wallet state, payment SDK, or settlement
architecture without approved requirements for that capability.

## Location/maps boundary

No live map, geolocation permission flow, or location service currently exists.
A future UI-only task may use an explicitly labeled static example. Do not
claim the user's actual location or introduce a maps SDK solely to imitate a
screenshot.

## Analytics boundary

Do not add production analytics during screenshot-driven UI reconstruction.

When analytics is selected later, avoid scattering provider-specific calls
directly through widgets.
