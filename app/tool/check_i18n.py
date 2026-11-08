#!/usr/bin/env python3
"""Validate PanganKita i18n catalogs and guarded display-source coverage.

Runs with Python's standard library, without Flutter or network access.
Indonesian is the authoritative message and placeholder catalog.
"""

from __future__ import annotations

import argparse
import ast
from collections import Counter
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
    result: dict[str, object] = {}
    for key, value in pairs:
        if key in result:
            raise DuplicateObjectKey(f"duplicate JSON field {key!r}")
        result[key] = value
    return result


def load_json(file: Path) -> dict[str, object]:
    data = json.loads(file.read_text(encoding="utf-8-sig"), object_pairs_hook=no_duplicate_keys)
    if not isinstance(data, dict):
        raise ValueError("expected a JSON object")
    return data


def message_keys(data: dict[str, object]) -> set[str]:
    return {key for key in data if not key.startswith("@")}


def tokens(message: str) -> Counter[str]:
    return Counter(PLACEHOLDER.findall(message) + ICU_VARIABLE.findall(message))


def check_catalogs(root: Path, config: dict[str, object], errors: list[str]) -> dict[str, dict[str, object]]:
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
    if len(catalogs) != len(LOCALES):
        return catalogs

    base = catalogs["id"]
    base_keys = message_keys(base)
    allowed = config.get("unchanged_from_id", {})
    if not isinstance(allowed, dict):
        errors.append("exception file: unchanged_from_id must be an object")
        allowed = {}

    for loc, data in catalogs.items():
        keys = message_keys(data)
        for key in sorted(base_keys - keys):
            errors.append(f"{loc}: missing Indonesian source key {key}")
        for key in sorted(keys - base_keys):
            errors.append(f"{loc}: unexpected key {key}, not in Indonesian catalog")
        exceptions = set(allowed.get(loc, [])) if isinstance(allowed.get(loc, []), list) else set()
        for key in sorted(exceptions - base_keys):
            errors.append(f"{loc}: outdated unchanged-term exception {key}")
        for key in sorted(base_keys & keys):
            value = data[key]
            id_value = base[key]
            if not isinstance(value, str) or not value.strip():
                errors.append(f"{loc}:{key}: translation must be a nonempty string")
                continue
            if not isinstance(id_value, str):
                errors.append(f"id:{key}: source must be a string")
                continue
            if tokens(value) != tokens(id_value):
                errors.append(
                    f"{loc}:{key}: placeholder mismatch: expected {dict(tokens(id_value))}, "
                    f"got {dict(tokens(value))}"
                )
            if loc != "id" and value == id_value and key not in exceptions:
                errors.append(
                    f"{loc}:{key}: identical to Indonesian; translate it or document an intentional exception"
                )
            if loc != "id" and key in exceptions and value != id_value:
                errors.append(f"{loc}:{key}: stale unchanged-term exception (translation now differs)")
            meta_key = "@" + key
            if meta_key in base and meta_key not in data:
                errors.append(f"{loc}:{key}: missing source metadata {meta_key}")
            if meta_key in data:
                meta = data[meta_key]
                if not isinstance(meta, dict):
                    errors.append(f"{loc}:{meta_key}: metadata must be an object")
                else:
                    defined = meta.get("placeholders", {})
                    if not isinstance(defined, dict):
                        errors.append(f"{loc}:{meta_key}: placeholders metadata must be an object")
                    elif set(defined) != set(tokens(value)):
                        errors.append(
                            f"{loc}:{meta_key}: metadata placeholders {sorted(defined)} "
                            f"do not match message placeholders {sorted(tokens(value))}"
                        )
            elif tokens(value):
                errors.append(f"{loc}:{key}: add @{key} placeholder metadata for Flutter gen-l10n")
        for field in sorted(data):
            if field.startswith("@") and not field.startswith("@@") and field[1:] not in keys:
                errors.append(f"{loc}: metadata {field} has no corresponding message")

    # Both Chinese catalogs currently carry the same Simplified Chinese strings.
    # Keeping them synchronized prevents fallback zh from becoming stale.
    for key in sorted(base_keys):
        if catalogs["zh"].get(key) != catalogs["zh_Hans"].get(key):
            errors.append(f"zh_Hans:{key}: differs from zh fallback; update both Chinese files")
    return catalogs


