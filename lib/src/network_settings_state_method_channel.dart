import 'package:flutter/services.dart';

import 'network_settings_snapshot.dart';
import 'network_settings_state_platform_interface.dart';

/// Default, method-channel-based implementation of
/// [NetworkSettingsStatePlatform].
class MethodChannelNetworkSettingsState extends NetworkSettingsStatePlatform {
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel(
    'network_settings_state',
  );

  @visibleForTesting
  final EventChannel eventChannel = const EventChannel(
    'network_settings_state_stream',
  );

  Stream<NetworkSettingsSnapshot>? _onChanged;

  @override
  Future<bool> isWifiEnabled() async {
    final bool? result = await methodChannel.invokeMethod<bool>(
      'isWifiEnabled',
    );
    return result ?? true;
  }

  @override
  Future<bool?> isMobileDataEnabled() {
    return methodChannel.invokeMethod<bool>('isMobileDataEnabled');
  }

  @override
  Future<NetworkSettingsSnapshot> getSnapshot() async {
    final Map<Object?, Object?>? result = await methodChannel
        .invokeMapMethod<Object?, Object?>('getSnapshot');

    if (result == null) {
      throw PlatformException(
        code: 'null_result',
        message: 'getSnapshot() returned no data from the platform side.',
      );
    }

    return NetworkSettingsSnapshot.fromMap(result);
  }

  @override
  Stream<NetworkSettingsSnapshot> get onChanged {
    return _onChanged ??= eventChannel
        .receiveBroadcastStream()
        .map((Object? event) {
          return NetworkSettingsSnapshot.fromMap(
            event as Map<Object?, Object?>,
          );
        });
  }
}
