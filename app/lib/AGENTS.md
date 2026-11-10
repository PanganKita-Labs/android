# PanganKita Flutter Source Agent Instructions

Applies to `app/lib/**` in addition to `../AGENTS.md` and the repository-root
instructions. These are the **source-specific** contracts: Flutter UI and
domain behavior, state ownership, privacy and product integrity.

Read the [architecture director](../../docs/ARCHITECTURE.md) and its
[project-structure](../../docs/architecture/project-structure.md),
[state-and-data](../../docs/architecture/state-and-data.md), and
[UI/widgets](../../docs/architecture/ui-and-widgets.md) guidance as relevant.
Rules about possible future services are **guardrails**, not claims that those
services are already implemented.

## Source layout and state

- One file should have one primary responsibility. Avoid both god files and
  meaningless one-function files; respect the public-widget file lint.
- Keep `main.dart` minimal and feature code inside cohesive owners. Do not
  scatter transport JSON or `dynamic` through UI; validate at boundaries and
  use typed models, immutable data and explicit enums/sealed states where useful.
- Presentation owns widgets and transient visual state, not authoritative
  business rules. Prefer the simplest native state owner; add state-management
  or dependency-injection packages only after a real need is demonstrated.
- Keep ownership, scope, disposal, and listener notification clear; do not
  introduce global mutable singletons or leak subscriptions/controllers.

## Inventory, reservations and food integrity

- Inventory and reservation rules become authoritative **only at a future
  backend**. Never claim sample quantities are verified inventory or a preview
  order represents a placed reservation.
- If that capability is approved later, reject negative quantities, overselling
  and illegal lifecycle transitions. Document and test actors, legal/illegal
  transitions, terminal states, expiry, cancellation, pickup consistency,
  and restoration rules.
  Make retries and duplicate actions safe; do not rely on "best effort" or a
  device clock to enforce server-owned invariants.
- Food-safety claims require verified policy and evidence. Do not invent BPOM,
  Ministry of Health, shelf-life, allergen, storage, legal-liability, or safety
  certification guarantees. Treat seller-provided data as unverified and seek
  explicit review for eligibility, condition, pickup deadlines and complaints.
- Design for misleading listings/photos, spam, impersonation, fraudulent
  reports, duplicate accounts, harassment, account takeover, abusive ratings,
  and no-shows. Do not automate punishment without an evidence-backed review
  and appeal process.

## Accounts, private data, uploads

- Authentication identifies a user; authorization governs an operation.
  Client-side role checks are not a substitute for backend enforcement.
  Do not add roles or permissions without an approved use case and tests.
- Ask for the least precise, least retained location necessary; handle denied
  permission, avoid logging coordinates or exposing home locations, and do
  not reuse location for analytics without approval. Current map examples
  are illustrations, not GPS or live navigation.
- Treat future uploads as untrusted. Validate file format/metadata, actual
  decoded bytes, dimensions and size; define EXIF policy, generated storage
  names, public/private access, signed links and retention. Never trust a
  filename or MIME header alone.
- Avoid secrets, credentials, sensitive user text or merchant data in logs,
  screenshots or telemetry. Keep collected data purpose-limited.

## UI behavior, accessibility and localization

- Use meaningful Flutter semantics, accessible names for icon-only controls,
  readable errors, logical focus, sufficient contrast, suitable tap targets
  and text scaling; do not rely on color alone. Respect reduced-motion settings.
- Mobile-first layouts must consider narrow screens (roughly 320–412 logical
  pixels), landscape where relevant, keyboard and safe-area insets, long copy,
  large type, and loading/empty/error/retry states, including network loss.
  Preserve useful content during background refresh where practical; avoid
  indefinite spinners, raw exceptions, clipping and horizontal overflow.
- Indonesian is the default language; **Indonesian, English and Simplified
  Chinese are already implemented**. Preserve the current locale selection,
  supported catalogs and fallback behavior. Keep labels, accessibility text
  and errors localization-ready. Review legal and food-safety translations
  rather than mechanically translating them.
- Do not manually edit generated localization files. Coordinate changes to
  ARB sources, code generation, tests and the existing i18n checker.
- External screenshots or design references guide UI fidelity, not factual
  claims about live services. Consult `../../docs/DESIGN.md` for applicable UI
  constraints; never commit private reference images without permission.

## Time, money, matching and telemetry

- Never compare formatted time strings or silently mix time zones. Store
  timestamps unambiguously, convert at the UI boundary and test pickup,
  deadline, cancellation and date-boundary behavior when implemented.
- Use integer minor units or another precise representation for money, never
  floating point. Discounts, fees, refunds, settlement and dynamic pricing
  need explicit requirements and tests. Example prices are not offers.
- Future ranking should begin deterministic and explainable, with documented
  inputs, cold-start fallback, fairness review and baseline comparisons.
  Add ML only for a validated need, never for appearance or speculative impact.
- Collect analytics only for an identified purpose, with approved privacy
  handling. Distinguish measured, calculated and estimated impact; never
  claim improvements without evidence.

## Errors, async and verification

- Use structured, privacy-conscious logging. Do not swallow exceptions,
  leave unmanaged `print`/`debugPrint` in production paths, or expose raw
  errors. Translate failures into useful UI states while protecting data.
- Check `mounted` after async gaps before using context/state; dispose
  controllers, listeners and streams. Do not ignore futures without intent.
  Handle duplicate taps and concurrent work to prevent duplicate mutations.
- Test meaningful business rules outside widgets, and verify user-observable
  behavior with targeted widget tests. Document public API inputs, results,
  callback timing, errors, mutation, and disposal where non-obvious.
- Run the shared gates in `../AGENTS.md` and platform/device checks where
  affected. Do not disable strict analyzer, DCL, Dartrics or documentation
  requirements to make a change pass.
