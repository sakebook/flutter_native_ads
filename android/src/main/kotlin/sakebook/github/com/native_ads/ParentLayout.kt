package sakebook.github.com.native_ads

import android.content.Context
import android.view.View
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.TextView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class ParentLayout(private val context: Context, messenger: BinaryMessenger, id: Int) : PlatformView, MethodChannel.MethodCallHandler {

    private val parentView: LinearLayout
    private val methodChannel: MethodChannel

    init {
        parentView = LinearLayout(context).apply {
            this.orientation = LinearLayout.VERTICAL
        }
        methodChannel = MethodChannel(messenger, "com.github.sakebook/parent_view_$id")
        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View {
        return parentView
    }

    override fun dispose() {
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method) {
            "addView" -> parentView.addView(TextView(context).apply {
                this.text = "add view"
            })
        }
    }
}