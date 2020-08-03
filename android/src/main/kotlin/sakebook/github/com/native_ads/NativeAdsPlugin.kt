package sakebook.github.com.native_ads

import com.google.android.gms.ads.MobileAds
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class NativeAdsPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {

    // for future use
    private var channel: MethodChannel? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "native_ads")
        channel?.setMethodCallHandler(this)
        binding.platformViewRegistry
                .registerViewFactory("com.github.sakebook.android/unified_ad_layout",
                        UnifiedAdLayoutFactory(binding.binaryMessenger))
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        MobileAds.initialize(binding.activity)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> {
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromActivity() {
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }
}