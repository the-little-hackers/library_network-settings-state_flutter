package org.thelittlehackers.network_settings_state

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.wifi.WifiManager
import android.telephony.TelephonyManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * Reports whether the Wi-Fi and mobile data radios are enabled in the
 * device's system settings, independent of which network is currently
 * carrying traffic.
 */
class NetworkSettingsStatePlugin :
    FlutterPlugin,
    MethodCallHandler,
    EventChannel.StreamHandler {

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var applicationContext: Context

    private var wifiStateReceiver: BroadcastReceiver? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = binding.applicationContext

        methodChannel = MethodChannel(binding.binaryMessenger, "network_settings_state")
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(binding.binaryMessenger, "network_settings_state_stream")
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        unregisterWifiStateReceiver()
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "isWifiEnabled" -> result.success(isWifiEnabled())
            "isMobileDataEnabled" -> result.success(isMobileDataEnabled())
            "getSnapshot" -> result.success(currentSnapshot())
            else -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        registerWifiStateReceiver()
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        unregisterWifiStateReceiver()
    }

    private fun isWifiEnabled(): Boolean {
        val wifiManager = applicationContext
            .getSystemService(Context.WIFI_SERVICE) as? WifiManager
            ?: return true

        return wifiManager.isWifiEnabled
    }

    /**
     * Returns whether mobile data is enabled in device settings, or
     * `null` if this cannot be determined (no SecurityException
     * fallback beyond fail-open `true`, chosen deliberately: a missing
     * permission should not present as "mobile data disabled" to the
     * end user, since that is a distinct and misleading failure mode).
     */
    private fun isMobileDataEnabled(): Boolean {
        val telephonyManager = applicationContext
            .getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager
            ?: return true

        return try {
            telephonyManager.isDataEnabled
        } catch (securityException: SecurityException) {
            // READ_PHONE_STATE not granted on API < 29. Fail open rather
            // than reporting a false "disabled" state.
            true
        }
    }

    private fun currentSnapshot(): Map<String, Any?> {
        return mapOf(
            "wifiEnabled" to isWifiEnabled(),
            "mobileDataEnabled" to isMobileDataEnabled(),
        )
    }

    private fun registerWifiStateReceiver() {
        if (wifiStateReceiver != null) {
            return
        }

        val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                eventSink?.success(currentSnapshot())
            }
        }

        applicationContext.registerReceiver(
            receiver,
            IntentFilter(WifiManager.WIFI_STATE_CHANGED_ACTION),
        )

        wifiStateReceiver = receiver
    }

    private fun unregisterWifiStateReceiver() {
        wifiStateReceiver?.let {
            applicationContext.unregisterReceiver(it)
        }
        wifiStateReceiver = null
    }
}
