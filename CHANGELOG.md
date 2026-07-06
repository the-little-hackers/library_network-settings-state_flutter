# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.3] - 2026-07-06
### Fixed
- Declare the `ACCESS_WIFI_STATE` permission, required by 
  `WifiManager.isWifiEnabled()`.

## [0.1.2] - 2026-07-06
### Fixed
- `android/build.gradle` failed to compile in consuming apps due to
  invalid statement ordering around the `plugins {}` block.

## [0.1.1] - 2026-07-06
### Fixed
- `android/build.gradle` used a legacy Kotlin version declaration that
  could conflict with a consuming app's own Kotlin/AGP resolution.
  Now uses the Plugin DSL and inherits the version from the host app.

## [0.1.0] - 2026-07-03
### Added
- `NetworkSettingsState.isWifiEnabled()`: reliable on Android and iOS 
  (iOS is best-effort via interface availability; see README).
- `NetworkSettingsState.isMobileDataEnabled()`: reliable on Android; 
 returns `null` on iOS (no public API exists).
- `NetworkSettingsState.getSnapshot()`: combined one-shot read.
- `NetworkSettingsState.onChanged`: stream of `NetworkSettingsSnapshot` 
  updates.
