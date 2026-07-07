import Flutter
import Network
import UIKit

/// Reports whether the Wi-Fi radio appears enabled on iOS, and always
/// reports `nil` for mobile data since no public API exists to query
/// the global device setting.
///
/// The Wi-Fi reading is best-effort: it reflects whether a Wi-Fi
/// interface is currently available via `NWPathMonitor`, which is a
/// close but imperfect proxy for the Settings toggle. See the package
/// README for details.
public class NetworkSettingsStatePlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

    private let pathMonitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "org.thelittlehackers.network_settings_state.monitor")
    private var eventSink: FlutterEventSink?

    override init() {
        super.init()

        // Started unconditionally and kept running for the plugin's
        // entire lifetime. NWPathMonitor.currentPath only reflects
        // real state once start() has been called at least once --
        // previously this only happened when a stream listener
        // subscribed via onListen, so a one-shot isWifiEnabled() /
        // getSnapshot() call made before any stream subscription would
        // read an unstarted, unsatisfied path and incorrectly report
        // Wi-Fi as disabled even when it was enabled and connected.
        pathMonitor.start(queue: monitorQueue)
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = NetworkSettingsStatePlugin()

        let methodChannel = FlutterMethodChannel(
            name: "network_settings_state",
            binaryMessenger: registrar.messenger()
        )
        registrar.addMethodCallDelegate(instance, channel: methodChannel)

        let eventChannel = FlutterEventChannel(
            name: "network_settings_state_stream",
            binaryMessenger: registrar.messenger()
        )
        eventChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isWifiEnabled":
            result(isWifiEnabled())
        case "isMobileDataEnabled":
            // No public API exists on iOS to query the global mobile
            // data toggle. Returning nil rather than guessing.
            result(nil)
        case "getSnapshot":
            result(currentSnapshot())
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func isWifiEnabled() -> Bool {
        let path = pathMonitor.currentPath
        return path.availableInterfaces.contains { $0.type == .wifi }
    }

    private func currentSnapshot() -> [String: Any?] {
        return [
            "wifiEnabled": isWifiEnabled(),
            "mobileDataEnabled": nil,
        ]
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events

        // The monitor is already running (started in init); just hook
        // up the update handler to forward changes to the stream.
        pathMonitor.pathUpdateHandler = { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.eventSink?(self.currentSnapshot())
            }
        }

        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        // Deliberately does NOT call pathMonitor.cancel() -- the
        // monitor must keep running for the plugin's lifetime so that
        // one-shot method channel calls (isWifiEnabled, getSnapshot)
        // continue to work after a stream listener unsubscribes.
        pathMonitor.pathUpdateHandler = nil
        eventSink = nil
        return nil
    }
}
