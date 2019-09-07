import 'package:flutter/services.dart';

class NativeAds {
  NativeAds.initialize() {
    _channel.invokeMethod<void>('initialize');
  }
  static const MethodChannel _channel = MethodChannel('native_ads');
}
