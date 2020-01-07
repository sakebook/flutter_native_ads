import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_ads/native_ads.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('NativeAds', () {
    const MethodChannel channel = MethodChannel('native_ads');

    final List<MethodCall> log = <MethodCall>[];

    setUp(() async {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'initialize':
            return Future<bool>.value(true);
          default:
            assert(false);
            return null;
        }
      });
    });

    test('initialize', () async {
      log.clear();
      expect(NativeAds.initialize(), isInstanceOf<NativeAds>());
      expect(log, <Matcher>[
        isMethodCall('initialize', arguments: null),
      ]);
    });

    tearDown(() {
      channel.setMockMethodCallHandler(null);
    });
  });
}
