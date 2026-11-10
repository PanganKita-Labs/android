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

## Adversarial semantic re-audit

**Primary evidence:** source and call sites at commit
`8ea0b5f66c2734ec2ef5d0933e6bca7fe611efef`, compared with
current PR implementation. Prior documentation counts and PR descriptions
were treated as hypotheses, **not** proof of semantic correctness.

| Contract checked | Primary implementation evidence | Review result |
| --- | --- | --- |
| Fixture image path | `DemoFood.image` in `shared/models/demo_food.dart` | The `garlic-bread` branch produces the same path as ordinary ID interpolation; corrected a misleading "special filename" claim |
| Home location ownership | `HomePage.onLocationChanged`, `_ignoreAreaChange`, `_chooseLocation` | Default callback validates but does not persist; corrected the unconditional "root app" wording |
| Search-result criteria | `_SearchPageState._results` | Text, category, inclusive optional bounds, and local sorting all affect results; clarified the incomplete comment |
| QRIS modal result | `showPaymentMethodSheet`, `PaymentMethodSheet.build` | QRIS is presented statically; the button dismisses the sheet and no payment choice or transaction is recorded |
| Cart notification semantics | `DemoCart.add`, `setQuantity`, `remove`, `clear` | Added a focused regression test for successful mutation versus rejection, unknown IDs, unchanged values, and empty-cart operations |
| Directions back behavior | `_DirectionsPageState._backToMap` | A programmatic pop returns to the previous route, not necessarily a map. Corrected an unconditional map-destination description |
| Authentication and OTP | `_AuthFormState._submit`, `_OtpPageState._verify` | No network authentication or code delivery; form validation and fixed-code navigation match the documented demo boundary |
| Preference restoration | `main.dart` and `_PanganKitaAppState._setLocale` | Startup reads preferences before constructing the app; root handles subsequent writes |
| Cart line aliasing | `DemoCartLine` constructor and `DemoCart.add` | Direct callers can pass mutable add-ons, whereas canonical cart additions normalize and freeze them |

The separate declaration scan is **heuristic**: it cannot prove that every
multi-line declaration, extension, typedef, inherited member, or private helper
has the right contract. The native `public_member_api_docs` analyzer rule and
`dart doc --dry-run .` provide additional syntax/coverage evidence, but neither
can prove that prose is semantically true.

**Independent behavioral witness:** `test/features/shopping/demo_cart_test.dart`
now asserts listener counts for both changes and no-ops. The test is useful
only after `flutter test --coverage` passes on the commit that includes it.
No new application behavior or API signatures were introduced.

**Scope boundary:** This re-audit concentrates on correctness of meaningful
state, validation, callback, persistence, routing, and demonstration contracts.
It does not try to increase comment volume on straightforward layout helpers
or replace Flutter framework documentation.

## API documentation certification evidence

**Validated commit:** `d026141893f788fa05f0bbcd50b5ac5e2a24c4a3`
([hosted Quality evidence](https://github.com/PanganKita-Labs/android/actions/runs/42835457221)).
This is a scoped source-documentation certification, not a claim of live
production functionality or a guarantee that prose can never become stale.

### Declaration and contract review

- All 58 hand-authored `app/lib/` Dart files are represented in the inventory.
- A separate public-member scan identified 61 public types, 49 public
  constructors, 20 public method candidates, and 128 public field candidates.
  Every recognized candidate had adjacent Dart documentation. These are
  conservative syntactic counts rather than a substitute for source review,
  and they exclude ordinary inherited overrides and uninteresting private
  presentation details.
- Manual contract review addressed inputs, significant defaults, boolean and
  nullable results, validated exceptions, callbacks, asynchronous navigation,
  ownership/disposal, session persistence, and demo-only domain boundaries.
- Existing comments were corrected for accurate locale restoration, add-on
  list aliasing, example pricing, and local-only behavior. Public contracts
  should not invent production integrations.

### Executed checks

| Validation | Evidence and result |
| --- | --- |
| `dart doc --dry-run .` | PASS: **0 warnings, 0 errors** in the API documentation job |
| Maintained Python syntax | PASS: all 5 files parsed with `ast.parse` |
| Strict Flutter analyzer | PASS in hosted Quality |
| Dart formatting | PASS in hosted Quality |
| Dart Code Linter and unused checks | PASS in hosted Quality |
| Strict Dartrics (`--snapshot none --strict-dismiss --fatal-warnings`) | PASS in hosted Quality |
| `flutter test --coverage` | PASS: 291 tests |
| Aggregate Quality gate | PASS |
| i18n / Text Integrity / Links | PASS on the validated commit |
| PR patch whitespace inspection | No added trailing whitespace identified |
| PR Dart patch review | No executable Dart lines changed |

The PR's Quality workflow now runs documentation generation and Python syntax
verification as required checks; it was not part of the earlier workflow.
Recheck the latest branch HEAD's workflows after any subsequent commit. The
Android Build and Launch Smoke workflows are separate from API-documentation
certification and should also pass before release approval.

### Certification boundary

For the inspected, maintained hand-written source, **the required API
documentation contracts and checks are satisfied at the validated commit**.
Generated localization Dart, vendored code, third-party libraries and framework
overrides are intentionally excluded from manual documentation. No comment
volume target substitutes for semantic review. The latest PR HEAD must retain
all required successful checks before review approval or merge.
