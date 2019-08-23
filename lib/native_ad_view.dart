import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_ads/native_ad_event_delegate.dart';
import 'package:native_ads/native_ad_param.dart';

typedef void NativeAdViewCreatedCallback(NativeAdViewController controller);

class NativeAdView extends StatefulWidget {
  const NativeAdView({
    Key key,
    this.onParentViewCreated,
    this.nativeAdParam,
    this.onAdImpression,
    this.onAdLeftApplication,
    this.onAdClicked,
    this.onAdFailedToLoad,
    this.onAdClosed,
    this.onAdOpened,
    this.onAdLoaded,
  }) : super(key: key);

  final NativeAdViewCreatedCallback onParentViewCreated;
  final NativeAdParam nativeAdParam;
  final Function() onAdImpression;
  final Function() onAdLeftApplication;
  final Function() onAdClicked;
  final Function(Map<String, dynamic>) onAdFailedToLoad;
  final Function() onAdClosed;
  final Function() onAdOpened;
  final Function() onAdLoaded;

  @override
  State<StatefulWidget> createState() => _NativeAdViewState(
        NativeAdEventDelegate(
          onAdImpression: onAdImpression,
          onAdLeftApplication: onAdLeftApplication,
          onAdClicked: onAdClicked,
          onAdFailedToLoad: onAdFailedToLoad,
          onAdClosed: onAdClosed,
          onAdOpened: onAdOpened,
          onAdLoaded: onAdLoaded,
        ),
      );
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
    return UiKitView(
      viewType: 'com.github.sakebook/unified_ad_layout',
      onPlatformViewCreated: _onPlatformViewCreated,
      creationParams: widget.nativeAdParam.toMap(),
      creationParamsCodec: StandardMessageCodec(),
    );
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
}
