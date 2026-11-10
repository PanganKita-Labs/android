#!/usr/bin/env python3
"""Validate PanganKita i18n catalogs and guarded display-source coverage.

Runs with Python's standard library, without Flutter or network access.
Indonesian is the authoritative message and placeholder catalog.
"""

from __future__ import annotations

import argparse
import ast
from collections import Counter
from dataclasses import dataclass
import json
from pathlib import Path
import re
import sys

APP_ROOT = Path(__file__).resolve().parent.parent
LOCALES = ("id", "en", "zh", "zh_Hans")
PLACEHOLDER = re.compile(r"(?<!\{)\{([A-Za-z_]\w*)\}(?!\})")
ICU_VARIABLE = re.compile(r"\{([A-Za-z_]\w*)\s*,\s*(?:plural|select|selectordinal)\s*,")
# Dart format can wrap a long switch label into adjacent quoted literals. Parse
# the entire constant expression, rather than assuming one quoted token.
LOOKUP_LITERAL = r'"(?:\\.|[^"\\])*"'
LOOKUP_ENTRY = re.compile(
    rf"^[ \t]*((?:{LOOKUP_LITERAL}\s*)+)=>\s*strings\s*\.\s*(\w+)\s*,",
    re.M,
)
GETTER_REFERENCE = re.compile(r"\bstrings\.(ui\w+)\b")
I18N_CALL = re.compile(r"\b(?:I18nText|translateDisplayText)\s*\(")
UNLOCALIZED_TEXT = re.compile(r"(?<![\w])Text\s*\(")
ATTR_LITERAL = re.compile(r"\b(tooltip|hintText|labelText|semanticLabel|helperText|errorText)\s*:")
TOOLTIP = re.compile(r"\bTooltip\s*\(")
TEXT_SPAN = re.compile(r"\bTextSpan\s*\(")
DART_STRING = re.compile(r"(['\"])((?:\\.|(?!\1)[^\\])*?)\1", re.S)


class DuplicateObjectKey(ValueError):
    """Raise when a JSON object repeats a key that json.load would overwrite."""


def no_duplicate_keys(pairs: list[tuple[str, object]]) -> dict[str, object]:
    """Builds a JSON object while rejecting duplicate keys.

    Args:
        pairs: Key-value pairs supplied by the JSON object-pairs hook.

    Returns:
        A dictionary retaining each unique key and its value.

    Raises:
        DuplicateObjectKey: If a key occurs more than once.
    """
    result: dict[str, object] = {}
    for key, value in pairs:
        if key in result:
            raise DuplicateObjectKey(f"duplicate JSON field {key!r}")
        result[key] = value
    return result


def load_json(file: Path) -> dict[str, object]:
    """Loads an object-shaped JSON file with duplicate-key detection.

    Args:
        file: UTF-8 or UTF-8-with-BOM JSON file to read.

    Returns:
        The decoded top-level JSON object.

    Raises:
        ValueError: If the top-level value is not an object or a key repeats.
        OSError: If the file cannot be read.
        json.JSONDecodeError: If the JSON syntax is invalid.
    """
    data = json.loads(file.read_text(encoding="utf-8-sig"), object_pairs_hook=no_duplicate_keys)
    if not isinstance(data, dict):
        raise ValueError("expected a JSON object")
    return data


def message_keys(data: dict[str, object]) -> set[str]:
    """Returns the message names excluding metadata entries.

    Args:
        data: A decoded Flutter localization catalog.

    Returns:
        Keys not prefixed with the metadata marker at sign.
    """
    return {key for key in data if not key.startswith("@")}


def tokens(message: str) -> Counter[str]:
    """Counts ordinary and ICU variable placeholders in a message.

    Args:
        message: Localized message text to examine.

    Returns:
        Placeholder names with their occurrence counts.
    """
    return Counter(PLACEHOLDER.findall(message) + ICU_VARIABLE.findall(message))



@dataclass(slots=True)
class _CatalogCheck:
    """The authoritative and translated data for validating one locale."""

    locale: str
    data: dict[str, object]
    source: dict[str, object]
    unchanged_terms: set[str]
    errors: list[str]


