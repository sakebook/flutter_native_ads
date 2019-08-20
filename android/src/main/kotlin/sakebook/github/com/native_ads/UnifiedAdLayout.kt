package sakebook.github.com.native_ads

import android.annotation.SuppressLint
import android.content.Context
import android.util.Log
import android.view.View
import android.widget.RelativeLayout
import android.widget.TextView
import android.widget.Toast
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

class UnifiedAdLayout(private val context: Context, messenger: BinaryMessenger, id: Int) : PlatformView, MethodChannel.MethodCallHandler {

    private val unifiedNativeAdView: UnifiedNativeAdView = UnifiedNativeAdView(context)
    private val methodChannel: MethodChannel = MethodChannel(messenger, "com.github.sakebook/unified_ad_layout_$id")

    init {
        methodChannel.setMethodCallHandler(this)

        AdLoader.Builder(context, "ca-app-pub-3940256099942544/2247696110")
                .forUnifiedNativeAd {
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
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            else -> TODO("必要であれば実装する")
        }
    }

    @SuppressLint("ResourceType")
    fun ensureUnifiedAd(ad: UnifiedNativeAd) {
        val layout = RelativeLayout(context)
        unifiedNativeAdView.addView(layout)

        val textView = TextView(context).apply {
            this.id = 100
            this.text = ad.body
        }
        layout.addView(textView)
        unifiedNativeAdView.bodyView = textView

        val mediaView = MediaView(context)
        val params = RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.WRAP_CONTENT)
        params.addRule(RelativeLayout.BELOW, 100)
        layout.addView(mediaView, params)
        mediaView.setMediaContent(ad.mediaContent)
        unifiedNativeAdView.mediaView = mediaView

        unifiedNativeAdView.setNativeAd(ad)
    }
}