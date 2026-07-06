import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'network_settings_state_method_channel.dart';
import 'network_settings_snapshot.dart';

/// The interface that implementations of network_settings_state must
/// implement.
///
/// Platform implementations should extend this class rather than
/// implement it, so that new methods added here do not break existing
/// implementations at compile time (per the `plugin_platform_interface`
/// convention).
abstract class NetworkSettingsStatePlatform extends PlatformInterface {
  NetworkSettingsStatePlatform() : super(token: _token);

  static final Object _token = Object();

  static NetworkSettingsStatePlatform _instance =
      MethodChannelNetworkSettingsState();

  /// The active platform implementation.
  static NetworkSettingsStatePlatform get instance => _instance;

  /// Platform-specific implementations (or tests) should set this with
  /// their own platform-specific class that extends
  /// [NetworkSettingsStatePlatform] when they register themselves.
  static set instance(NetworkSettingsStatePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> isWifiEnabled() {
    throw UnimplementedError('isWifiEnabled() has not been implemented.');
  }

  Future<bool?> isMobileDataEnabled() {
    throw UnimplementedError(
      'isMobileDataEnabled() has not been implemented.',
    );
  }

  Future<NetworkSettingsSnapshot> getSnapshot() {
    throw UnimplementedError('getSnapshot() has not been implemented.');
  }

  Stream<NetworkSettingsSnapshot> get onChanged {
    throw UnimplementedError('onChanged has not been implemented.');
  }
}