@dataclass(slots=True)
class _SourceCheck:
    """Shared lookup and exception bookkeeping for Dart source scanning."""

    mapping: dict[str, str]
    exceptions: dict[tuple[str, str, str], str]
    used_exceptions: set[tuple[str, str, str]]
    errors: list[str]


def _load_catalogs(root: Path, errors: list[str]) -> dict[str, dict[str, object]]:
    """Read each configured locale and verify its declared language code."""
    catalogs: dict[str, dict[str, object]] = {}
    for loc in LOCALES:
        path = root / "lib" / "i18n" / "arb" / f"app_{loc}.arb"
        try:
            data = load_json(path)
        except (OSError, ValueError, json.JSONDecodeError) as exc:
            errors.append(f"{path.relative_to(root)}: {exc}")
            continue
        catalogs[loc] = data
        if data.get("@@locale") != loc:
            errors.append(f"{path.relative_to(root)}: @@locale must be {loc!r}")
    return catalogs


def _unchanged_terms(config: dict[str, object], errors: list[str]) -> dict[str, object]:
    """Read the intentional untranslated-term exceptions."""
    allowed = config.get("unchanged_from_id", {})
    if not isinstance(allowed, dict):
        errors.append("exception file: unchanged_from_id must be an object")
        return {}
    return allowed


def _check_catalog_keys(
    check: _CatalogCheck, keys: set[str], source_keys: set[str]
) -> None:
    """Report missing, additional, and outdated exempted message keys."""
    for key in sorted(source_keys - keys):
        check.errors.append(f"{check.locale}: missing Indonesian source key {key}")
    for key in sorted(keys - source_keys):
        check.errors.append(f"{check.locale}: unexpected key {key}, not in Indonesian catalog")
    for key in sorted(check.unchanged_terms - source_keys):
        check.errors.append(f"{check.locale}: outdated unchanged-term exception {key}")


def _check_message_text(
    check: _CatalogCheck, key: str, value: str, source: str
) -> None:
    """Compare placeholders and intentional identical source text."""
    if tokens(value) != tokens(source):
        check.errors.append(
            f"{check.locale}:{key}: placeholder mismatch: expected {dict(tokens(source))}, "
            f"got {dict(tokens(value))}"
        )
    if check.locale == "id":
        return
    if value == source and key not in check.unchanged_terms:
        check.errors.append(
            f"{check.locale}:{key}: identical to Indonesian; translate it or document an intentional exception"
        )
    if key in check.unchanged_terms and value != source:
        check.errors.append(f"{check.locale}:{key}: stale unchanged-term exception (translation now differs)")


def _check_metadata_placeholders(
    check: _CatalogCheck, meta_key: str, meta: object, value: str
) -> None:
    """Check the Flutter placeholder annotations for one message."""
    if not isinstance(meta, dict):
        check.errors.append(f"{check.locale}:{meta_key}: metadata must be an object")
        return
    defined = meta.get("placeholders", {})
    if not isinstance(defined, dict):
        check.errors.append(f"{check.locale}:{meta_key}: placeholders metadata must be an object")
    elif set(defined) != set(tokens(value)):
        check.errors.append(
            f"{check.locale}:{meta_key}: metadata placeholders {sorted(defined)} "
            f"do not match message placeholders {sorted(tokens(value))}"
        )


def _check_message_metadata(check: _CatalogCheck, key: str, value: str) -> None:
    """Require the source annotations and check matching localized placeholders."""
    meta_key = "@" + key
    if meta_key in check.source and meta_key not in check.data:
        check.errors.append(f"{check.locale}:{key}: missing source metadata {meta_key}")
    if meta_key in check.data:
        _check_metadata_placeholders(check, meta_key, check.data[meta_key], value)
    elif tokens(value):
        check.errors.append(f"{check.locale}:{key}: add @{key} placeholder metadata for Flutter gen-l10n")


