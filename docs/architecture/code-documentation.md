# PanganKita source documentation conventions

**Scope:** hand-written Flutter/Dart source in `app/lib/` and maintained helper
scripts. This is an API-writing guide, not evidence of production services.

## Standard

Use [Effective Dart: Documentation](https://dart.dev/effective-dart/documentation)
for Dart code and the [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings)
for Python helper scripts. Dart does **not** use Python's `Args:`, `Returns:`,
or `Raises:` docstring syntax. Use Dart `///` comments instead.

1. Begin a public type or member comment with one complete summary sentence.
   Put explanations of state, inputs, outputs, errors, and limitations in a
   separate paragraph.
2. Document every hand-written public API: its purpose and, when non-obvious,
   constructor parameters, callbacks, return values, null behavior, and errors.
   Include a link such as `[DemoCart]` when the symbol is in scope.
3. Document private state owners, algorithms, adapters, and reusable widget
   components when their role or ownership is not obvious from their name.
   Avoid repeating the surrounding source. Framework overrides such as
   `build`, `initState`, and `dispose` inherit their contracts from Flutter.
4. Explain **observable behavior** rather than promising implementation details
   that may change. Record important invariants and side effects, including
   notifying listeners, navigation, mutation, persistence, validation and
   fallback behavior.
5. Use "Returns..." when a result, especially `bool` or nullable text, needs
   explanation. Use "Throws [ExceptionType]..." only for verified exceptions.
   Parameter names can be linked as `[parameter]` in scope. Do not invent
   error conditions or server guarantees.
6. Explicitly distinguish local demonstration state from live business data.
   Example orders, pickup windows, distances, messages, locations, ratings,
   payments and inventory are **not** evidence of active backend operations.
7. Keep documentation accurate for Indonesian, English and Simplified Chinese
   presentation. Do not translate route identifiers, source symbols, demo
   records or other identifiers merely to make prose sound localizable.
8. Preserve readability: use short paragraphs, purposeful examples and
   `dart format`; prefer precise descriptions over comment volume.

## Examples

A stateful API with an actual result contract:

```dart
/// Adds a configured demo food line to this session's cart.
///
/// Combines lines with matching food and add-ons. Returns `false` without
/// updating listeners when the per-line quantity limit would be exceeded.
/// Throws [RangeError] if [quantity] is outside the supported range.
bool add(DemoFood food, {int quantity = 1, Set<DemoAddon> addons = const {}});
```

A UI boundary:

```dart
/// Displays the local merchant-chat example for [food].
///
/// [previewMessage] is an optional fixture message; this screen does not
/// send or receive messages from a network service.
const MerchantChatPage({required DemoFood food, String? previewMessage});
```

Python scripts use a module docstring and, for nontrivial functions, Google
style sections whose parameter names and exceptions match the actual code:

```python
def check_catalog(path: Path) -> list[str]:
    """Reports malformed entries in the checked-in catalog.

    Args:
        path: Location of the catalog to inspect.

    Returns:
        Validation messages; an empty list means no issues were detected.
    """
```

These examples illustrate documentation style; they are not additional app
APIs or executable snippets expected to compile verbatim.

## Other maintained sources

- Android's hand-written entry activity uses Kotlin KDoc (`/** ... */`)
  following [Android's Kotlin style guide](https://developer.android.com/kotlin/style-guide).
  Leave Flutter-generated platform files and build-system boilerplate alone.
- Maintained Bash scripts use purpose, prerequisite, environment-variable,
  and failure-behavior comments where they clarify usage, following
  [Google's Shell Style Guide](https://google.github.io/styleguide/shellguide.html).
- Do not manufacture repetitive comments for individual test assertions or
  configuration keys that already have self-explanatory names.

## Coverage boundary

- **Include:** hand-authored `app/lib/**/*.dart`, public types and useful
  private implementation contracts; maintained `app/tool/*.py` helpers.
- **Review as needed:** test helpers, native Kotlin entry points, and maintained
  shell scripts whose contracts are not already clear from their names.
- **Exclude:** generated localization Dart files under `lib/i18n/generated/`,
  generated assets/font files, vendored dependencies and mechanical Flutter
  overrides. These should not be hand-edited just to increase a doc count.
- **Not present:** `backend/` currently has guidance and a README, but no
  active application API implementation to annotate.

## Validation before merging

Run from `app/` after the repository's standard setup:

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos --fatal-warnings
dart run dart_code_linter:metrics analyze --fatal-style --fatal-performance --fatal-warnings lib
dart run dartrics analyze --snapshot none --strict-dismiss --fatal-warnings lib
flutter test --coverage
dart doc --dry-run .
```

From the repository root, also run `git diff --check` and check repository
Markdown links when documentation files change. Do not call a command
"passed" unless it ran; GitHub Actions and local results are separate
evidence. For comment-only edits, Graphify refresh is unnecessary.
