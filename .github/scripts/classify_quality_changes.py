#!/usr/bin/env python3
"""Choose minimal safe Quality jobs from the exact Git commit diff.

An unknown input or Git failure selects every job. The always-on Quality gate
checks selected/skipped results separately and never accepts a classifier failure.
"""

from __future__ import annotations

import os
import re
import subprocess
from pathlib import PurePosixPath

JOBS = ("formatting", "analyzer", "dcl", "complexity", "documentation", "tests")
ALL = frozenset(JOBS)
RUNTIME = frozenset(("analyzer", "tests"))
DART_TEST = frozenset(("formatting", "analyzer", "tests"))
CONTROL = frozenset(
    (
        ".github/workflows/quality.yml",
        ".github/scripts/classify_quality_changes.py",
        ".github/scripts/test_classify_quality_changes.py",
    )
)
APP_CONFIG = frozenset(
    (
        "app/analysis_options.yaml",
        "app/pubspec.yaml",
        "app/pubspec.lock",
        "app/l10n.yaml",
    )
)
HEX_SHA = re.compile(r"[0-9a-fA-F]{40}\Z")


def classify_paths(paths: list[str]) -> dict[str, bool]:
    """Return the required job decisions for all changed paths.

    A source, dependency, or toolchain change affecting multiple checks takes
    the union of those checks. Unknown app inputs run all checks by default.
    """
    selected: set[str] = set()
    if len(paths) > 300:
        return {job: True for job in JOBS}

    for path in paths:
        if (
            not path
            or "\\" in path
            or path.startswith("/")
            or ".." in PurePosixPath(path).parts
        ):
            return {job: True for job in JOBS}

        if path in CONTROL or path in APP_CONFIG:
            selected.update(ALL)
        elif path.startswith("app/") and path.endswith(".md"):
            # Documentation is linted by Text Integrity and Links.
            continue
        elif path.startswith("app/lib/") and path.endswith(".dart"):
            selected.update(ALL)
        elif path.startswith("app/lib/i18n/arb/") and path.endswith(".arb"):
            selected.update(ALL)
        elif path.startswith("app/") and path.endswith(".dart"):
            selected.update(DART_TEST)
        elif path.startswith("app/android/") or path.startswith("app/assets/"):
            selected.update(RUNTIME)
        elif path == ".github/scripts/fetch_satoshi.py":
            selected.update(RUNTIME)
        elif path.startswith("app/tool/") and path.endswith((".py", ".json")):
            # Python syntax is checked in the classifier itself; the dedicated
            # i18n workflow validates checker behavior.
            continue
        elif path.startswith("app/"):
            # Future app inputs are not silently classified as documentation.
            selected.update(ALL)

    return {job: job in selected for job in JOBS}


def diff_paths(base: str, head: str) -> list[str]:
    """Return added, modified, renamed and deleted paths, without a file cap."""
    if (
        not HEX_SHA.fullmatch(base)
        or not HEX_SHA.fullmatch(head)
        or int(base, 16) == 0
        or int(head, 16) == 0
    ):
        raise ValueError("Git diff commits must be nonzero full-length SHAs")

    result = subprocess.run(
        ["git", "diff", "--no-renames", "--name-only", "-z", base, head, "--"],
        check=True,
        capture_output=True,
    )
    raw = result.stdout.decode("utf-8", errors="strict")
    return [path for path in raw.split("\0") if path]


def decide(event: str, base: str, head: str) -> dict[str, bool]:
    """Fail open for checks, not for merge approval, on uncertain diffs."""
    if event not in ("push", "pull_request"):
        print("Manual or unknown event: run every check")
        return {job: True for job in JOBS}

    try:
        paths = diff_paths(base, head)
        decisions = classify_paths(paths)
        print(f"Git diff contains {len(paths)} changed paths")
        for path in paths[:30]:
            print(f"  {path}")
        if len(paths) > 30:
            print("  ... remaining paths omitted from display")
        return decisions
    except (OSError, ValueError, UnicodeError, subprocess.CalledProcessError) as exc:
        print(f"::warning::Cannot classify Git changes ({exc}); run all checks")
        return {job: True for job in JOBS}


def main() -> None:
    """Write every required output exactly once for downstream job conditions."""
    event = os.environ.get("GITHUB_EVENT_NAME", "")
    base = (
        os.environ.get("PR_BASE_SHA", "")
        if event == "pull_request"
        else os.environ.get("PUSH_BEFORE_SHA", "")
    )
    head = os.environ.get("GITHUB_SHA", "")
    decisions = decide(event, base, head)
    output = os.environ["GITHUB_OUTPUT"]
    with open(output, "a", encoding="utf-8") as handle:
        for job in JOBS:
            value = "true" if decisions[job] else "false"
            print(f"{job}: {value}")
            handle.write(f"{job}={value}\n")


if __name__ == "__main__":
    main()
