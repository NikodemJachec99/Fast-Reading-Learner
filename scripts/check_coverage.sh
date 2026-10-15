#!/usr/bin/env bash
# Fails if line coverage in an lcov file is below a minimum percentage.
# Usage: scripts/check_coverage.sh [lcov-file] [min-percent]
set -euo pipefail

lcov_file="${1:-coverage/lcov.info}"
min_percent="${2:-70}"

if [[ ! -f "$lcov_file" ]]; then
  echo "Coverage file not found: $lcov_file (run 'flutter test --coverage' first)" >&2
  exit 1
fi

awk -F: -v min="$min_percent" '
  /^LF:/ { found += $2 }
  /^LH:/ { hit += $2 }
  END {
    if (found == 0) { print "No coverable lines found."; exit 0 }
    pct = 100 * hit / found
    printf "Line coverage: %.1f%% (%d/%d lines), minimum: %s%%\n", pct, hit, found, min
    if (pct < min) { print "Coverage is below the minimum." > "/dev/stderr"; exit 1 }
  }
' "$lcov_file"
