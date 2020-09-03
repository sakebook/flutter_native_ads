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
        ..attributionText = "AD"
        ..testDevices = ["00000000000000000000000000000000"]
        ..headlineFontSize = 32.0
        ..headlineFontColor = const Color.fromARGB(0xFF, 0xFF, 0x80, 0x00)
        ..bodyFontSize = 32.0
        ..bodyFontColor = const Color.fromARGB(0xFF, 0x00, 0xFF, 0x80)
        ..attributionViewFontSize = 32.0
        ..attributionViewFontColor =
            const Color.fromARGB(0xFF, 0x80, 0x00, 0xFF)
        ..callToActionFontSize = 32.0
        ..callToActionFontColor = const Color.fromARGB(0xFF, 0xFF, 0xF0, 0x00)
        ..callToActionBackgroundColor =
            const Color.fromARGB(0xFF, 0x00, 0xFF, 0xFF)
        ..backgroundColor = const Color.fromARGB(0xFF, 0xFF, 0x00, 0xFF),
      iosParam: IOSParam()
        ..placementId = "ca-app-pub-3940256099942544/3986624511" // test
        ..bundleId = "sakebook.github.com.nativeAdsExample"
        ..layoutName = "UnifiedNativeAdView"
        ..attributionText = "SPONSORED"
        ..testDevices = ["00000000000000000000000000000000"],
      onAdImpression: () => print("onAdImpression!!!"),
      onAdClicked: () => print("onAdClicked!!!"),
      onAdFailedToLoad: (Map<String, dynamic> error) =>
          print("onAdFailedToLoad!!! $error"),
      onAdLoaded: () => print("onAdLoaded!!!"),
    );
  }
}
