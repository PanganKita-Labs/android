# PanganKita Design Contract

**Status:** Active from-scratch Flutter UI baseline.
**Visual source:** Approved screenshots or HTML provided with an individual task.
**Repository policy:** Do not commit screenshots/HTML references to the repo.

## Brand is retained

The official PanganKita brand is NOT being reset. Retain approved logo assets,
identity, typography, and semantic colors. Canonical brand palette:

- Forest Green: `#1B6B3A` (primary)
- Dark Green: `#0D4D2B`
- Warm Orange: `#F5921B` (accent)
- Light Orange: `#F8B75C`
- Soft Cream: `#FAF6F0` (background)
- Charcoal: `#2D2D2D` (text)
- Light Gray: `#E8E4DF` (border)

Official typography roles:

| Role | Family and weight |
|---|---|
| Display, headings, titles, product names, current prices | Geist Semibold/Bold (600/700) |
| CTA, action links, bottom navigation, important numbers | Geist Semibold/Bold (600/700) |
| Body, descriptions, captions, helper text | Satoshi Regular/Medium (400/500) |
| Merchant names, ratings, addresses, timestamps, stock, original prices | Satoshi Regular/Medium (400/500) |
| Form fields, labels, search placeholders, category chips, badge labels | Satoshi Regular/Medium (400/500) |

Savings badges use Satoshi for the word "Hemat" and Geist for the percentage.
The role determines the face: form values (including OTP), ratings, timestamps,
and stock labels remain Satoshi even when they contain numbers.
The latest role specification also applies to Daftar/Login actions: use Geist.

Geist Semibold/Bold are bundled from the [official Geist project](https://github.com/vercel/geist-font)
with `app/assets/fonts/Geist-OFL.txt`. Satoshi faces are fetched directly from
Fontshare by `.github/scripts/fetch_satoshi.py`; the font files and ITF license
remain Git-ignored. Run that setup before builds and tests. Both families are
registered with Flutter's license registry. Do not silently substitute a system
font or require Arial/Liberation Sans metrics in typography tests.
Preserve the existing `app/lib/app/pangan_kita_theme.dart` brand theme as the
starting point. A screenshot-specific color difference is not an automatic
brand change: resolve it explicitly against the official brand guidelines.

## Screenshot-to-Flutter: strict visual fidelity

An approved screenshot is the visual source of truth for the requested screen,
subject to product, accessibility, brand, and safety constraints. Aim for a
faithful 1:1 reconstruction **at the reference logical viewport**:

- exact application-owned layout hierarchy, ordering and composition;
- spacing, alignment, typography, color, radii, borders, icons and image crop;
- compact, usable proportions rather than inflated screenshot pixels;
- whole-screen and below-the-fold content where the screen is scrollable;
- interactions and visual states actually covered by the requested task.

No arbitrary redesign, omission, decorative additions, stock substitutions or
"close enough" approximations. Do not use a single screenshot as a background
or a WebView instead of real Flutter widgets. Do not claim parity without
rendering Flutter at the reference viewport and visually comparing the result.
Describe material deviations honestly.

## Native and responsive rules

The screenshot is application content, not a phone mockup. Flutter/Android owns
system status icons, clocks, battery indicators and gesture bars. Do not draw
them as widgets. Use `Scaffold`, `SafeArea`, and correct system/keyboard insets.
Do preserve the application's own bottom navigation when in the reference.

Validate representative logical widths (320, 360, 390 and 412) plus heights,
text scaling (including 1.6x), keyboards, long Indonesian copy, loading,
errors and empty states. Never hide overflow with clipping. No inaccessible
controls, `RenderFlex` overflow or unintended horizontal scrolling. Ordinary
Login/Daftar pages should not scroll because of giant spacers or controls;
long feeds and genuinely constrained forms may scroll naturally.

## From-scratch architecture rules

The previous UI, routes, repositories, fixtures, state transitions and tests
were intentionally retired. Rebuild only features requested with approved
reference screens and product requirements. There is no existing app behavior
to preserve beyond the bootstrap, brand theme and engineering configuration.

Prefer feature-first ownership where useful. Split screens and meaningful
widgets by responsibility, not one godfile and not countless trivial files.
Keep data/domain concerns outside widgets; introduce repository abstractions
only when actual behavior demands them. Evaluate proposed dependencies and
abstractions before implementation; KEEP/DEFER/REJECT are valid outcomes.
No premature state-management package, speculative backend or fake integration.
Use idiomatic Flutter, Google-style docstrings for meaningful public APIs,
and comply with `AGENTS.md`, `app/AGENTS.md`, and `docs/ARCHITECTURE.md`.

## Product truth and safety

Follow `PRD.md`: PanganKita is a pickup-first surplus-food product, not generic
food delivery or an unverified charity/impact project. Never invent real OTP,
authentication, payments, map/location, notifications, safety certifications,
merchant verification, ratings or CO2 savings. A reference may visually show
such elements; implement truthful demo/unavailable behavior or report the
conflict before treating it as a live capability.

## Acceptance process

For each new screen: receive the screenshot in the task, inspect all visible
regions, map it to Flutter widgets, implement in a focused feature, compare
actual renders to the reference, test small viewports, and run configured code
quality gates. Do not mark a page complete based only on successful compile.
Do not add reference files to Git.
