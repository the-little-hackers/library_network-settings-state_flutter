#!/usr/bin/env bash
#
# Syncs the package version declared in pubspec.yaml into the native
# build files (android/build.gradle, ios/*.podspec), which Flutter/pub
# tooling does not do automatically. Those native version fields are
# cosmetic -- pub.dev and dependency resolution only look at
# pubspec.yaml -- but keeping them aligned avoids confusion for anyone
# reading the native build scripts directly.
#
# Usage: run from the package root after bumping pubspec.yaml's
# `version:` field.
#
#   ./tool/sync_version.sh

set -euo pipefail

cd "$(dirname "$0")/.."

PUBSPEC_VERSION=$(grep -m1 '^version:' pubspec.yaml | sed 's/version:[[:space:]]*//')

if [[ -z "$PUBSPEC_VERSION" ]]; then
  echo "Could not read version from pubspec.yaml" >&2
  exit 1
fi

echo "Syncing native files to version $PUBSPEC_VERSION ..."

# android/build.gradle: version '0.1.2'
sed -i.bak -E "s/^version '[^']*'/version '${PUBSPEC_VERSION}'/" android/build.gradle
rm -f android/build.gradle.bak

# ios/network_settings_state.podspec: s.version = '0.1.2'
sed -i.bak -E "s/(s\.version[[:space:]]*=[[:space:]]*)'[^']*'/\1'${PUBSPEC_VERSION}'/" ios/network_settings_state.podspec
rm -f ios/network_settings_state.podspec.bak

echo "Done. Updated:"
echo "  android/build.gradle -> version '${PUBSPEC_VERSION}'"
echo "  ios/network_settings_state.podspec -> s.version = '${PUBSPEC_VERSION}'"
echo ""
echo "Don't forget to also add a CHANGELOG.md entry before publishing."
