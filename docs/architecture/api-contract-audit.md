# PanganKita API contract audit

This inventory covers the **58 hand-authored Dart sources** under `app/lib/` at the
PR #66 second-pass documentation branch. Generated `i18n/generated/` files,
ARB catalogs, vendored dependencies, and Flutter framework methods are excluded
from manual documentation edits.

## Classification

- **C, contract present:** Public API purpose, non-obvious inputs, outputs,
  side effects and demo boundaries are explained in source documentation.
- **I, inherited or self-explanatory:** Flutter overrides, decorative private
  layout widgets, and plain data forwarding do not merit repetitive comments.
- **N, clarified:** A previously missing or ambiguous contract was improved in
  this documentation PR, without changing executable Dart statements.
- **M, missing:** Newly discovered substantive omissions require a follow-up
  correction before the final review gate. An empty M set is *not* a substitute
  for the Dart documentation generator or reviewer verification.

The classifications below apply to the **identified meaningful interfaces in
each file**, not every Flutter framework override, widget tree expression,
or automatically generated symbol. The original count of 361 type-level comments
is not used as a proxy for semantic API completeness.

## Whole-source inventory

| Hand-authored source (relative to `app/lib/`) | Contract surface inspected | Decision |
| --- | --- | --- |
| `app/app_routes.dart` | Route constants, typed order-tab arguments and fixture ID paths | C / I: Documented route construction; inherited framework routing is unchanged |
| `app/navigation/app_bottom_navigation.dart` | Selected tab index and route replacement | C / I: Explicit tab-index contract; child widget presentation is self-explanatory |
| `app/pangan_kita_app.dart` | Session cart, area notifier, restored startup locale and persistence | C / N / I: Documented state ownership, route fallback and storage exceptions |
| `app/pangan_kita_theme.dart` | Material theme, font roles, semantic colors, spacing and radii | C / N / I: Existing public constants documented; fixture savings wording corrected |
| `features/discovery/food_card.dart` | Listing fixture and local product-route navigation | C / N / I: Documented input and fixture-only action; visual parts need no extra contract |
| `features/discovery/hero_banner.dart` | Static campaign and local navigation artwork | C / I: Existing docs explain presentation, not a live promotion |
| `features/discovery/home_header.dart` | Location label and tap callback | C / I: Callback ownership and no GPS acquisition documented |
| `features/discovery/home_page.dart` | Area callback, local search and filters | C / N / I: Default error, route result, query trimming, state ownership documented |
| `features/discovery/location_selection_page.dart` | Area picker, query controller, route-return result and map illustration | C / I: String result/cancellation and illustrative map boundaries documented |
| `features/discovery/product_detail_page.dart` | Shared cart, add-ons, local quantity and clipboard | C / N / I: Cart ownership, callback copying and no inventory reservation documented |
| `features/discovery/search_page.dart` | Local query, nullable bounds, filtered results and favorites | C / N / I: Nullable validation, state disposal, sorting and temporary favorites documented |
| `features/merchants/directions_page.dart` | Static route preview, mode choices and back navigation | C / I: No GPS/ETA; pop versus route replacement documented |
| `features/merchants/nearby_map_page.dart` | Fixture markers and selected merchant | C / N / I: Page-local selection and static, non-geographic map documented |
| `features/merchants/nearby_stores_page.dart` | Fixture search and merchant detail route | C / N / I: No live search or device-location lookup documented |
| `features/merchants/store_detail_page.dart` | Fixture food, shared cart and clipboard | C / N / I: Cart ownership, callback outcomes and asynchronous copy documented |
| `features/messaging/chat_page.dart` | Local conversation search and unread filter | C / N / I: Static message fixtures, no inbox or server read-state documented |
| `features/messaging/merchant_chat_page.dart` | Nullable preview, message draft and local delivery simulation | C / I: Empty draft behavior, controller disposal and no transport documented |
| `features/messaging/support_page.dart` | Controller-owned draft and canned responses | C / N / I: Draft insertion, disposal and unavailable transport documented |
| `features/notifications/notifications_page.dart` | Local read IDs, filter and destination routing | C / N / I: Read-before-navigation ordering and no push service documented |
| `features/onboarding/auth_field.dart` | Caller controller, validator, label and password visibility | C / N / I: Nullable validation output, ownership and mask toggle documented |
| `features/onboarding/auth_page.dart` | Demo auth mode, form validation and routing | C / I: No authentication, password clearing and next-route completion documented |
| `features/onboarding/auth_validation.dart` | Required, email and password validation | C / N / I: Nullable string errors, verified rules and no account validation documented |
| `features/onboarding/otp_page.dart` | Fixed example code, digit paste/backspace and recovery routing | C / I: Controller/focus disposal and local-only validation documented |
| `features/onboarding/password_success_page.dart` | Static password confirmation preview | C / I: No password update; navigation-only widget contract covered |
| `features/onboarding/recovery_page.dart` | Email form, controller and offline OTP route | C / N / I: Valid/invalid navigation behavior and no email delivery documented |
| `features/onboarding/social_sign_in.dart` | Provider artwork and registration/sign-in divider | C / N / I: Callback is an unavailable notice, not OAuth |
| `features/onboarding/splash_page.dart` | Timer, double-navigation guard and animation | C / N / I: Timer cancellation, once-only transition and reduced motion documented |
| `features/onboarding/welcome_page.dart` | Static welcome page and demo route links | C / I: No meaningful parameters beyond inherited widget key |
| `features/orders/canceled_orders_section.dart` | Query-filtered canceled fixture and placeholder actions | C / N / I: Query default and no cancel/refund action documented |
| `features/orders/completed_orders_section.dart` | Query-filtered completed fixture and review navigation | C / N / I: Query default and static order history documented |
| `features/orders/order_detail_page.dart` | Food fixture and local help preview | C / N / I: No reservation, order, payment or pickup code documented |
| `features/orders/order_help_sheet.dart` | Fixture food and modal completion | C / N / I: Future completion on dismissal, no support contact documented |
| `features/orders/orders_page.dart` | Initial tab, order fixtures and local search | C / I: Tab indexes, one-time initialization and no persisted orders documented |
| `features/orders/pickup_page.dart` | Food/quantity preview and review route arguments | C / N / I: No pickup confirmation or stock mutation documented |
| `features/orders/review_page.dart` | Food/quantity, rating, tags and visibility | C / N / I: Local form only; no review posting documented |
| `features/profile/edit_profile_page.dart` | Preview form and local validation | C / I: No profile save or account fetch; simple form widgets need no boilerplate |
| `features/profile/favorites_page.dart` | Local favorites and two independent removal states | C / N / I: No cross-page or persisted favorite mutation documented |
| `features/profile/profile_page.dart` | Location-reader callbacks and profile fixture | C / I: Mounted route result and default ArgumentError documented |
| `features/profile/settings_document_page.dart` | Privacy-document placeholder | C / I: No approved policy promised; inherited build contract |
| `features/profile/settings_page.dart` | Language owner callback, switches, settings-row actions | C / N / I: Callback precedence and ephemeral switch defaults documented |
| `features/profile/terms_page.dart` | Local reference terms and unavailable official policy | C / I: No enforceable terms claimed; presentation-only widget |
| `features/shopping/cart_line_card.dart` | Cart line, quantity controls and removal | C / N / I: Snapshot freshness, owner, quantity limit documented |
| `features/shopping/cart_page.dart` | Shared cart, live lines, notes and subtotal | C / N / I: Observes ChangeNotifier without ownership or backend submission |
| `features/shopping/checkout_order_details.dart` | Read-only session cart line summary | C / N / I: Whole-rupiah example totals and caller ownership documented |
| `features/shopping/checkout_page.dart` | Shared cart, local pickup acknowledgment and route | C / N / I: Nullable checkbox and local-only navigation documented |
| `features/shopping/demo_cart.dart` | Quantity bounds, add-on normalization and notifications | C / I: Verified RangeError, boolean success, no-op and list aliasing documented |
| `features/shopping/payment_failed_page.dart` | Fixture failure display and retained cart | C / N / I: No charge, retry or cart clearing documented |
| `features/shopping/payment_method_sheet.dart` | QRIS modal preview | C / I: Future resolves on dismissal, no payment transaction documented |
| `features/shopping/payment_status_page.dart` | Read-only cart and unavailable QR/payment state | C / N / I: No invoice, charge, inventory or server order documented |
| `features/shopping/payment_success_page.dart` | Hypothetical success display and pickup-time label | C / N / I: No confirmed payment; multimerchant and empty fallback documented |
| `i18n/i18n.dart` | Stable localization export and nullable context getter | C / I: Uninitialized delegate returns null; generated files excluded |
| `i18n/i18n_text.dart` | Display-only translation lookup and Text parameter forwarding | C / I: Unknown phrases unchanged; text shaping locale distinct from language |
| `main.dart` | Preference restoration, font license registration and app start | C / N / I: Unknown language/failure falls back to Indonesian; no cart restoration |
| `shared/demo_notice.dart` | Local snackbars and unavailable-feature notice | C / N / I: Previous snackbar hidden; no device notification generated |
| `shared/format_rupiah.dart` | Whole-rupiah formatting | C / I: Public amount/result examples already documented |
| `shared/models/demo_addon.dart` | Fixed add-on enum, label and rupiah amount | C / N / I: Enum constructor values are fixture-only, not live merchant prices |
| `shared/models/demo_food.dart` | Fixture listing fields, defaults, IDs and search | C / I: Constructor defaults, bool match and no live inventory documented |
| `shared/reference_icon.dart` | Asset name, size and tint | C / N / I: Asset path derived from name; no asset validation or extra semantics |

