package sakebook.github.com.native_ads

import android.annotation.SuppressLint
import android.content.Context
import android.util.Log
import android.view.View
import android.widget.ImageView
import android.widget.RelativeLayout
import android.widget.TextView
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdLoader
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.formats.MediaView
import com.google.android.gms.ads.formats.NativeAdOptions
import com.google.android.gms.ads.formats.UnifiedNativeAd
import com.google.android.gms.ads.formats.UnifiedNativeAdView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.security.InvalidParameterException

class UnifiedAdLayout(private val context: Context, messenger: BinaryMessenger, id: Int) : PlatformView, MethodChannel.MethodCallHandler {

    private val unifiedNativeAdView: UnifiedNativeAdView = UnifiedNativeAdView(context)
    private val parentLayout: RelativeLayout = RelativeLayout(context)
    private val methodChannel: MethodChannel = MethodChannel(messenger, "com.github.sakebook/unified_ad_layout_$id")
    private var ad: UnifiedNativeAd? = null

    init {
        unifiedNativeAdView.addView(parentLayout)
        methodChannel.setMethodCallHandler(this)

        AdLoader.Builder(context, "ca-app-pub-3940256099942544/2247696110")
                .forUnifiedNativeAd {
                    ad = it
                    addBody(hashMapOf("rule" to "LayoutRules.alignParentTop", "view" to ""), LayoutViews.body.viewId())
                    addMedia(hashMapOf("rule" to "LayoutRules.below", "view" to "LayoutViews.body"), LayoutViews.media.viewId())

                    ensureUnifiedAd(it)
                }
                .withAdListener(object : AdListener() {
                    override fun onAdImpression() {
                        super.onAdImpression()
                        Log.d("UnifiedAdLayout", "ad onAdImpression")
                    }

                    override fun onAdLeftApplication() {
                        super.onAdLeftApplication()
                        Log.d("UnifiedAdLayout", "ad onAdLeftApplication")
                    }

                    override fun onAdClicked() {
                        super.onAdClicked()
                        Log.d("UnifiedAdLayout", "ad onAdClicked")
                    }

                    override fun onAdFailedToLoad(p0: Int) {
                        super.onAdFailedToLoad(p0)
                        Log.d("UnifiedAdLayout", "ad onAdFailedToLoad $p0")
                    }

                    override fun onAdClosed() {
                        super.onAdClosed()
                        Log.d("UnifiedAdLayout", "ad onAdClosed")
                    }

                    override fun onAdOpened() {
                        super.onAdOpened()
                        Log.d("UnifiedAdLayout", "ad onAdOpened")
                    }

                    override fun onAdLoaded() {
                        super.onAdLoaded()
                        Log.d("UnifiedAdLayout", "ad onAdLoaded")
                    }
                })
                .withNativeAdOptions(NativeAdOptions.Builder()
                        .build())
                .build()
                .loadAd(AdRequest.Builder().build())
    }

    override fun getView(): View {
        return unifiedNativeAdView
    }

    override fun dispose() {
        ad?.destroy()
        unifiedNativeAdView.removeAllViews()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "addHeadline" -> addHeadline(call.arguments as HashMap<String, String>, LayoutViews.headline.viewId())
            "addImage" -> addImage(call.arguments as HashMap<String, String>, LayoutViews.image.viewId())
            "addBody" -> addBody(call.arguments as HashMap<String, String>, LayoutViews.body.viewId())
            "addIcon" -> addIcon(call.arguments as HashMap<String, String>, LayoutViews.icon.viewId())
            "addCallToAction" -> addCallToAction(call.arguments as HashMap<String, String>, LayoutViews.callToAction.viewId())
            "addMedia" -> addMedia(call.arguments as HashMap<String, String>, LayoutViews.media.viewId())
            "setNativeAd" -> ensureUnifiedAd(ad)
            else -> TODO("必要であれば実装する")
        }
    }

    private fun addHeadline(arguments: HashMap<String, String>, viewId: ViewId) {
        val textView = TextView(context).apply {
            this.id = viewId
            this.text = ad?.headline
        }
        addView(textView, arguments)
        unifiedNativeAdView.headlineView = textView
    }

    private fun addImage(arguments: HashMap<String, String>, viewId: ViewId) {
        val imageView = ImageView(context).apply {
            this.id = viewId
            this.setImageDrawable(ad?.images?.get(0)?.drawable)
        }
        addView(imageView, arguments)
        unifiedNativeAdView.imageView = imageView
    }

    private fun addBody(arguments: HashMap<String, String>, viewId: ViewId) {
        val textView = TextView(context).apply {
            this.id = viewId
            this.text = ad?.body
        }
        addView(textView, arguments)
        unifiedNativeAdView.bodyView = textView
    }

    private fun addIcon(arguments: HashMap<String, String>, viewId: ViewId) {
        val imageView = ImageView(context).apply {
            this.id = viewId
            this.setImageDrawable(ad?.icon?.drawable)
        }
        addView(imageView, arguments)
        unifiedNativeAdView.iconView = imageView
    }

    private fun addCallToAction(arguments: HashMap<String, String>, viewId: ViewId) {
        val textView = TextView(context).apply {
            this.id = viewId
            this.text = ad?.callToAction
        }
        addView(textView, arguments)
        unifiedNativeAdView.callToActionView = textView
    }

    private fun addMedia(arguments: HashMap<String, String>, viewId: ViewId) {
        val mediaView = MediaView(context).apply {
            this.id = viewId
            this.setMediaContent(ad?.mediaContent)
        }
        addView(mediaView, arguments)
        unifiedNativeAdView.mediaView = mediaView
    }

    private fun addView(targetView: View, arguments: HashMap<String, String>) {
        val rule = arguments["rule"]
        val view = arguments["view"]
        Log.d("UnifiedAdLayout", "rule: $rule, view: $view")
        if (rule.isNullOrEmpty()) {
            throw InvalidParameterException()
        }
        val params = RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT)
        val layoutRules = LayoutRules.from(rule)
        val layoutViews = if (view.isNullOrBlank() || view == "null") { null } else LayoutViews.from(view)

        when (layoutRules) {
            LayoutRules.alignParentLeft -> params.addRule(RelativeLayout.ALIGN_PARENT_LEFT)
            LayoutRules.alignParentTop -> params.addRule(RelativeLayout.ALIGN_PARENT_TOP)
            LayoutRules.alignParentRight -> params.addRule(RelativeLayout.ALIGN_PARENT_RIGHT)
            LayoutRules.alignParentBottom -> params.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM)
            LayoutRules.above -> {
                layoutViews?.let { params.addRule(RelativeLayout.ABOVE, it.viewId()) }
            }
            LayoutRules.below -> {
                layoutViews?.let { params.addRule(RelativeLayout.BELOW, it.viewId()) }
            }
            LayoutRules.toLeftOf -> {
                layoutViews?.let { params.addRule(RelativeLayout.LEFT_OF, it.viewId()) }
            }
            LayoutRules.toRightOf -> {
                layoutViews?.let { params.addRule(RelativeLayout.RIGHT_OF, it.viewId()) }
            }
        }
        parentLayout.addView(targetView, params)
    }

    private fun ensureUnifiedAd(ad: UnifiedNativeAd?) {
        unifiedNativeAdView.setNativeAd(ad)
    }
}

typealias Rules = Int
typealias ViewId = Int
