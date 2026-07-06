# Network Settings State

Query whether **Wi-Fi** and **mobile data** are enabled in the device's system settings — independent of which network is currently carrying traffic.

Published and maintained by [The Little Hackers](https://github.com/the-little-hackers), a nonprofit organization.

## Why this package exists

Packages like [`connectivity_plus`](https://pub.dev/packages/connectivity_plus) answer the question *"which network is active right now?"*.  They do **not** answer *"is this radio turned on in Settings?"* — and the two are easy to conflate.

On Android in particular, when both Wi-Fi and mobile data are enabled, the system reports **Wi-Fi only** as the active transport.  A naive check such as:

```dart
final result = await Connectivity().checkConnectivity();
if (!result.contains(ConnectivityResult.mobile)) {
  // "mobile data is disabled" -- WRONG. It may simply not be the active
  // transport right now.
}
```

produces a false positive: mobile data can be fully enabled and simply not in use because Wi-Fi is preferred.  `network_settings_state` answers the settings-state question directly, using platform-native APIs, so apps that need to validate device configuration (parental control apps, MDM-style tools, connectivity troubleshooting flows, etc.) don't have to infer it from transport state.

**Use `connectivity_plus` for reachability.  Use `network_settings_state` for settings state. Most apps need both.**

## Platform support

| Capability            | Android | iOS |
|------------------------|:-------:|:---:|
| Wi-Fi enabled           | ✅ Reliable | ⚠️ Best-effort (see below) |
| Mobile data enabled     | ✅ Reliable | ❌ Not available (returns `null`) |
| Change notifications    | ✅ Wi-Fi only | ⚠️ Best-effort |

### Android

- Wi-Fi: backed by `WifiManager.isWifiEnabled`.
- Mobile data: backed by `TelephonyManager.isDataEnabled`. On API level below 29 this requires the `READ_PHONE_STATE` permission; if the permission is not granted, the plugin fails open and returns `true` rather than blocking the user on an unrelated permission gap. Request `READ_PHONE_STATE` in your app if you need this to be reliable on older OS versions.

### iOS

Apple does not expose a public API for either of these settings.

- Wi-Fi: approximated via `NWPathMonitor`, checking whether a Wi-Fi interface is among the available interfaces.  This reflects **interface availability**, which is a close but not perfect proxy for the user-facing toggle in Settings — for example, it can briefly disagree with the toggle during state transitions. Treat it as best-effort.
- Mobile data: there is no usable proxy. `CTCellularData` only reports whether *this specific app* has cellular access, which is a different and narrower concept than the global device setting.  Rather than return a misleading value, this package always returns `null` on iOS for mobile data. **Design your UI to handle `null` explicitly** — do not assume `false` or `true`.

## Usage

```dart
import 'package:network_settings_state/network_settings_state.dart';

// One-shot reads
final bool wifiEnabled = await NetworkSettingsState.isWifiEnabled();
final bool? mobileDataEnabled = await NetworkSettingsState.isMobileDataEnabled();

if (mobileDataEnabled == null) {
  // Platform cannot report this (iOS). Don't treat as false.
} else if (!mobileDataEnabled) {
  // Confidently disabled.
}

// Combined snapshot
final NetworkSettingsSnapshot snapshot = await NetworkSettingsState.getSnapshot();

// Stream of changes (best-effort on iOS, Wi-Fi-only reliable on Android)
final subscription = NetworkSettingsState.onChanged.listen((snapshot) {
  print('Wi-Fi enabled: ${snapshot.wifiEnabled}');
  print('Mobile data enabled: ${snapshot.mobileDataEnabled}');
});
```

## What this package deliberately does not do

- It does not tell you whether the device has internet access.  Use `connectivity_plus` and/or your own reachability check for that.
- It does not guess at mobile data state on iOS via undocumented or per-app APIs. A `null` is more honest than a wrong guess.

## Contributing

Issues and pull requests are welcome at <https://github.com/the-little-hackers/network_settings_state>.

## License

MIT (©) 2026, The Little Hackers
