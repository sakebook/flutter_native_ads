import 'package:flutter/services.dart';

class NativeAds {
  NativeAds.initialize() {
    _channel.invokeListMethod<void>('initialize');
  }
  static const MethodChannel _channel = MethodChannel('native_ads');
}
