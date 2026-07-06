# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2026-07-036
### Fixed
- `android/build.gradle` used a legacy `buildscript`/`apply plugin`
  pattern with a hardcoded Kotlin version, which conflicted with the
  Kotlin/AGP version resolution declared in a consuming app's
  `settings.gradle.kts` (Plugin DSL), causing a Gradle artifact
  resolution failure (`Could not find com.jetbrains.kotlin:kotlin-gradle-plugin`)
  during `flutter build apk` in some host apps. The plugin's Android
  build script now uses the Plugin DSL without a pinned Kotlin version,
  inheriting it from the consuming app instead.

## [0.1.0] - 2026-07-03
### Added
- `NetworkSettingsState.isWifiEnabled()`: reliable on Android and iOS 
  (iOS is best-effort via interface availability; see README).
- `NetworkSettingsState.isMobileDataEnabled()`: reliable on Android; 
 returns `null` on iOS (no public API exists).
- `NetworkSettingsState.getSnapshot()`: combined one-shot read.
- `NetworkSettingsState.onChanged`: stream of `NetworkSettingsSnapshot` 
  updates.
