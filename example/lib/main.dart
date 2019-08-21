import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:native_ads/layout_rules.dart';
import 'package:native_ads/layout_views.dart';
import 'package:native_ads/native_ads.dart';
import 'package:native_ads/native_ad_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  NativeAdViewController _controller;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await NativeAds.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: <Widget>[
                Text("text start"),
                SizedBox(
                  child: Text('Running on: $_platformVersion\n'),
                  width: double.infinity,
                  height: 200,
                ),
                Text("text middle"),
                SizedBox(
                  child: NativeAdView(
                    onParentViewCreated: (controller) {
                      _controller = controller;
                      populateNativeAdView();
                    },
                  ),
                  width: double.infinity,
                  height: 200,
                ),
                Text("text end"),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
//          addView();
          populateNativeAdView();
        }),
      ),
    );
  }

  void populateNativeAdView() {
//    _controller.addHeadline(rule: LayoutRules.alignParentTop);
//    _controller.addBody(rule: LayoutRules.below, view: LayoutViews.headline);
//    _controller.addCallToAction(rule: LayoutRules.below, view: LayoutViews.body);
//    _controller.addMedia(rule: LayoutRules.below, view: LayoutViews.callToAction);
//    _controller.setNativeAd();
  }
}
