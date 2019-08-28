# flutter_native_ads

Flutter native ads with PlatformView

## Getting Started
### setup

#### Android
- [AndroidManifest changes](https://developers.google.com/admob/android/quick-start#update_your_androidmanifestxml)

AdMob 17 requires the App ID to be included in the `AndroidManifest.xml`. Failure
to do so will result in a crash on launch of your app.  The line should look like:

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="[ADMOB_APP_ID]"/>
```

where `[ADMOB_APP_ID]` is your App ID.  You must pass the same value when you 
initialize the plugin in your Dart code.

#### iOS
- [Info.plist changes](https://developers.google.com/admob/ios/quick-start#update_your_infoplist)

Admob 7.42.0 requires the App ID to be included in `Info.plist`. Failure to do so will result in a crash on launch of your app. The lines should look like:

```xml
<key>GADApplicationIdentifier</key>
<string>[ADMOB_APP_ID]</string>
```

where `[ADMOB_APP_ID]` is your App ID.  You must pass the same value when you initialize the plugin in your Dart code.

And PlatformView

```xml
<key>io.flutter.embedded_views_preview</key>
<true/>
```

### Layout file
This plugin supported custom layout

#### Android
You can use anything if the parent is a ViewGroup.
The example uses RelativeLayout.

Use `com.google.android.gms.ads.formats.MediaView` for MediaView.

Please give any ID to each view.

![image](https://raw.githubusercontent.com/sakebook/flutter_native_ads/master/art/android_mevia_view.png)

#### iOS
Please set GADUnifiedNativeAdView for the parent.

![image](https://raw.githubusercontent.com/sakebook/flutter_native_ads/master/art/ios_unified_native_ad_view.png)

Please set GADMediaView to MediaView.

![image](https://raw.githubusercontent.com/sakebook/flutter_native_ads/master/art/ios_media_view.png)

Please set Restoration ID for View that displays attribution

![image](https://raw.githubusercontent.com/sakebook/flutter_native_ads/master/art/ios_attribution.png)

### Usage

```dart
import 'package:flutter/material.dart';
import 'package:native_ads/native_ad_param.dart';
import 'package:native_ads/native_ad_view.dart';

import 'package:native_ads/native_ads.dart';

void main() {
  NativeAds.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NativeAds example app'),
        ),
        body: Center(
          child: ListView.separated(
            itemBuilder: (context, index) {
              if (index % 10 == 0) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: NativeAdView(
                      onParentViewCreated: (_) {},
                      androidParam: AndroidParam()
                        ..placementId =
                            "ca-app-pub-3940256099942544/2247696110" // test
                        ..packageName = "sakebook.github.com.native_ads_example"
                        ..layoutName = "native_ad_layout"
                        ..headlineViewId = "text_heading"
                        ..bodyViewId = "text_title"
                        ..callToActionViewId = "text_call_to_action"
                        ..mediaViewId = "video_thumbnail"
                        ..attributionViewId = "text_publisher"
                        ..attributionTextResId = "ad_attribution",
                      iosParam: IOSParam()
                        ..placementId =
                            "ca-app-pub-3940256099942544/3986624511" // test
                        ..packageName = "sakebook.github.com.nativeAdsExample"
                        ..layoutName = "UnifiedNativeAdView"
                        ..attributionViewId = "attribution_view_id"
                        ..attributionText = "SPONSORED",
                      onAdImpression: () => print("onAdImpression!!!"),
                      onAdClicked: () => print("onAdClicked!!!"),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "this is text $index",
                    style: Theme.of(context).textTheme.body1,
                  ),
                );
              }
            },
            itemCount: 50,
            separatorBuilder: (context, _) => const Divider(),
          ),
        ),
      ),
    );
  }
}
```

#### Event callback
Receive callbacks for some events by passing to the NativeAdView constructor

- onAdImpression
- onAdClicked
- onAdFailedToLoad
- onAdLeftApplication
- onAdLoaded

## Limitations

This is just an initial version of the plugin. There are still some
limitations:

- No support [some native ads fields](https://support.google.com/admob/answer/6240809).
- No support [Mediation Ads](https://developers.google.com/admob/android/mediate).
