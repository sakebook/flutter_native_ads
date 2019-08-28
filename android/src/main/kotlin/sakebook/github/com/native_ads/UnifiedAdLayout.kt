package sakebook.github.com.native_ads

import android.content.Context
import android.view.View
import android.widget.TextView
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdLoader
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.formats.MediaView
import com.google.android.gms.ads.formats.NativeAdOptions
import com.google.android.gms.ads.formats.UnifiedNativeAd
import com.google.android.gms.ads.formats.UnifiedNativeAdView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class UnifiedAdLayout(context: Context, messenger: BinaryMessenger, id: Int, arguments: HashMap<String, String>) : PlatformView {

    private val hostPackageName = arguments["package_name"]
    private val layoutRes = context.resources.getIdentifier(arguments["layout_name"], "layout", hostPackageName)
    private val unifiedNativeAdView: UnifiedNativeAdView = View.inflate(context, layoutRes, null) as UnifiedNativeAdView
    private val headlineView: TextView = unifiedNativeAdView.findViewById(context.resources.getIdentifier("flutter_native_ad_headline", "id", hostPackageName))
    private val bodyView: TextView = unifiedNativeAdView.findViewById(context.resources.getIdentifier("flutter_native_ad_body", "id", hostPackageName))
    private val callToActionView: TextView = unifiedNativeAdView.findViewById(context.resources.getIdentifier("flutter_native_ad_call_to_action", "id", hostPackageName))
    private val mediaView: MediaView = unifiedNativeAdView.findViewById(context.resources.getIdentifier("flutter_native_ad_media", "id", hostPackageName))

    private val methodChannel: MethodChannel = MethodChannel(messenger, "com.github.sakebook.android/unified_ad_layout_$id")
    private var ad: UnifiedNativeAd? = null

    init {
        unifiedNativeAdView.findViewById<TextView>(context.resources.getIdentifier("flutter_native_ad_attribution", "id", hostPackageName)).apply {
            this.text = arguments["text_attribution"]
        }
        AdLoader.Builder(context, arguments["placement_id"])
                .forUnifiedNativeAd {
                    ad = it
                    ensureUnifiedAd(it)
                }
                .withAdListener(object : AdListener() {
                    override fun onAdImpression() {
                        super.onAdImpression()
                        methodChannel.invokeMethod("onAdImpression", null)
                    }

                    override fun onAdLeftApplication() {
                        super.onAdLeftApplication()
                        methodChannel.invokeMethod("onAdLeftApplication", null)
                    }

                    override fun onAdClicked() {
                        super.onAdClicked()
                        methodChannel.invokeMethod("onAdClicked", null)
                    }

                    override fun onAdFailedToLoad(errorCode: Int) {
                        super.onAdFailedToLoad(errorCode)
                        methodChannel.invokeMethod("onAdFailedToLoad", errorCode)
                    }

                    override fun onAdLoaded() {
                        super.onAdLoaded()
                        methodChannel.invokeMethod("onAdLoaded", null)
                    }
                })
                .withNativeAdOptions(NativeAdOptions.Builder()
                        .build())
                .build()
                .loadAd(AdRequest.Builder()
                        .build())
    }

    override fun getView(): View {
        return unifiedNativeAdView
    }

    override fun dispose() {
        ad?.destroy()
        unifiedNativeAdView.removeAllViews()
        methodChannel.setMethodCallHandler(null)
    }

    private fun ensureUnifiedAd(ad: UnifiedNativeAd?) {
        headlineView.text = ad?.headline
        bodyView.text = ad?.body
        callToActionView.text = ad?.callToAction
        mediaView.setMediaContent(ad?.mediaContent)

        unifiedNativeAdView.bodyView = bodyView
        unifiedNativeAdView.headlineView = headlineView
        unifiedNativeAdView.callToActionView = callToActionView
        unifiedNativeAdView.mediaView = mediaView

        unifiedNativeAdView.setNativeAd(ad)
    }
}