package sakebook.github.com.native_ads

import com.google.android.gms.ads.MobileAds
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class NativeAdsPlugin : MethodCallHandler {

    companion object {
        private lateinit var registrar: Registrar
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "native_ads")
            channel.setMethodCallHandler(NativeAdsPlugin())
            this.registrar = registrar
            registrar
                    .platformViewRegistry()
                    .registerViewFactory(
                            "com.github.sakebook.android/unified_ad_layout", UnifiedAdLayoutFactory(registrar.messenger()))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> {
                MobileAds.initialize(registrar.context())
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }
}
