"""Regression tests for Quality's fail-closed change classifier."""

import subprocess
import unittest
from unittest.mock import patch

from classify_quality_changes import ALL, JOBS, classify_paths, decide


def selected(*paths: str) -> set[str]:
    """Return selected Quality jobs for a representative changed-file set."""
    return {job for job, enabled in classify_paths(list(paths)).items() if enabled}


class QualityClassifierTests(unittest.TestCase):
    """Guard trigger behavior and the required merge gate against regressions."""

    def test_only_markdown_skips_heavy_quality_jobs(self):
        self.assertEqual(selected("README.md", "app/lib/AGENTS.md"), set())

    def test_dart_implementation_runs_every_job(self):
        self.assertEqual(selected("app/lib/features/discovery/home_page.dart"), ALL)

    def test_flutter_tests_run_format_analyzer_and_coverage(self):
        self.assertEqual(
            selected("app/test/features/shopping/demo_cart_test.dart"),
            {"formatting", "analyzer", "tests"},
        )

    def test_integration_test_changes_are_not_ignored(self):
        self.assertEqual(
            selected("app/integration_test/launch_smoke_test.dart"),
            {"formatting", "analyzer", "tests"},
        )

    def test_android_native_or_asset_changes_run_affected_checks(self):
        self.assertEqual(
            selected("app/android/app/build.gradle.kts", "app/assets/logo.png"),
            {"analyzer", "tests"},
        )

    def test_arb_and_pubspec_changes_run_every_job(self):
        for path in ("app/lib/i18n/arb/app_en.arb", "app/pubspec.lock"):
            with self.subTest(path=path):
                self.assertEqual(selected(path), ALL)

    def test_analysis_and_localization_config_are_not_skipped(self):
        for path in ("app/analysis_options.yaml", "app/l10n.yaml"):
            with self.subTest(path=path):
                self.assertEqual(selected(path), ALL)

    def test_quality_workflow_or_classifier_changes_run_every_job(self):
        for path in (
            ".github/workflows/quality.yml",
            ".github/scripts/classify_quality_changes.py",
            ".github/scripts/test_classify_quality_changes.py",
        ):
            with self.subTest(path=path):
                self.assertEqual(selected(path), ALL)

    def test_font_fetch_changes_run_analyzer_and_tests(self):
        self.assertEqual(selected(".github/scripts/fetch_satoshi.py"), {"analyzer", "tests"})

    def test_python_tooling_uses_lightweight_syntax_and_i18n_checks(self):
        self.assertEqual(
            selected("app/tool/check_i18n.py", ".github/scripts/check_mojibake.py"),
            set(),
        )

    def test_unrelated_android_workflow_does_not_trigger_flutter_quality(self):
        self.assertEqual(selected(".github/workflows/android-build.yml"), set())

    def test_unknown_app_input_runs_every_job(self):
        self.assertEqual(selected("app/experimental/new-config.toml"), ALL)

    def test_unknown_or_invalid_paths_run_every_job(self):
        self.assertEqual(selected("../outside.txt"), ALL)
        self.assertEqual(selected("app\\lib\\main.dart"), ALL)
        self.assertEqual(selected(*[f"README-{i}.md" for i in range(301)]), ALL)

    def test_multiple_domains_use_union(self):
        self.assertEqual(
            selected("README.md", "app/test/example_test.dart", "app/android/build.gradle.kts"),
            {"formatting", "analyzer", "tests"},
        )

    def test_manual_event_runs_every_job(self):
        self.assertEqual(
            {job for job, enabled in decide("workflow_dispatch", "", "").items() if enabled},
            ALL,
        )

    @patch("classify_quality_changes.diff_paths", side_effect=subprocess.CalledProcessError(1, "git"))
    def test_diff_failure_runs_every_job(self, _):
        self.assertEqual(
            {job for job, enabled in decide("pull_request", "base", "head").items() if enabled},
            ALL,
        )

    def test_output_names_stay_stable(self):
        self.assertEqual(JOBS, ("formatting", "analyzer", "dcl", "complexity", "documentation", "tests"))


if __name__ == "__main__":
    unittest.main()
