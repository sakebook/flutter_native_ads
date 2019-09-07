import Flutter
import UIKit
import GoogleMobileAds

public class SwiftNativeAdsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native_ads", binaryMessenger: registrar.messenger())
    let instance = SwiftNativeAdsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.register(
        UnifiedAdLayoutFactory(messeneger: registrar.messenger()),
        withId: "com.github.sakebook.ios/unified_ad_layout"
    )
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        result(true)
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
