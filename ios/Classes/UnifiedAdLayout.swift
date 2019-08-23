//
//  UnifiedAdLayout.swift
//  native_ads
//
//  Created by ShinyaSakemoto on 2019/08/23.
//

import Foundation
import GoogleMobileAds

class UnifiedAdLayout : NSObject, FlutterPlatformView {
    
    private let channel: FlutterMethodChannel
    private let messeneger: FlutterBinaryMessenger
    private let frame: CGRect
    private let viewId: Int64
    private let args: [String: Any]
    private let adLoader: GADAdLoader
    
    private let placementId: String
    private let layoutName: String
    private let attributionViewId: String
    private let attributionText: String

    private weak var unifiedNativeAdView: GADUnifiedNativeAdView!
    private weak var headlineView: UILabel!
    private weak var bodyView: UILabel!
    private weak var callToActionView: UILabel!
    private weak var mediaView: GADMediaView!
    private weak var attributionView: UILabel!
    
    
    init(frame: CGRect, viewId: Int64, args: [String: Any], messeneger: FlutterBinaryMessenger) {
        self.args = args
        self.messeneger = messeneger
        self.frame = frame
        self.viewId = viewId
        self.placementId = self.args["placement_id"] as! String
        self.layoutName = self.args["layout_name"] as! String
        self.attributionViewId = self.args["view_id_attribution"] as! String
        self.attributionText = self.args["text_attribution"] as! String

        self.adLoader = GADAdLoader(adUnitID: placementId, rootViewController: nil,
                    adTypes: [ .unifiedNative ], options: nil)
        channel = FlutterMethodChannel(name: "com.github.sakebook.ios/unified_ad_layout_\(viewId)", binaryMessenger: messeneger)
    }
    
    private func fetchAd() {
        adLoader.delegate = self
        let request = GADRequest()
        request.testDevices = ["c1427b59788f3ef47a8e02b92bc4b41c"]
        adLoader.load(request)
    }
    
    func view() -> UIView {
        guard let nibObjects = Bundle.main.loadNibNamed(layoutName, owner: nil, options: nil),
            let adView = nibObjects.first as? GADUnifiedNativeAdView else {
                assert(false, "Could not load nib file for adView")
        }
        unifiedNativeAdView = adView
        headlineView = adView.headlineView as? UILabel
        bodyView = adView.bodyView as? UILabel
        callToActionView = adView.callToActionView as? UILabel
        mediaView = adView.mediaView
        attributionView = (adView as UIView).subviews.first(where: { (v) -> Bool in
            v.restorationIdentifier == attributionViewId
        }) as? UILabel

        fetchAd()
        return unifiedNativeAdView
    }
    
    fileprivate func dispose() {
        unifiedNativeAdView.nativeAd = nil
        channel.setMethodCallHandler(nil)
    }
}

extension UnifiedAdLayout : GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(#function) called")
        channel.invokeMethod("didFailToReceiveAdWithError", arguments: error)
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
        channel.invokeMethod("didReceive", arguments: nil)
        headlineView.text = nativeAd.headline
        bodyView.text = nativeAd.body
        callToActionView.text = nativeAd.callToAction
        mediaView?.mediaContent = nativeAd.mediaContent
        attributionView.text = attributionText
        unifiedNativeAdView.nativeAd = nativeAd
        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self
    }
}

// MARK: - GADUnifiedNativeAdDelegate implementation
extension UnifiedAdLayout : GADUnifiedNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
        channel.invokeMethod("nativeAdDidRecordClick", arguments: nil)
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
        channel.invokeMethod("nativeAdDidRecordImpression", arguments: nil)
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
        channel.invokeMethod("nativeAdWillPresentScreen", arguments: nil)
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
        channel.invokeMethod("nativeAdWillDismissScreen", arguments: nil)
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
        channel.invokeMethod("nativeAdDidDismissScreen", arguments: nil)
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
        channel.invokeMethod("nativeAdWillLeaveApplication", arguments: nil)
    }
}
