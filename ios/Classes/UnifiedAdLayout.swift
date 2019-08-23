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
    
    private weak var unifiedNativeAdView: GADUnifiedNativeAdView!
    private weak var headlineView: UILabel!
    private weak var bodyView: UILabel!
    private weak var callToActionView: UILabel!
    private weak var mediaView: GADMediaView!
    private weak var attributionView: UILabel!
    
    let adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: nil,
                               adTypes: [ .unifiedNative ], options: nil)

    init(frame: CGRect, viewId: Int64, args: [String: Any], messeneger: FlutterBinaryMessenger) {
        self.args = args
        self.messeneger = messeneger
        self.frame = frame
        self.viewId = viewId
        channel = FlutterMethodChannel(name: "com.github.sakebook/unified_ad_layout_\(viewId)", binaryMessenger: messeneger)
    }
    
    private func fetchAd() {
        adLoader.delegate = self
        let request = GADRequest()
        request.testDevices = ["c1427b59788f3ef47a8e02b92bc4b41c"]
        adLoader.load(request)
    }
    
    func view() -> UIView {
        guard let nibObjects = Bundle.main.loadNibNamed("UnifiedNativeAdView", owner: nil, options: nil),
            let adView = nibObjects.first as? GADUnifiedNativeAdView else {
                assert(false, "Could not load nib file for adView")
        }
        unifiedNativeAdView = adView
        headlineView = adView.headlineView as? UILabel
        bodyView = adView.bodyView as? UILabel
        callToActionView = adView.callToActionView as? UILabel
        mediaView = adView.mediaView

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
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
        headlineView.text = nativeAd.headline
        bodyView.text = nativeAd.body
        callToActionView.text = nativeAd.callToAction
        mediaView?.mediaContent = nativeAd.mediaContent
        unifiedNativeAdView.nativeAd = nativeAd
        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self
    }
}

// MARK: - GADUnifiedNativeAdDelegate implementation
extension UnifiedAdLayout : GADUnifiedNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
}
