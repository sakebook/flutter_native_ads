import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_ads/native_ad_event.dart';
import 'package:native_ads/native_ad_event_delegate.dart';
import 'package:native_ads/native_ad_param.dart';

typedef void NativeAdViewCreatedCallback(NativeAdViewController controller);

class NativeAdView extends StatefulWidget {
  NativeAdView({
    Key key,
    this.onParentViewCreated,
    this.nativeAdParam,
    this.listener,
  }) : super(key: key);

  final NativeAdViewCreatedCallback onParentViewCreated;
  final NativeAdParam nativeAdParam;
  final Function(NativeAdEvent, Map<String, dynamic>) listener;

  @override
  State<StatefulWidget> createState() =>
      _NativeAdViewState(NativeAdEventDelegate(listener));
}

class _NativeAdViewState extends State<NativeAdView> {
  final NativeAdEventDelegate delegate;

  _NativeAdViewState(this.delegate);

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'com.github.sakebook/unified_ad_layout',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: widget.nativeAdParam.toMap(),
        creationParamsCodec: StandardMessageCodec(),
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onParentViewCreated == null) {
      return;
    }
    final controller = NativeAdViewController._(id);
    controller._channel.setMethodCallHandler(delegate.handleMethod);
    widget.onParentViewCreated(controller);
  }
}

class NativeAdViewController {
  NativeAdViewController._(int id)
      : _channel = MethodChannel('com.github.sakebook/unified_ad_layout_$id');

  final MethodChannel _channel;

  Future<void> setNativeAd() async {
    return _channel.invokeMethod('setNativeAd');
  }
}
