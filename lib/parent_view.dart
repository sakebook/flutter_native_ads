import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void ParentViewCreatedCallback(ParentViewController controller);

class ParentView extends StatefulWidget {
  const ParentView({
    Key key,
    this.onParentViewCreated,
  }) : super(key: key);

  final ParentViewCreatedCallback onParentViewCreated;

  @override
  State<StatefulWidget> createState() => _ParentViewState();
}

class _ParentViewState extends State<ParentView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'com.github.sakebook/parent_view',
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
    widget.onParentViewCreated(ParentViewController._(id));
  }
}

class ParentViewController {
  ParentViewController._(int id)
      : _channel = MethodChannel('com.github.sakebook/parent_view_$id');

  final MethodChannel _channel;

  Future<void> addView() async {
    return _channel.invokeMethod('addView');
  }
}