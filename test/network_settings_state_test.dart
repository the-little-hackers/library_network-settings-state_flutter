import 'package:flutter_test/flutter_test.dart';
import 'package:network_settings_state/network_settings_state.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakeNetworkSettingsStatePlatform
    extends NetworkSettingsStatePlatform
    with MockPlatformInterfaceMixin {
  _FakeNetworkSettingsStatePlatform({
    required this.wifiEnabled,
    required this.mobileDataEnabled,
  });

  final bool wifiEnabled;
  final bool? mobileDataEnabled;

  @override
  Future<bool> isWifiEnabled() async => wifiEnabled;

  @override
  Future<bool?> isMobileDataEnabled() async => mobileDataEnabled;

  @override
  Future<NetworkSettingsSnapshot> getSnapshot() async {
    return NetworkSettingsSnapshot(
      wifiEnabled: wifiEnabled,
      mobileDataEnabled: mobileDataEnabled,
    );
  }

  @override
  Stream<NetworkSettingsSnapshot> get onChanged {
    return Stream.value(
      NetworkSettingsSnapshot(
        wifiEnabled: wifiEnabled,
        mobileDataEnabled: mobileDataEnabled,
      ),
    );
  }
}

void main() {
  group('NetworkSettingsState', () {
    test('reports Android-style resolved values', () async {
      NetworkSettingsStatePlatform.instance = _FakeNetworkSettingsStatePlatform(
        wifiEnabled: true,
        mobileDataEnabled: false,
      );

      expect(await NetworkSettingsState.isWifiEnabled(), isTrue);
      expect(await NetworkSettingsState.isMobileDataEnabled(), isFalse);

      final snapshot = await NetworkSettingsState.getSnapshot();
      expect(snapshot.wifiEnabled, isTrue);
      expect(snapshot.mobileDataEnabled, isFalse);
    });

    test('surfaces null mobileDataEnabled as unknown, not false', () async {
      NetworkSettingsStatePlatform.instance = _FakeNetworkSettingsStatePlatform(
        wifiEnabled: true,
        mobileDataEnabled: null,
      );

      final result = await NetworkSettingsState.isMobileDataEnabled();
      expect(result, isNull);
      expect(result, isNot(false));
    });

    test('onChanged emits snapshots', () async {
      NetworkSettingsStatePlatform.instance = _FakeNetworkSettingsStatePlatform(
        wifiEnabled: false,
        mobileDataEnabled: true,
      );

      final snapshot = await NetworkSettingsState.onChanged.first;
      expect(snapshot.wifiEnabled, isFalse);
      expect(snapshot.mobileDataEnabled, isTrue);
    });
  });

  group('NetworkSettingsSnapshot', () {
    test('equality is value-based', () {
      const a = NetworkSettingsSnapshot(wifiEnabled: true, mobileDataEnabled: false);
      const b = NetworkSettingsSnapshot(wifiEnabled: true, mobileDataEnabled: false);
      expect(a, equals(b));
    });

    test('fromMap / toMap round-trip', () {
      const snapshot = NetworkSettingsSnapshot(
        wifiEnabled: true,
        mobileDataEnabled: null,
      );

      final roundTripped = NetworkSettingsSnapshot.fromMap(snapshot.toMap());
      expect(roundTripped, equals(snapshot));
    });
  });
}
