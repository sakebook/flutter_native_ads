import 'package:flutter/services.dart';
import 'package:native_ads/native_ad_event.dart';

class NativeAdEventDelegate {
  final Function(NativeAdEvent, Map<String, dynamic>) listener;

  NativeAdEventDelegate(this.listener);

  Future<dynamic> handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onAdImpression':
        listener(NativeAdEvent.onAdImpression, null);
        break;
      case 'onAdLeftApplication':
        listener(NativeAdEvent.onAdLeftApplication, null);
        break;
      case 'onAdClicked':
        listener(NativeAdEvent.onAdClicked, null);
        break;
      case 'onAdFailedToLoad':
        listener(NativeAdEvent.onAdFailedToLoad,
            Map<String, dynamic>.from(call.arguments));
        break;
      case 'onAdClosed':
        listener(NativeAdEvent.onAdClosed, null);
        break;
      case 'onAdOpened':
        listener(NativeAdEvent.onAdOpened, null);
        break;
      case 'onAdLoaded':
        listener(NativeAdEvent.onAdLoaded, null);
        break;
    }
  }
}
