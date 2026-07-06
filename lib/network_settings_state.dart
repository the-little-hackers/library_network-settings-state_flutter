library network_settings_state;

import 'src/network_settings_snapshot.dart';
import 'src/network_settings_state_platform_interface.dart';

export 'src/network_settings_snapshot.dart';
export 'src/network_settings_state_platform_interface.dart'
    show NetworkSettingsStatePlatform;

/// Query whether Wi-Fi and mobile data are enabled in the device's
/// system settings, independent of which network is currently carrying
/// traffic.
///
/// See the package README for the distinction between this and
/// reachability-focused packages like `connectivity_plus`, and for
/// platform-specific caveats (especially on iOS, where mobile data
/// state cannot be reported and `null` is returned instead of a guess).
abstract final class NetworkSettingsState {
  /// Whether the Wi-Fi radio is enabled in device settings.
  ///
  /// Reliable on Android. On iOS this is a best-effort approximation;
  /// see the package README.
  static Future<bool> isWifiEnabled() {
    return NetworkSettingsStatePlatform.instance.isWifiEnabled();
  }

  /// Whether mobile data is enabled in device settings.
  ///
  /// Reliable on Android. Always `null` on iOS — no public API exists
  /// to query this. Do not treat `null` as `false`.
  static Future<bool?> isMobileDataEnabled() {
    return NetworkSettingsStatePlatform.instance.isMobileDataEnabled();
  }

  /// Reads both [isWifiEnabled] and [isMobileDataEnabled] in a single
  /// platform call.
  static Future<NetworkSettingsSnapshot> getSnapshot() {
    return NetworkSettingsStatePlatform.instance.getSnapshot();
  }

  /// A stream of [NetworkSettingsSnapshot] updates as radio settings
  /// change.
  ///
  /// Reliable for Wi-Fi changes on Android. Best-effort elsewhere; see
  /// the package README.
  static Stream<NetworkSettingsSnapshot> get onChanged {
    return NetworkSettingsStatePlatform.instance.onChanged;
  }
}
