import 'package:flutter/services.dart';

class NativeAds {
  static const MethodChannel _channel = const MethodChannel('native_ads');

  NativeAds.initialize() {
    _channel.invokeListMethod("initialize");
  }
}
