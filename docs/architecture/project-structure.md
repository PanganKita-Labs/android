# Project Structure & Dependency Boundaries

Read `docs/ARCHITECTURE.md` first.

This document defines where Flutter code belongs and which dependency
directions are preferred.

## Current structure and next boundaries

PanganKita's Flutter prototype uses a **shallow, feature-first structure**.
These directories reflect the existing UI, not deployed backend capabilities:

```text
app/lib/
├── main.dart
├── app/                        # routes, composition and theme
├── features/
│   ├── onboarding/             # local authentication demonstrations
│   ├── discovery/              # home, search, product and area selection
│   ├── merchants/              # nearby stores, map, directions, store details
│   ├── shopping/               # session cart, checkout and payment previews
│   ├── orders/                 # illustrative orders, pickup and reviews
│   ├── messaging/              # conversations and support previews
│   ├── notifications/          # display-only notification examples
│   └── profile/                # profile, settings, favorites and terms UI
└── shared/
    ├── models/                 # reused DemoFood and DemoAddon examples
    └── ...                     # existing common UI and formatting helpers
```

`DemoFood` and `DemoAddon` have real consumers across multiple feature areas.
They remain typed **local example models**, not an API or persistence layer.
`DemoCart` is owned by `features/shopping/`, and its lifecycle remains owned
by `PanganKitaApp`. Other features accept the existing cart reference where
required; no global state, new dependency, or business logic is introduced.

Routes and observable behavior are unchanged by this source relocation.
Merchant pages remain in `features/merchants/` from the initial extraction.
Tests remain directly under `app/test/`; moving the tests into subdirectories
is not necessary to establish the feature ownership boundaries.

Do not add `data/`, `domain/`, `presentation/`, services or repositories until
current behavior demonstrates a need for them. Avoid feature dependency cycles.

## `main.dart`

Keep `main.dart` small.

Typical responsibility:

```dart
void main() {
  runApp(const PanganKitaApp());
}
```

Do not put:

- feature screens;
- fixture data;
- repositories;
- routing tables;
- large theme definitions;
- domain logic;

directly in `main.dart`.

## `app/`

`app/` owns application-wide composition.

### `app/pangan_kita_app.dart`

May own:

- `MaterialApp`;
- router hookup;
- theme hookup;
- localization hookup later;
- genuinely top-level state dependencies.

Do not put feature business logic here.

### Optional `app/routing/` (not created yet)

When routing becomes necessary, own route definitions and application navigation composition.

Feature internals should not need the entire application route graph.

### Theme ownership: `app/pangan_kita_theme.dart`

Own the Flutter mapping of the design system:

- semantic colors;
- typography;
- component themes;
- spacing/radius tokens when encoded in Dart;
- theme extensions when justified.

Feature widgets should consume semantic tokens instead of duplicating raw
colors.

## Feature-first organization

Product behavior belongs under `features/`.

Illustrative future boundaries (not current source files):

```text
features/discovery/
features/reservations/
features/business/
```

Add another feature only when a current product capability needs it.

A feature should keep related code close enough that its behavior can be
understood without searching the entire repository.

## Lightweight layers

A feature may contain:

```text
data/
domain/
presentation/
```

Not every feature must have every layer.

### `domain/`

Contains feature concepts that should not depend on Flutter UI.

Examples:

```text
listing.dart
reservation.dart
listing_repository.dart
reservation_repository.dart
```

May include:

- models/entities;
- repository contracts;
- pure validation;
- state-transition logic;
- small meaningful value objects.

Avoid importing Flutter widgets into domain code.

Do not wrap every primitive in a value object without meaningful behavior.

### `data/`

Contains data-source implementations.

Examples of optional future mock-only data sources (not currently present):

```text
mock_listing_repository.dart
listing_fixtures.dart
mock_reservation_repository.dart
reservation_fixtures.dart
```

API implementations may be added only if an approved task requires backend integration.

Do not build fake HTTP/data-source layers during mock-only work.

### `presentation/`

Contains Flutter-facing feature code.

Possible subfolders, only when needed:

```text
pages/
widgets/
controllers/
view_models/
```

Presentation may:

- render state;
- accept user interaction;
- invoke feature operations;
- show loading/empty/error states;
- navigate at feature boundaries.

Presentation must not become the authority for inventory rules, reservation
legality, payment truth, or permissions.

## Dependency direction

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
data implementation
```

The domain contract must not depend on a concrete mock/API repository.

## Cross-feature dependencies

Prefer:

```text
feature
  ↓
shared/core
```

Avoid:

```text
discovery → reservations → business → discovery
```

Circular feature dependencies are a design smell.

Before sharing a concept:

1. determine whether it is genuinely shared;
2. determine whether one feature actually owns it;
3. prefer a narrow contract/model;
4. avoid moving it to `shared/` only to shorten imports.

## `core/`

Use `core/` for truly application-wide technical primitives.

Potential examples:

```text
errors/
extensions/
small generic utilities
```

Do not turn `core/` into a junk drawer.

Avoid vague catch-all files:

```text
common.dart
misc.dart
helpers.dart
everything.dart
```

## `shared/`

Use `shared/` for product/UI concepts already reused across multiple features.

Potential examples:

```text
shared/widgets/price_text.dart
shared/widgets/pickup_deadline.dart
shared/models/business_summary.dart
```

A file does not move to `shared/` because it might be reused later.

Move it when reuse is real or immediately required.

## Barrel files

PanganKita allows controlled barrels.

> Barrel files are boundaries, not convenience dumping grounds.

Good:

```text
features/discovery/discovery.dart
```

with deliberate exports such as:

```dart
export 'presentation/discover_page.dart';
```

Do:

- use feature barrels for deliberate public APIs;
- keep implementation internals unexported by default;
- use direct imports within a feature;
- keep exports shallow;
- expose only what consumers should depend on.

Do not:

- create a barrel for every folder;
- create mega `core.dart` / `shared.dart` files;
- create long re-export chains;
- export internals merely to shorten imports;
- hide circular dependencies through barrels.

Prefer explicit imports when they improve dependency clarity.

## Placement guide

### App composition, routing, theme?

```text
lib/app/
```

### Product capability owned by one feature?

```text
lib/features/<feature>/
```

### Pure feature concept or contract?

```text
features/<feature>/domain/
```

### Data implementation or fixture?

```text
features/<feature>/data/
```

### Flutter UI/state for one feature?

```text
features/<feature>/presentation/
```

### Technical and truly app-wide?

```text
lib/core/
```

### Product/UI concept already reused by multiple features?

```text
lib/shared/
```

If none fit cleanly, re-evaluate ownership before inventing a new top-level
folder.