def _check_catalog_message(check: _CatalogCheck, key: str) -> None:
    """Validate a translated message and its associated metadata."""
    value = check.data[key]
    source = check.source[key]
    if not isinstance(value, str) or not value.strip():
        check.errors.append(f"{check.locale}:{key}: translation must be a nonempty string")
        return
    if not isinstance(source, str):
        check.errors.append(f"id:{key}: source must be a string")
        return
    _check_message_text(check, key, value, source)
    _check_message_metadata(check, key, value)


def _check_orphaned_metadata(check: _CatalogCheck, keys: set[str]) -> None:
    """Reject metadata entries without a corresponding message key."""
    for field in sorted(check.data):
        if not field.startswith("@") or field.startswith("@@"):
            continue
        if field[1:] not in keys:
            check.errors.append(f"{check.locale}: metadata {field} has no corresponding message")


def _check_one_catalog(check: _CatalogCheck, source_keys: set[str]) -> None:
    """Validate one catalog against the authoritative Indonesian source."""
    keys = message_keys(check.data)
    _check_catalog_keys(check, keys, source_keys)
    for key in sorted(source_keys & keys):
        _check_catalog_message(check, key)
    _check_orphaned_metadata(check, keys)


def _check_chinese_fallback(
    catalogs: dict[str, dict[str, object]], base_keys: set[str], errors: list[str]
) -> None:
    """Keep zh fallback and zh_Hans content synchronized."""
    for key in sorted(base_keys):
        if catalogs["zh"].get(key) != catalogs["zh_Hans"].get(key):
            errors.append(f"zh_Hans:{key}: differs from zh fallback; update both Chinese files")


def check_catalogs(
    root: Path, config: dict[str, object], errors: list[str]
) -> dict[str, dict[str, object]]:
    """Validate all configured catalogs against Indonesian messages and metadata."""
    catalogs = _load_catalogs(root, errors)
    if len(catalogs) != len(LOCALES):
        return catalogs
    base = catalogs["id"]
    base_keys = message_keys(base)
    allowed = _unchanged_terms(config, errors)
    for loc, data in catalogs.items():
        configured = allowed.get(loc, [])
        exceptions = set(configured) if isinstance(configured, list) else set()
        check = _CatalogCheck(
            locale=loc, data=data, source=base, unchanged_terms=exceptions, errors=errors
        )
        _check_one_catalog(check, base_keys)
    _check_chinese_fallback(catalogs, base_keys, errors)
    return catalogs


def decode_dart_literal(quoted: str) -> str:
    """Decodes a quoted Dart string for static text inspection.

    Args:
        quoted: One recognized quoted string literal.

    Returns:
        Decoded text, using a limited fallback for Dart-specific escapes
        when Python's literal parser cannot decode the expression.
    """
    try:
        value = ast.literal_eval(quoted)
        if isinstance(value, str):
            return value
    except (SyntaxError, ValueError):
        pass
    # Rare Dart-only escape spelling; keep literal backslashes and newlines stable.
    return quoted[1:-1].replace(r"\n", "\n").replace(r"\'", "'").replace(r'\"', '"')


def next_literal(text: str, start: int) -> tuple[str, int] | None:
    """Reads the next Dart quoted literal after optional whitespace.

    Args:
        text: Source text containing the literal.
        start: Index from which to begin scanning.

    Returns:
        Decoded literal and ending index, or None if none is found.
    """
    pos = start
    while pos < len(text) and text[pos].isspace():
        pos += 1
    match = DART_STRING.match(text, pos)
    if not match:
        return None
    return decode_dart_literal(match.group(0)), match.end()


def concatenated_literals(text: str, start: int) -> str | None:
    """Joins consecutive Dart string literals into one display label.

    Args:
        text: Text containing adjacent quoted literals.
        start: Index at which the first literal may occur.

    Returns:
        Concatenated text, or None when the input has no first literal.
    """
    fragments: list[str] = []
    pos = start
    while parsed := next_literal(text, pos):
        frag, pos = parsed
        fragments.append(frag)
    return "".join(fragments) if fragments else None