def decode_dart_literal(quoted: str) -> str:
    try:
        value = ast.literal_eval(quoted)
        if isinstance(value, str):
            return value
    except (SyntaxError, ValueError):
        pass
    # Rare Dart-only escape spelling; keep literal backslashes and newlines stable.
    return quoted[1:-1].replace(r"\n", "\n").replace(r"\'", "'").replace(r'\"', '"')


def next_literal(text: str, start: int) -> tuple[str, int] | None:
    pos = start
    while pos < len(text) and text[pos].isspace():
        pos += 1
    match = DART_STRING.match(text, pos)
    if not match:
        return None
    return decode_dart_literal(match.group(0)), match.end()


def concatenated_literals(text: str, start: int) -> str | None:
    fragments: list[str] = []
    pos = start
    while parsed := next_literal(text, pos):
        frag, pos = parsed
        fragments.append(frag)
    return "".join(fragments) if fragments else None


def get_exceptions(config: dict[str, object], errors: list[str]) -> dict[tuple[str, str, str], str]:
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


def check_source(root: Path, catalogs: dict[str, dict[str, object]], config: dict[str, object], errors: list[str]) -> tuple[int, int]:
    lookup = root / "lib/i18n/generated/i18n_presentation_lookup.g.dart"
    try:
        lookup_text = lookup.read_text(encoding="utf-8")
    except OSError as exc:
        errors.append(f"{lookup}: {exc}")
        return 0, 0
    base = catalogs.get("id", {})
    mapping: dict[str, str] = {}
    for match in LOOKUP_ENTRY.finditer(lookup_text):
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
    for getter in set(GETTER_REFERENCE.findall(lookup_text)):
        if getter not in base:
            errors.append(f"presentation lookup: referenced getter {getter} missing from Indonesian ARB")
    exceptions = get_exceptions(config, errors)
    used_exceptions: set[tuple[str, str, str]] = set()
    examined = 0
    source_dir = root / "lib"
    for path in sorted(source_dir.rglob("*.dart")):
        relative = path.relative_to(source_dir).as_posix()
        if relative.startswith("i18n/generated/"):
            continue
        text = path.read_text(encoding="utf-8")

        def verify(kind: str, literal: str, char_pos: int, *, translated: bool) -> None:
            nonlocal examined
            examined += 1
            if "$" in literal:  # dynamic/interpolated text needs a manual review
                return
            if translated and literal in mapping:
                return
            key = (relative, kind, literal)
            if key in exceptions:
                used_exceptions.add(key)
                return
            line = text.count("\n", 0, char_pos) + 1
            hint = (
                "use a key registered in the generated presentation lookup"
                if translated else "use a localized string instead of raw display text"
            )
            errors.append(f"lib/{relative}:{line}: {kind} {literal!r}; {hint}")

        for m in I18N_CALL.finditer(text):
            if m.group(0).startswith("translateDisplayText"):
                # Common form: translateDisplayText(context, 'literal')
                start = re.match(r"\s*context\s*,", text[m.end():])
                if not start:
                    continue
                pos = m.end() + start.end()
            else:
                pos = m.end()
            literal = concatenated_literals(text, pos)
            if literal is not None:
                verify("localized display", literal, m.start(), translated=True)
        for m in UNLOCALIZED_TEXT.finditer(text):
            literal = concatenated_literals(text, m.end())
            if literal is not None:
                verify("raw Text", literal, m.start(), translated=False)
        for m in ATTR_LITERAL.finditer(text):
            literal = concatenated_literals(text, m.end())
            if literal is not None:
                verify(m.group(1), literal, m.start(), translated=False)
        for m in TOOLTIP.finditer(text):
            offset = re.match(r"\s*message\s*:", text[m.end():])
            if offset:
                literal = concatenated_literals(text, m.end() + offset.end())
                if literal is not None:
                    verify("Tooltip.message", literal, m.start(), translated=False)
        for m in TEXT_SPAN.finditer(text):
            offset = re.match(r"\s*text\s*:", text[m.end():])
            if offset:
                literal = concatenated_literals(text, m.end() + offset.end())
                if literal is not None:
                    verify("TextSpan.text", literal, m.start(), translated=False)
    # Stale exemptions are important: contributors must remove whitelist debt on cleanup.
    for key in sorted(set(exceptions) - used_exceptions):
        errors.append(f"stale source exception {key}: remove it when fixed")
    return examined, len(used_exceptions)


def main() -> int:
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
