import 'package:flutter/material.dart';

import 'package:native_ads/native_ad_view.dart';
import 'package:native_ads_example/native_ad_view_wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
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
                    child: NativeAdViewWrapper(),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "this is text ${index}",
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