## Other maintained source interfaces

| Source | Audit decision |
| --- | --- |
| `app/tool/check_i18n.py` | Google-style docstrings for public helpers and nontrivial catalog/source-scanning contracts; errors are accumulated, not silently discarded |
| `app/tool/test_check_i18n.py` | Test fixtures, mutation callbacks and helper results documented; individual test descriptions remain concise |
| `.github/scripts/check_mojibake.py` | Git text discovery, reversible UTF-8 detection and nullable return behavior documented |
| `.github/scripts/check_trailing_whitespace.py` | Repair planning, staged-byte ownership, ambiguous Markdown and atomic refusal documented; no index mutation promised |
| `.github/scripts/fetch_satoshi.py` | Download purpose and license behavior documented; font assets are not committed |
| `.github/scripts/run_android_smoke.sh` | Required emulator/tooling and diagnostic artifact behavior described in shell header |
| `app/android/app/src/main/kotlin/com/example/pangankita/MainActivity.kt` | Existing KDoc describes the thin Flutter activity entry point; no overridden native business API |

## Accuracy and non-duplication decisions

The source contract has been checked against important runtime boundaries:
locale restoration happens in `main.dart` before root construction, whereas
later changes are written by `PanganKitaApp`; direct `DemoCartLine` instances
may retain mutable add-on lists; all orders/payments, GPS, messages, prices,
merchant availability, authentication and push notifications are local examples.

No extra documentation is added to ordinary `build`, `initState`,
`dispose`, `paint` or `shouldRepaint` overrides solely to increase coverage.
Short, private, presentation-only constructors are covered by their surrounding
widget descriptions unless they introduce ownership, validation or callback
semantics that callers must know.

## Validation evidence required at review

- Hosted Quality: formatting, fatal Flutter analyzer, DCL including unused-code,
  unused-files and unnecessary-nullable checks, strict Dartrics and tests with
  coverage. Read the actual status for the **current** PR head.
- Documentation generation: `dart doc --dry-run .` from `app/` (not present
  in the existing hosted Quality job). Verify unresolved references/warnings.
- Python: syntax, i18n checker mutation tests and applicable text-integrity
  scripts. Respect tool availability and do not call unexecuted checks green.
- Confirm `git diff --check`, documentation links and generated-file exclusion.

This document inventories decisions, not a certification of production behavior
or a replacement for executing the remaining checks.
