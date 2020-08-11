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
    private let attributionText: String

    private let unifiedNativeAdView: GADUnifiedNativeAdView!
    
    private weak var headlineView: UILabel!
    private weak var bodyView: UILabel!
    private weak var callToActionView: UILabel!
    private weak var attributionView: UILabel!

    private weak var mediaView: GADMediaView?
    private weak var iconView: UIImageView?
    private weak var starRatingView: UILabel?
    private weak var storeView: UILabel?
    private weak var priceView: UILabel?
    private weak var advertiserView: UILabel?
    
    init(frame: CGRect, viewId: Int64, args: [String: Any], messeneger: FlutterBinaryMessenger) {
        self.args = args
        self.messeneger = messeneger
        self.frame = frame
        self.viewId = viewId
        self.placementId = self.args["placement_id"] as! String
        self.layoutName = self.args["layout_name"] as! String
        self.attributionText = self.args["text_attribution"] as! String

        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = self.args["test_devices"] as? [String]

        self.adLoader = GADAdLoader(adUnitID: placementId, rootViewController: nil,
                    adTypes: [ .unifiedNative ], options: nil)
        channel = FlutterMethodChannel(name: "com.github.sakebook.ios/unified_ad_layout_\(viewId)", binaryMessenger: messeneger)
        
        guard let nibObjects = Bundle.main.loadNibNamed(layoutName, owner: nil, options: nil),
              let adView = nibObjects.first as? GADUnifiedNativeAdView else {
            fatalError("Could not load nib file for adView")
        }
        unifiedNativeAdView = adView
        super.init()
        mappingView()
        fetchAd()
    }

    private func mappingView() {
        headlineView = unifiedNativeAdView.headlineView as? UILabel
        bodyView = unifiedNativeAdView.bodyView as? UILabel
        callToActionView = unifiedNativeAdView.callToActionView as? UILabel
        mediaView = unifiedNativeAdView.mediaView
        guard let attributionLabel = (unifiedNativeAdView as UIView).subviews.first(where: { (v) -> Bool in
            v.restorationIdentifier == "flutter_native_ad_attribution_view_id"
        }) as? UILabel else {
            fatalError("Could not find Restoration ID 'flutter_native_ad_attribution_view_id'")
        }
        attributionView = attributionLabel

        iconView = unifiedNativeAdView.iconView as? UIImageView
        starRatingView = unifiedNativeAdView.starRatingView as? UILabel
        storeView = unifiedNativeAdView.storeView as? UILabel
        priceView = unifiedNativeAdView.priceView as? UILabel
        advertiserView = unifiedNativeAdView.advertiserView as? UILabel
    }

    private func fetchAd() {
        adLoader.delegate = self
        let request = GADRequest()
        adLoader.load(request)
    }
    
    func view() -> UIView {
        return unifiedNativeAdView
    }
    
    fileprivate func dispose() {
        unifiedNativeAdView.nativeAd = nil
        channel.setMethodCallHandler(nil)
    }
}

extension UnifiedAdLayout : GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        channel.invokeMethod("didFailToReceiveAdWithError", arguments: ["errorCode": error.code, "message": error.localizedDescription])
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        channel.invokeMethod("didReceive", arguments: nil)
        headlineView.text = nativeAd.headline
        bodyView.text = nativeAd.body
        callToActionView.text = nativeAd.callToAction
        attributionView.text = attributionText
        unifiedNativeAdView.nativeAd = nativeAd
        
        mediaView?.mediaContent = nativeAd.mediaContent
        iconView?.image = nativeAd.icon?.image
        starRatingView?.text = String(describing: nativeAd.starRating?.doubleValue)
        storeView?.text = nativeAd.store
        priceView?.text = nativeAd.price
        advertiserView?.text = nativeAd.advertiser
        
        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self
    }
}

// MARK: - GADUnifiedNativeAdDelegate implementation
extension UnifiedAdLayout : GADUnifiedNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
        channel.invokeMethod("nativeAdDidRecordClick", arguments: nil)
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
        channel.invokeMethod("nativeAdDidRecordImpression", arguments: nil)
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
        channel.invokeMethod("nativeAdWillLeaveApplication", arguments: nil)
    }
}
