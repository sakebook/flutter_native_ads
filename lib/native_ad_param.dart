import 'dart:ui';

/// Android parameter for ad.
class AndroidParam {
  /// AdMob placement id.
  String placementId;

  /// Android package name of plugin used app.
  String packageName;

  /// XML file name that your custom layout for native ad.
  String layoutName;

  /// Ad Attribution text.
  String attributionText;

  /// Test device ids.
  List<String> testDevices;

  //Ad Title
  double headlineFontSize;
  Color headlineFontColor;

  //Ad description
  double bodyFontSize;
  Color bodyFontColor;

  // "AD" Label
  double attributionViewFontSize;
  Color attributionViewFontColor;

  // Button
  double callToActionFontSize;
  bool dark;
  Color callToActionFontColor;

  Color backgroundColor;


  /// Converts this param to a Map
  dynamic toMap() {
    return <String, dynamic>{
      'placement_id': placementId,
      'package_name': packageName,
      'layout_name': layoutName,
      'text_attribution': attributionText,
      'test_devices': testDevices,
      'headline_font_size': headlineFontSize,
      'headline_font_color': _toAndroidColor(headlineFontColor),
      'body_font_size': bodyFontSize,
      'body_font_color': _toAndroidColor(bodyFontColor),
      'attribution_view_font_size': attributionViewFontSize,
      'attribution_view_font_color': _toAndroidColor(attributionViewFontColor),
      'call_to_action_font_size': callToActionFontSize,
      'dark': dark,
      'call_to_action_font_color': _toAndroidColor(callToActionFontColor),
      'background_color': _toAndroidColor(backgroundColor)
    };
  }

  String _toAndroidColor(Color color) =>
      color == null
          ? null
          : '#' + color.value.toRadixString(16);
}

/// iOS parameter for ad.
class IOSParam {
  /// AdMob placement id.
  String placementId;

  /// iOD bundle id of plugin used app.
  String bundleId;

  /// XIB file name that your custom layout for native ad.
  String layoutName;

  /// Ad Attribution text.
  String attributionText;

  /// Test device ids.
  List<String> testDevices;

  //Ad Title
  double headlineFontSize;
  String headlineFontColor;

  //Ad description
  double bodyFontSize;
  String bodyFontColor;

  // "AD" Label
  double attributionViewFontSize;
  String attributionViewFontColor;

  // Button
  double callToActionFontSize;
  String callToActionFontColor;
  String callToActionBackgroundColor;

  String backgroundColor;

  /// Converts this param to a Map
  dynamic toMap() {
    return <String, dynamic>{
      'placement_id': placementId,
      'bundle_id': bundleId,
      'layout_name': layoutName,
      'text_attribution': attributionText,
      'test_devices': testDevices,
      'headline_font_size': headlineFontSize,
      'headline_font_color': headlineFontColor,
      'body_font_size': bodyFontSize,
      'body_font_color': bodyFontColor,
      'attribution_view_font_size': attributionViewFontSize,
      'attribution_view_font_color': attributionViewFontColor,
      'call_to_action_font_size': callToActionFontSize,
      'call_to_action_font_color': callToActionFontColor,
      'call_to_action_background_color': callToActionBackgroundColor,
      'background_color': backgroundColor
    };
  }
}
