class AndroidParam {
  String placementId;
  String packageName;
  String layoutName;
  String attributionText;

  dynamic toMap() {
    return {
      "placement_id": placementId,
      "package_name": packageName,
      "layout_name": layoutName,
      "text_attribution": attributionText,
    };
  }
}

class IOSParam {
  String placementId;
  String bundleId;
  String layoutName;
  String attributionText;

  dynamic toMap() {
    return {
      "placement_id": placementId,
      "bundle_id": bundleId,
      "layout_name": layoutName,
      "text_attribution": attributionText,
    };
  }
}
