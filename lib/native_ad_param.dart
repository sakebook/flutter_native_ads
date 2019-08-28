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
  String packageName;
  String layoutName;
  String attributionViewId;
  String attributionText;

  dynamic toMap() {
    return {
      "placement_id": placementId,
      "package_name": packageName,
      "layout_name": layoutName,
      "view_id_attribution": attributionViewId,
      "text_attribution": attributionText,
    };
  }
}
