import 'package:flutter/material.dart';
import 'package:native_ads/native_ad_param.dart';
import 'package:native_ads/native_ad_view.dart';

class NativeAdViewWrapper extends StatefulWidget {
  const NativeAdViewWrapper();

  @override
  NativeAdViewWrapperState createState() => NativeAdViewWrapperState();
}

class NativeAdViewWrapperState extends State<NativeAdViewWrapper>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  NativeAdViewController _controller;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NativeAdView(
      onParentViewCreated: (controller) {
        _controller = controller;
      },
      androidParam: AndroidParam()
        ..placementId = "ca-app-pub-3940256099942544/2247696110" // test
        ..packageName = "sakebook.github.com.native_ads_example"
        ..layoutName = "native_ad_layout"
        ..attributionText = "広告",
      iosParam: IOSParam()
        ..placementId = "ca-app-pub-3940256099942544/3986624511" // test
        ..packageName = "sakebook.github.com.nativeAdsExample"
        ..layoutName = "UnifiedNativeAdView"
        ..attributionViewId = "attribution_view_id"
        ..attributionText = "SPONSORED",
      onAdImpression: () => print("onAdImpression!!!"),
      onAdClicked: () => print("onAdClicked!!!"),
    );
  }
}
