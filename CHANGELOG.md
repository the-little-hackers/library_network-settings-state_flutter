# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-07-03
### Added
- `NetworkSettingsState.isWifiEnabled()`: reliable on Android and iOS (iOS is best-effort via interface availability; see README).
- `NetworkSettingsState.isMobileDataEnabled()`: reliable on Android; returns `null` on iOS (no public API exists).
- `NetworkSettingsState.getSnapshot()`: combined one-shot read.
- `NetworkSettingsState.onChanged`: stream of `NetworkSettingsSnapshot` updates.
