package sakebook.github.com.native_ads

import android.content.Context
import android.util.Log
import android.view.View
import android.view.ViewGroup
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

class UnifiedAdLayout(private val context: Context, messenger: BinaryMessenger, id: Int, arguments: HashMap<String, String>) : PlatformView {

    private val layoutRes = context.resources.getIdentifier(arguments["layout_name"], "layout", arguments["package_name"])
    private val unifiedNativeAdView: UnifiedNativeAdView = UnifiedNativeAdView(context)
    private val parentLayout: ViewGroup = View.inflate(context, layoutRes, null) as ViewGroup

    private lateinit var headlineView: TextView
    private lateinit var bodyView: TextView
    private lateinit var callToActionView: TextView
    private lateinit var mediaView: MediaView
    private lateinit var attributionView: TextView

    private val methodChannel: MethodChannel = MethodChannel(messenger, "com.github.sakebook/unified_ad_layout_$id")
    private var ad: UnifiedNativeAd? = null

    init {
        unifiedNativeAdView.addView(parentLayout)
        mappingView(arguments)
        AdLoader.Builder(context, arguments["placement_id"])
                .forUnifiedNativeAd {
                    ad = it
                    ensureUnifiedAd(it)
                }
                .withAdListener(object : AdListener() {
                    override fun onAdImpression() {
                        super.onAdImpression()
                        Log.d("UnifiedAdLayout", "ad onAdImpression")
                        methodChannel.invokeMethod("onAdImpression", null)
                    }

                    override fun onAdLeftApplication() {
                        super.onAdLeftApplication()
                        Log.d("UnifiedAdLayout", "ad onAdLeftApplication")
                        methodChannel.invokeMethod("onAdLeftApplication", null)
                    }

                    override fun onAdClicked() {
                        super.onAdClicked()
                        Log.d("UnifiedAdLayout", "ad onAdClicked")
                        methodChannel.invokeMethod("onAdClicked", null)
                    }

                    override fun onAdFailedToLoad(p0: Int) {
                        super.onAdFailedToLoad(p0)
                        Log.d("UnifiedAdLayout", "ad onAdFailedToLoad $p0")
                        methodChannel.invokeMethod("onAdFailedToLoad", p0)
                    }

                    override fun onAdClosed() {
                        super.onAdClosed()
                        Log.d("UnifiedAdLayout", "ad onAdClosed")
                        methodChannel.invokeMethod("onAdClosed", null)
                    }

                    override fun onAdOpened() {
                        super.onAdOpened()
                        Log.d("UnifiedAdLayout", "ad onAdOpened")
                        methodChannel.invokeMethod("onAdOpened", null)
                    }

                    override fun onAdLoaded() {
                        super.onAdLoaded()
                        Log.d("UnifiedAdLayout", "ad onAdLoaded")
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

    private fun mappingView(arguments: HashMap<String, String>) {
        val resource = context.resources
        val headlineId = resource.getIdentifier(arguments["view_id_headline"], "id", arguments["package_name"])
        val bodyId = resource.getIdentifier(arguments["view_id_body"], "id", arguments["package_name"])
        val callToActionId = resource.getIdentifier(arguments["view_id_call_to_action"], "id", arguments["package_name"])
        val mediaId = resource.getIdentifier(arguments["view_id_media"], "id", arguments["package_name"])
        val attributionId = resource.getIdentifier(arguments["view_id_attribution"], "id", arguments["package_name"])

        headlineView = parentLayout.findViewById(headlineId)
        bodyView = parentLayout.findViewById(bodyId)
        callToActionView = parentLayout.findViewById(callToActionId)
        mediaView = parentLayout.findViewById(mediaId)
        attributionView = parentLayout.findViewById(attributionId)

        attributionView.text = resource.getString(resource.getIdentifier(arguments["res_id_attribution"], "string", arguments["package_name"]))
    }
}