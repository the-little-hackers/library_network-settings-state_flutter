/// A snapshot of the device's network radio settings state.
///
/// This reflects the state of the toggles in the device's system
/// settings, not which network is currently carrying traffic. See the
/// package README for the distinction and platform caveats.
class NetworkSettingsSnapshot {
  const NetworkSettingsSnapshot({
    required this.wifiEnabled,
    required this.mobileDataEnabled,
  });

  /// Whether the Wi-Fi radio is enabled in device settings.
  ///
  /// Reliable on Android. On iOS this is a best-effort approximation
  /// based on interface availability; see the package README.
  final bool wifiEnabled;

  /// Whether mobile data is enabled in device settings.
  ///
  /// Reliable on Android. Always `null` on iOS, since no public API
  /// exists to query this. Callers must handle `null` explicitly rather
  /// than assuming `false`.
  final bool? mobileDataEnabled;

  factory NetworkSettingsSnapshot.fromMap(Map<Object?, Object?> map) {
    return NetworkSettingsSnapshot(
      wifiEnabled: map['wifiEnabled'] as bool,
      mobileDataEnabled: map['mobileDataEnabled'] as bool?,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'wifiEnabled': wifiEnabled,
      'mobileDataEnabled': mobileDataEnabled,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is NetworkSettingsSnapshot &&
        other.wifiEnabled == wifiEnabled &&
        other.mobileDataEnabled == mobileDataEnabled;
  }

  @override
  int get hashCode => Object.hash(wifiEnabled, mobileDataEnabled);

  @override
  String toString() {
    return 'NetworkSettingsSnapshot(wifiEnabled: $wifiEnabled, '
        'mobileDataEnabled: $mobileDataEnabled)';
  }
}
