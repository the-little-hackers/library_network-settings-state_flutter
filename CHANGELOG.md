## 0.1.0

Initial release.

- `NetworkSettingsState.isWifiEnabled()` — reliable on Android and iOS
  (iOS is best-effort via interface availability; see README).
- `NetworkSettingsState.isMobileDataEnabled()` — reliable on Android;
  returns `null` on iOS (no public API exists).
- `NetworkSettingsState.getSnapshot()` — combined one-shot read.
- `NetworkSettingsState.onChanged` — stream of `NetworkSettingsSnapshot`
  updates.
