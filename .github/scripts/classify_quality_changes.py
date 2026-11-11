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


# Patterns are ordered from specific source inputs to the conservative app/
# fallback. Separate from control-file overrides to make job selection auditable.
FILE_RULES = (
    (re.compile(r"app/lib/.*\.dart\Z"), ALL),
    (re.compile(r"app/lib/i18n/arb/.*\.arb\Z"), ALL),
    (re.compile(r"app/.*\.dart\Z"), DART_TEST),
    (re.compile(r"app/(?:android|assets)/.*\Z"), RUNTIME),
    (re.compile(r"app/tool/.*\.(?:py|json)\Z"), frozenset()),
    (re.compile(r"app/.*\.md\Z"), frozenset()),
    (re.compile(r"app/.*\Z"), ALL),
)
OVERRIDES = {path: ALL for path in CONTROL | APP_CONFIG}
OVERRIDES[".github/scripts/fetch_satoshi.py"] = RUNTIME


def _invalid_path(path: str) -> bool:
    """Reject ambiguous or traversal-like input instead of skipping checks."""
    if not path:
        return True
    if "\\" in path:
        return True
    if path.startswith("/"):
        return True
    return ".." in PurePosixPath(path).parts


def _jobs_for_path(path: str) -> frozenset[str]:
    """Map one repository path to the Quality jobs its changes can affect."""
    if path in OVERRIDES:
        return OVERRIDES[path]
    for pattern, jobs in FILE_RULES:
        if pattern.fullmatch(path):
            return jobs
    return frozenset()


def _valid_sha(sha: str) -> bool:
    """Accept a full nonzero commit SHA for Git diff comparison."""
    return bool(HEX_SHA.fullmatch(sha)) and int(sha, 16) != 0


def classify_paths(paths: list[str]) -> dict[str, bool]:
    """Union affected jobs; unknown or invalid input always runs all checks."""
    selected: set[str] = set()
    if len(paths) > 300:
        return {job: True for job in JOBS}

    for path in paths:
        if _invalid_path(path):
            return {job: True for job in JOBS}
        selected.update(_jobs_for_path(path))

    return {job: job in selected for job in JOBS}


def diff_paths(base: str, head: str) -> list[str]:
    """Return added, modified, renamed and deleted paths, without a file cap."""
    if not _valid_sha(base) or not _valid_sha(head):
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
