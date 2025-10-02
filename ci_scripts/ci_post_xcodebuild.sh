#!/bin/sh
set -euo pipefail

# Only after a real archive, only on main, and not PR builds
[ -n "${CI_ARCHIVE_PATH:-}" ] || exit 0
[ "${CI_BRANCH:-}" = "main" ] || exit 0
[ -z "${CI_PULL_REQUEST_NUMBER:-}" ] || exit 0

ROOT="${CI_PRIMARY_REPOSITORY_PATH:-$(cd "$(dirname "$0")/.." && pwd)}"
NOTES_DIR="$ROOT/TestFlight"
mkdir -p "$NOTES_DIR"

SHORT="$(printf %.7s "${CI_COMMIT:-}")"
{
  echo "- Build ${SHORT} on branch ${CI_BRANCH:-main}"
  echo "- Workflow: ${CI_WORKFLOW:-}"
  echo "- Build number: ${CI_BUILD_NUMBER:-}"
} > "$NOTES_DIR/WhatToTest.en-US.txt"

echo "Wrote TestFlight/WhatToTest.en-US.txt"
sed -n '1,50p' "$NOTES_DIR/WhatToTest.en-US.txt"