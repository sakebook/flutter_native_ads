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

  /// Converts this param to a Map
  dynamic toMap() {
    return <String, String>{
      'placement_id': placementId,
      'package_name': packageName,
      'layout_name': layoutName,
      'text_attribution': attributionText,
    };
  }
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

  /// Converts this param to a Map
  dynamic toMap() {
    return <String, String>{
      'placement_id': placementId,
      'bundle_id': bundleId,
      'layout_name': layoutName,
      'text_attribution': attributionText,
    };
  }
}
