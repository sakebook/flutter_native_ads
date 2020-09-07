package sakebook.github.com.native_ads

import android.content.Context
import android.content.res.ColorStateList
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdLoader
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.RequestConfiguration
import com.google.android.gms.ads.formats.MediaView
import com.google.android.gms.ads.formats.NativeAdOptions
import com.google.android.gms.ads.formats.UnifiedNativeAd
import com.google.android.gms.ads.formats.UnifiedNativeAdView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import android.graphics.Color
import android.view.ViewGroup

class UnifiedAdLayout(
        context: Context,
        messenger: BinaryMessenger,
        id: Int,
        arguments: HashMap<String, Any>
) : PlatformView {

    private val hostPackageName = arguments["package_name"] as String
    private val layoutRes = context.resources.getIdentifier(arguments["layout_name"] as String, "layout", hostPackageName)
    private val unifiedNativeAdView: UnifiedNativeAdView = View.inflate(context, layoutRes, null) as UnifiedNativeAdView
    private val rootLayout: ViewGroup = unifiedNativeAdView.findViewById(context.resources.getIdentifier("rootLayout", "id", hostPackageName))
    private val headlineView: TextView = unifiedNativeAdView.findViewById(context.resources.getIdentifier("flutter_native_ad_headline", "id", hostPackageName))
    private val bodyView: TextView = unifiedNativeAdView.findViewById(context.resources.getIdentifier("flutter_native_ad_body", "id", hostPackageName))
    private val callToActionView: TextView = unifiedNativeAdView.findViewById(context.resources.getIdentifier("flutter_native_ad_call_to_action", "id", hostPackageName))

    private val mediaView: MediaView? = unifiedNativeAdView.findViewById(context.resources.getIdentifier("flutter_native_ad_media", "id", hostPackageName))
    private val iconView: ImageView? = unifiedNativeAdView.findViewById(context.resources.getIdentifier("flutter_native_ad_icon", "id", hostPackageName))
    private val starRatingView: TextView? = unifiedNativeAdView.findViewById(context.resources.getIdentifier("flutter_native_ad_star", "id", hostPackageName))
    private val storeView: TextView? = unifiedNativeAdView.findViewById(context.resources.getIdentifier("flutter_native_ad_store", "id", hostPackageName))
    private val priceView: TextView? = unifiedNativeAdView.findViewById(context.resources.getIdentifier("flutter_native_ad_price", "id", hostPackageName))
    private val advertiserView: TextView? = unifiedNativeAdView.findViewById(context.resources.getIdentifier("flutter_native_ad_advertiser", "id", hostPackageName))

    private val methodChannel: MethodChannel = MethodChannel(messenger, "com.github.sakebook.android/unified_ad_layout_$id")
    private var ad: UnifiedNativeAd? = null

    init {

        (arguments["headline_font_size"] as Double?)?.toFloat()?.let(headlineView::setTextSize)
        (arguments["headline_font_color"] as String?)?.let(Color::parseColor)?.let(headlineView::setTextColor)

        (arguments["body_font_size"] as Double?)?.toFloat()?.let(bodyView::setTextSize)
        (arguments["body_font_color"] as String?)?.let(Color::parseColor)?.let(bodyView::setTextColor)

        (arguments["call_to_action_font_size"] as Double?)?.toFloat()?.let(callToActionView::setTextSize)
        (arguments["call_to_action_font_color"] as String?)?.let(Color::parseColor)?.let(callToActionView::setTextColor)
        (arguments["dark"] as Boolean?)?.let { dark ->
            val identifier = context.resources.getIdentifier(
                    when (dark) {
                        true -> "bg_action_button_dark"
                        else -> "bg_action_button_light"
                    },
                    "drawable",
                    hostPackageName
            )
            callToActionView.setBackgroundResource(identifier)
        }

        val ids = arguments["test_devices"] as MutableList<String>?
        val configuration = RequestConfiguration.Builder().setTestDeviceIds(ids).build()
        MobileAds.setRequestConfiguration(configuration)

        AdLoader.Builder(context, arguments["placement_id"] as String)
                .forUnifiedNativeAd {
                    ad = it

                    ensureUnifiedAd(it)

                    (arguments["background_color"] as String?)?.let(Color::parseColor)?.let { backgroundColor ->
                        unifiedNativeAdView?.setBackgroundColor(backgroundColor)
                    }
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

                    override fun onAdFailedToLoad(error: LoadAdError) {
                        super.onAdFailedToLoad(error)
                        methodChannel.invokeMethod("onAdFailedToLoad", hashMapOf("errorCode" to error.code))
                    }

                    override fun onAdFailedToLoad(errorCode: Int) {
                        super.onAdFailedToLoad(errorCode)
                        // TODO: Migrate deprecated method.
                        methodChannel.invokeMethod("onAdFailedToLoad", hashMapOf("errorCode" to errorCode))
                    }

                    override fun onAdLoaded() {
                        super.onAdLoaded()

                        rootLayout.visibility = View.VISIBLE

                        unifiedNativeAdView.findViewById<TextView>(context.resources.getIdentifier("flutter_native_ad_attribution", "id", hostPackageName))
                                .let { attributionView ->
                                    (arguments["text_attribution"] as String?)?.let { attributionView.setText(it) }
                                    (arguments["attribution_view_font_size"] as Double?)?.toFloat()?.let { attributionView?.setTextSize(it) }
                                    (arguments["attribution_view_font_color"] as String?)?.let(Color::parseColor)?.let { attributionView?.setTextColor(it) }
                                }

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

        mediaView?.setMediaContent(ad?.mediaContent)
        iconView?.setImageDrawable(ad?.mediaContent?.mainImage ?: ad?.images?.firstOrNull()?.drawable ?:  ad?.icon?.drawable)
        starRatingView?.text = "${ad?.starRating}"
        storeView?.text = ad?.store
        priceView?.text = ad?.price
        advertiserView?.text = ad?.advertiser

        unifiedNativeAdView.bodyView = bodyView
        unifiedNativeAdView.headlineView = headlineView
        unifiedNativeAdView.callToActionView = callToActionView

        unifiedNativeAdView.mediaView = mediaView
        unifiedNativeAdView.iconView = iconView
        unifiedNativeAdView.starRatingView = starRatingView
        unifiedNativeAdView.storeView = storeView
        unifiedNativeAdView.priceView = priceView
        unifiedNativeAdView.advertiserView = advertiserView

        unifiedNativeAdView.setNativeAd(ad)
    }
}