def get_exceptions(config: dict[str, object], errors: list[str]) -> dict[tuple[str, str, str], str]:
    """Validates configured source-literal exceptions.

    Args:
        config: Parsed exception configuration.
        errors: Mutable destination for malformed exception diagnostics.

    Returns:
        A mapping from (source file, kind, literal) to justification.
    """
    raw = config.get("source_exceptions", [])
    if not isinstance(raw, list):
        errors.append("exception file: source_exceptions must be a list")
        return {}
    entries: dict[tuple[str, str, str], str] = {}
    for item in raw:
        if not isinstance(item, dict):
            errors.append("exception file: source entry must be an object")
            continue
        path = item.get("path")
        kind = item.get("kind")
        value = item.get("value")
        reason = item.get("reason")
        if not all(isinstance(v, str) and v for v in [path, kind, value, reason]):
            errors.append(f"exception file: source entry needs path/kind/value/reason: {item!r}")
            continue
        key = (path, kind, value)
        if key in entries:
            errors.append(f"exception file: duplicate source exception {key}")
        entries[key] = reason
    return entries



def _check_presentation_entry(
    match: re.Match[str], mapping: dict[str, str], base: dict[str, object], errors: list[str]
) -> None:
    """Validate one generated lookup label and its Indonesian getter."""
    literal = "".join(
        decode_dart_literal(fragment.group(0))
        for fragment in re.finditer(LOOKUP_LITERAL, match.group(1))
    )
    getter = match.group(2)
    if literal in mapping:
        errors.append(f"presentation lookup: duplicated literal {literal!r}")
    mapping[literal] = getter
    if getter not in base:
        errors.append(f"presentation lookup: getter {getter} missing from Indonesian ARB")
    elif base[getter] != literal:
        errors.append(f"presentation lookup: {getter} no longer matches Indonesian message {literal!r}")


def _read_presentation_mapping(
    root: Path, catalogs: dict[str, dict[str, object]], errors: list[str]
) -> dict[str, str] | None:
    """Verify the generated lookup and return its display-label mapping."""
    lookup = root / "lib/i18n/generated/i18n_presentation_lookup.g.dart"
    try:
        lookup_text = lookup.read_text(encoding="utf-8")
    except OSError as exc:
        errors.append(f"{lookup}: {exc}")
        return None
    base = catalogs.get("id", {})
    mapping: dict[str, str] = {}
    for match in LOOKUP_ENTRY.finditer(lookup_text):
        _check_presentation_entry(match, mapping, base, errors)
    for getter in set(GETTER_REFERENCE.findall(lookup_text)):
        if getter not in base:
            errors.append(f"presentation lookup: referenced getter {getter} missing from Indonesian ARB")
    return mapping


def _translated_literals(text: str):
    """Yield fixed strings passed to the presentation translation helpers."""
    for match in I18N_CALL.finditer(text):
        pos = match.end()
        if match.group(0).startswith("translateDisplayText"):
            context = re.match(r"\s*context\s*,", text[pos:])
            if not context:
                continue
            pos += context.end()
        literal = concatenated_literals(text, pos)
        if literal is not None:
            yield "localized display", literal, match.start(), True


def _raw_text_literals(text: str):
    """Yield directly hardcoded Text widget strings."""
    for match in UNLOCALIZED_TEXT.finditer(text):
        literal = concatenated_literals(text, match.end())
        if literal is not None:
            yield "raw Text", literal, match.start(), False


def _attribute_literals(text: str):
    """Yield hardcoded accessibility, helper, and field-label attributes."""
    for match in ATTR_LITERAL.finditer(text):
        literal = concatenated_literals(text, match.end())
        if literal is not None:
            yield match.group(1), literal, match.start(), False


def _named_widget_literals(text: str, pattern: re.Pattern[str], field: str, kind: str):
    """Yield constant values for a named constructor argument."""
    for match in pattern.finditer(text):
        offset = re.match(r"\s*" + field + r"\s*:", text[match.end():])
        if not offset:
            continue
        literal = concatenated_literals(text, match.end() + offset.end())
        if literal is not None:
            yield kind, literal, match.start(), False


