import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_ads/layout_rules.dart';
import 'package:native_ads/layout_views.dart';

typedef void NativeAdViewCreatedCallback(NativeAdViewController controller);

class NativeAdView extends StatefulWidget {
  const NativeAdView({
    Key key,
    this.onParentViewCreated,
  }) : super(key: key);

  final NativeAdViewCreatedCallback onParentViewCreated;

  @override
  State<StatefulWidget> createState() => _NativeAdViewState();
}

class _NativeAdViewState extends State<NativeAdView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'com.github.sakebook/unified_ad_layout',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onParentViewCreated == null) {
      return;
    }
    widget.onParentViewCreated(NativeAdViewController._(id));
  }
}

class NativeAdViewController {
  NativeAdViewController._(int id)
      : _channel = MethodChannel('com.github.sakebook/unified_ad_layout_$id');

  final MethodChannel _channel;

  Future<void> addHeadline({LayoutRules rule, LayoutViews view}) async {
    return _channel.invokeMethod('addHeadline', {"rule": rule.toString(), "view": view.toString()});
  }
  Future<void> addImage({LayoutRules rule, LayoutViews view}) async {
    return _channel.invokeMethod('addImage', {"rule": rule.toString(), "view": view.toString()});
  }
  Future<void> addBody({LayoutRules rule, LayoutViews view}) async {
    return _channel.invokeMethod('addBody', {"rule": rule.toString(), "view": view.toString()});
  }
  Future<void> addIcon({LayoutRules rule, LayoutViews view}) async {
    return _channel.invokeMethod('addIcon', {"rule": rule.toString(), "view": view.toString()});
  }
  Future<void> addCallToAction({LayoutRules rule, LayoutViews view}) async {
    return _channel.invokeMethod('addCallToAction', {"rule": rule.toString(), "view": view.toString()});
  }
  Future<void> addMedia({LayoutRules rule, LayoutViews view}) async {
    return _channel.invokeMethod('addMedia', {"rule": rule.toString(), "view": view.toString()});
  }
  Future<void> setNativeAd() async {
    return _channel.invokeMethod('setNativeAd');
  }
}