import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_ads/native_ad_event_delegate.dart';
import 'package:native_ads/native_ad_param.dart';

/// Called when an impression is recorded for an ad.
typedef NativeAdViewCreatedCallback = void Function(
    NativeAdViewController controller);

/// Wraps PlatformView view.
class NativeAdView extends StatefulWidget {
  /// Create a NativeAdView
  const NativeAdView({
    Key key,
    this.onParentViewCreated,
    this.androidParam,
    this.iosParam,
    this.onAdImpression,
    this.onAdLeftApplication,
    this.onAdClicked,
    this.onAdFailedToLoad,
    this.onAdLoaded,
  }) : super(key: key);

  /// Called when PlatformView created.
  final NativeAdViewCreatedCallback onParentViewCreated;
  /// Android parameter for ad.
  final AndroidParam androidParam;
  /// iOS parameter for ad.
  final IOSParam iosParam;
  /// Called when an impression is recorded for an ad.
  final Function() onAdImpression;
  /// Called when an ad leaves the application (e.g., to go to the browser).
  final Function() onAdLeftApplication;
  /// Called when a click is recorded for an ad.
  final Function() onAdClicked;
  /// Called when an ad request failed.
  final Function(Map<String, dynamic>) onAdFailedToLoad;
  /// Called when an ad is received.
  final Function() onAdLoaded;

  @override
  State<StatefulWidget> createState() => _NativeAdViewState(
        NativeAdEventDelegate(
          onAdImpression: onAdImpression,
          onAdLeftApplication: onAdLeftApplication,
          onAdClicked: onAdClicked,
          onAdFailedToLoad: onAdFailedToLoad,
          onAdLoaded: onAdLoaded,
        ),
      );
}

class _NativeAdViewState extends State<NativeAdView> {
  _NativeAdViewState(this.delegate);

  final NativeAdEventDelegate delegate;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'com.github.sakebook.android/unified_ad_layout',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: widget.androidParam.toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'com.github.sakebook.ios/unified_ad_layout',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: widget.iosParam.toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onParentViewCreated == null) {
      return;
    }
    final NativeAdViewController controller = NativeAdViewController._(id);
    controller._channel.setMethodCallHandler(delegate.handleMethod);
    widget.onParentViewCreated(controller);
  }
}

/// Controller MethodChannel Flutter <-> Android and iOS.
class NativeAdViewController {
  NativeAdViewController._(int id) : _channel = _createChannel(id);

  final MethodChannel _channel;

  static MethodChannel _createChannel(int id) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return MethodChannel('com.github.sakebook.android/unified_ad_layout_$id');
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return MethodChannel('com.github.sakebook.ios/unified_ad_layout_$id');
    } else {
      return throw MissingPluginException();
    }
  }
}
