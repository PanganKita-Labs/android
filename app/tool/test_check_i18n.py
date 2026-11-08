"""Mutation tests for the offline i18n consistency gate."""

from __future__ import annotations

import contextlib
import io
import json
import re
import shutil
import tempfile
import unittest
from pathlib import Path

import check_i18n


class I18nCheckerTests(unittest.TestCase):
    """Prove the checker rejects common translation-contribution defects."""

    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory(prefix="pangankita-i18n-check-")
        self.root = Path(self.temp.name)
        shutil.copytree(check_i18n.APP_ROOT / "lib", self.root / "lib")
        shutil.copytree(check_i18n.APP_ROOT / "tool", self.root / "tool", ignore=shutil.ignore_patterns("__pycache__"))
        self.config = check_i18n.load_json(self.root / "tool/i18n_exceptions.json")

    def tearDown(self) -> None:
        self.temp.cleanup()

    def check(self) -> list[str]:
        errors: list[str] = []
        catalogs = check_i18n.check_catalogs(self.root, self.config, errors)
        if "id" in catalogs:
            check_i18n.check_source(self.root, catalogs, self.config, errors)
        return errors

    def mutate(self, locale: str, update) -> None:
        path = self.root / f"lib/i18n/arb/app_{locale}.arb"
        data = json.loads(path.read_text(encoding="utf-8"))
        update(data)
        path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    def test_clean_baseline(self) -> None:
        self.assertEqual([], self.check())

    def test_lookup_entry_line_wrapping(self) -> None:
        path = self.root / "lib/i18n/generated/i18n_presentation_lookup.g.dart"
        text = path.read_text(encoding="utf-8")
        old = '"Contoh pesanan tidak tersedia." => strings.uiExampleOrderUnavailable,'
        self.assertIn(old, text)
        path.write_text(
            text.replace(old, '"Contoh pesanan tidak tersedia." =>\n      strings.uiExampleOrderUnavailable,', 1),
            encoding="utf-8",
        )
        self.assertEqual([], self.check())

    def test_formatter_splits_long_lookup_labels(self) -> None:
        """Long strings still match when Dart format splits their literal tokens."""
        path = self.root / "lib/i18n/generated/i18n_presentation_lookup.g.dart"
        text = path.read_text(encoding="utf-8")
        base = check_i18n.load_json(self.root / "lib/i18n/arb/app_id.arb")

        # Parse the lookup rather than assuming the initial file is unformatted.
        # Real dart format often wraps both literals and their getter expressions.
        replacements: list[tuple[int, int, str]] = []
        for match in check_i18n.LOOKUP_ENTRY.finditer(text):
            label = "".join(
                check_i18n.decode_dart_literal(fragment.group(0))
                for fragment in re.finditer(check_i18n.LOOKUP_LITERAL, match.group(1))
            )
            getter = match.group(2)
            if len(label) <= 80 or " " not in label or base.get(getter) != label:
                continue
            split_at = label.rfind(" ", 0, len(label) // 2)
            if split_at <= 0:
                continue
            left = json.dumps(label[: split_at + 1], ensure_ascii=False)
            right = json.dumps(label[split_at + 1 :], ensure_ascii=False)
            replacements.append(
                (
                    match.start(),
                    match.end(),
                    f"{left}\n        {right} =>\n          strings.{getter},",
                )
            )
            if len(replacements) == 7:
                break
        self.assertTrue(replacements, "no long lookup labels available for wrapping test")
        for start, end, replacement in reversed(replacements):
            text = text[:start] + replacement + text[end:]
        path.write_text(text, encoding="utf-8")
        self.assertEqual([], self.check())

    def test_wrapped_lookup_still_detects_unknown_getter(self) -> None:
        """Line wrapping must not silently hide invalid ARB references."""
        path = self.root / "lib/i18n/generated/i18n_presentation_lookup.g.dart"
        text = path.read_text(encoding="utf-8")
        old = '"Contoh pesanan tidak tersedia." => strings.uiExampleOrderUnavailable,'
        wrapped = (
            '"Contoh pesanan "\n'
            '        "tidak tersedia." =>\n'
            '          strings.uiMissingTranslationForTest,'
        )
        self.assertIn(old, text)
        path.write_text(text.replace(old, wrapped, 1), encoding="utf-8")
        self.assertTrue(
            any("uiMissingTranslationForTest" in error for error in self.check())
        )

    def test_missing_translation_key(self) -> None:
        self.mutate("en", lambda d: d.pop("navHome"))
        self.assertTrue(any("en: missing Indonesian source key navHome" in e for e in self.check()))

    def test_untranslated_copy_of_indonesian(self) -> None:
        self.mutate("en", lambda d: d.__setitem__("navHome", "Beranda"))
        self.assertTrue(any("en:navHome: identical" in e for e in self.check()))

    def test_mismatched_placeholder(self) -> None:
        self.mutate("en", lambda d: d.__setitem__("uiDigitValue", "Digit {count}"))
        self.assertTrue(any("en:uiDigitValue: placeholder mismatch" in e for e in self.check()))

    def test_duplicate_json_key(self) -> None:
        path = self.root / "lib/i18n/arb/app_en.arb"
        content = path.read_text(encoding="utf-8")
        path.write_text(content.replace('"navHome": "Home",', '"navHome": "Home",\n  "navHome": "HOME",', 1), encoding="utf-8")
        self.assertTrue(any("duplicate JSON field 'navHome'" in e for e in self.check()))

    def test_chinese_script_fallback_divergence(self) -> None:
        self.mutate("zh_Hans", lambda d: d.__setitem__("navHome", "测试"))
        self.assertTrue(any("zh_Hans:navHome: differs from zh fallback" in e for e in self.check()))

    def test_new_unlocalized_text_widget(self) -> None:
        path = self.root / "lib/features/profile/settings_page.dart"
        path.write_text(path.read_text(encoding="utf-8") + "\n// Example\nWidget bad() => Text('Hello from new source');\n", encoding="utf-8")
        self.assertTrue(any("raw Text 'Hello from new source'" in e for e in self.check()))

    def test_new_unmapped_i18n_text(self) -> None:
        path = self.root / "lib/features/profile/settings_page.dart"
        path.write_text(path.read_text(encoding="utf-8") + "\nWidget bad() => I18nText('Belum masuk katalog');\n", encoding="utf-8")
        self.assertTrue(any("Belum masuk katalog" in e and "localized display" in e for e in self.check()))

    def test_missing_source_exception_fails(self) -> None:
        self.config["source_exceptions"] = self.config["source_exceptions"][1:]
        self.assertTrue(any("Mandala by Pass" in e for e in self.check()))


if __name__ == "__main__":
    unittest.main()
