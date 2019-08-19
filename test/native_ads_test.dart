import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_ads/native_ads.dart';

void main() {
  const MethodChannel channel = MethodChannel('native_ads');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await NativeAds.platformVersion, '42');
  });
}
