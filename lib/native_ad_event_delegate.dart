import 'package:flutter/services.dart';

class NativeAdEventDelegate {
  const NativeAdEventDelegate({
    this.onAdImpression,
    this.onAdLeftApplication,
    this.onAdClicked,
    this.onAdFailedToLoad,
    this.onAdClosed,
    this.onAdOpened,
    this.onAdLoaded,
  });

  final Function() onAdImpression;
  final Function() onAdLeftApplication;
  final Function() onAdClicked;
  final Function(Map<String, dynamic>) onAdFailedToLoad;
  final Function() onAdClosed;
  final Function() onAdOpened;
  final Function() onAdLoaded;

  Future<dynamic> handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onAdImpression':
        onAdImpression();
        break;
      case 'onAdLeftApplication':
        onAdLeftApplication();
        break;
      case 'onAdClicked':
        onAdClicked();
        break;
      case 'onAdFailedToLoad':
        onAdFailedToLoad(Map<String, dynamic>.from(call.arguments));
        break;
      case 'onAdClosed':
        onAdClosed();
        break;
      case 'onAdOpened':
        onAdOpened();
        break;
      case 'onAdLoaded':
        onAdLoaded();
        break;
    }
  }
}
