#!/usr/bin/env bash
# Run inside android-emulator-runner while the emulator remains booted.
# Requires Flutter, adb, and an active emulator-5554 device.
# On failure, writes diagnostic artifacts to SMOKE_ARTIFACT_DIR or RUNNER_TEMP.
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
artifact_dir="${SMOKE_ARTIFACT_DIR:-${RUNNER_TEMP:-/tmp}/android-smoke}"
mkdir -p "$artifact_dir"

# Capture device state when the smoke test exits unsuccessfully.
# Leave the original test exit status unchanged.
capture_failure() {
  result=$?
  if [[ "$result" -ne 0 ]]; then
    echo "Android smoke failed (exit $result). Collecting emulator evidence..."
    adb devices -l > "$artifact_dir/devices.txt" 2>&1 || true
    adb logcat -d -v time -s flutter:E AndroidRuntime:E ActivityManager:E \
      > "$artifact_dir/startup-errors.txt" 2>&1 || true
    adb exec-out screencap -p > "$artifact_dir/failure-screen.png" 2>/dev/null || true
    if [[ ! -s "$artifact_dir/failure-screen.png" ]]; then
      rm -f "$artifact_dir/failure-screen.png"
    fi
  fi
}
trap capture_failure EXIT
cd "$repo_root/app"
flutter devices
flutter test integration_test/launch_smoke_test.dart -d emulator-5554 --reporter expanded
