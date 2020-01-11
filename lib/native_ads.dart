import 'package:flutter/services.dart';

/// Flutter plugin for AdMob Native Ads.
class NativeAds {
  /// Initialize plugin.
  NativeAds.initialize() {
    _channel.invokeMethod<void>('initialize');
  }
  static const MethodChannel _channel = MethodChannel('native_ads');
}