def _source_literals(text: str):
    """Yield statically checkable labels, preserving the original scan order."""
    yield from _translated_literals(text)
    yield from _raw_text_literals(text)
    yield from _attribute_literals(text)
    yield from _named_widget_literals(text, TOOLTIP, "message", "Tooltip.message")
    yield from _named_widget_literals(text, TEXT_SPAN, "text", "TextSpan.text")


def _verify_source_literal(
    occurrence: tuple[str, str, int, bool], relative: str, text: str, check: _SourceCheck
) -> None:
    """Report an uncovered string, recording only actually used exceptions."""
    kind, literal, char_pos, translated = occurrence
    if "$" in literal:  # Dynamic/interpolated display text needs human review.
        return
    if translated and literal in check.mapping:
        return
    key = (relative, kind, literal)
    if key in check.exceptions:
        check.used_exceptions.add(key)
        return
    line = text.count("\n", 0, char_pos) + 1
    hint = (
        "use a key registered in the generated presentation lookup"
        if translated else "use a localized string instead of raw display text"
    )
    check.errors.append(f"lib/{relative}:{line}: {kind} {literal!r}; {hint}")


def _scan_source_file(path: Path, relative: str, check: _SourceCheck) -> int:
    """Check one Dart source file and count the statically inspected strings."""
    text = path.read_text(encoding="utf-8")
    examined = 0
    for occurrence in _source_literals(text):
        examined += 1
        _verify_source_literal(occurrence, relative, text, check)
    return examined


def check_source(
    root: Path, catalogs: dict[str, dict[str, object]],
    config: dict[str, object], errors: list[str]
) -> tuple[int, int]:
    """Validate source display literals against the generated presentation lookup."""
    mapping = _read_presentation_mapping(root, catalogs, errors)
    if mapping is None:
        return 0, 0
    exceptions = get_exceptions(config, errors)
    check = _SourceCheck(mapping, exceptions, set(), errors)
    examined = 0
    source_dir = root / "lib"
    for path in sorted(source_dir.rglob("*.dart")):
        relative = path.relative_to(source_dir).as_posix()
        if relative.startswith("i18n/generated/"):
            continue
        examined += _scan_source_file(path, relative, check)
    for key in sorted(set(exceptions) - check.used_exceptions):
        errors.append(f"stale source exception {key}: remove it when fixed")
    return examined, len(check.used_exceptions)


def main() -> int:
    """Runs catalog and optional Dart-source localization checks.

    Returns:
        Zero for a passing audit, one for reported validation findings,
        or two when the exception configuration cannot be loaded.
    """
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--app", type=Path, default=APP_ROOT, help="Flutter app root (default: script parent)")
    parser.add_argument("--catalogs-only", action="store_true", help="Skip static source check")
    args = parser.parse_args()
    root = args.app.resolve()
    errors: list[str] = []
    exceptions = root / "tool/i18n_exceptions.json"
    try:
        config = load_json(exceptions)
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"[i18n] Cannot read {exceptions}: {exc}", file=sys.stderr)
        return 2
    catalogs = check_catalogs(root, config, errors)
    checked, legacy = (0, 0)
    if not args.catalogs_only and "id" in catalogs:
        checked, legacy = check_source(root, catalogs, config, errors)
    if errors:
        print(f"[i18n] FAIL: {len(errors)} finding(s):", file=sys.stderr)
        for error in errors[:80]:
            print(f"  - {error}", file=sys.stderr)
        if len(errors) > 80:
            print(f"  ... and {len(errors) - 80} more", file=sys.stderr)
        return 1
    count = len(message_keys(catalogs["id"])) if "id" in catalogs else 0
    print(f"[i18n] PASS: {count} Indonesian source keys synchronized across {', '.join(LOCALES)}")
    print("[i18n] Validated nonempty strings, duplicate keys, placeholder parity, metadata, Chinese fallback, copied Indonesian text")
    if not args.catalogs_only:
        print(f"[i18n] Verified {checked} statically checkable UI literals; {legacy} documented existing exceptions")
        print("[i18n] Dynamic strings and semantic translation quality still require Flutter tests and human review")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
