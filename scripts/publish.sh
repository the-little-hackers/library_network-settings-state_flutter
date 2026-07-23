#!/usr/bin/env bash
#
# Publishes this package to pub.dev:
#   1. Syncs pubspec.yaml's version into native build files.
#   2. Runs `flutter pub publish --dry-run` to validate.
#   3. If (and only if) the dry-run succeeds, asks for confirmation
#      and then runs the real `flutter pub publish`.
#
# Usage: run from anywhere; the script cd's to the package root.
#
#   ./scripts/publish.sh

set -euo pipefail

cd "$(dirname "$0")/.."

PUBSPEC_VERSION=$(grep -m1 '^version:' pubspec.yaml | sed 's/version:[[:space:]]*//')

if [[ -z "$PUBSPEC_VERSION" ]]; then
  echo "Could not read version from pubspec.yaml" >&2
  exit 1
fi

echo "=== Publishing network_settings_state ${PUBSPEC_VERSION} ==="
echo ""

# --- Step 1: sync version into native build files -------------------------
echo "--- Step 1/3: Syncing native versions ---"
./scripts/sync_version.sh
echo ""

# --- Step 2: dry run --------------------------------------------------------
echo "--- Step 2/3: Dry run (flutter pub publish --dry-run) ---"
if ! flutter pub publish --dry-run; then
  echo ""
  echo "Dry run failed. Fix the issues above before publishing." >&2
  exit 1
fi
echo ""

# --- Step 3: confirm and publish for real -----------------------------------
echo "--- Step 3/3: Publish ---"
echo "Dry run succeeded for version ${PUBSPEC_VERSION}."
echo "Publishing to pub.dev is PERMANENT: this version number can never be reused."
echo ""

# Reminder rather than a hard gate, since CHANGELOG format can't be
# reliably verified by script.
read -r -p "Have you added a CHANGELOG.md entry for ${PUBSPEC_VERSION}? [y/N] " changelog_ok
if [[ ! "$changelog_ok" =~ ^[Yy]$ ]]; then
  echo "Aborting. Add the CHANGELOG.md entry, then re-run this script." >&2
  exit 1
fi

read -r -p "Publish network_settings_state ${PUBSPEC_VERSION} to pub.dev now? [y/N] " publish_ok
if [[ ! "$publish_ok" =~ ^[Yy]$ ]]; then
  echo "Aborted. Nothing was published."
  exit 1
fi

flutter pub publish

echo ""
echo "Published network_settings_state ${PUBSPEC_VERSION}."