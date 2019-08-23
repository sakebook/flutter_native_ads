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
        withId: "com.github.sakebook/unified_ad_layout"
    )
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    GADMobileAds.sharedInstance().start(completionHandler: nil)
  }
}
