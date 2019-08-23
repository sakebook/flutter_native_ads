class AndroidParam {
  String placementId;
  String packageName;
  String layoutName;
  String headlineViewId;
  String imageViewId;
  String bodyViewId;
  String iconViewId;
  String callToActionViewId;
  String mediaViewId;
  String attributionViewId;
  String attributionTextResId;

  dynamic toMap() {
    return {
      "placement_id": placementId,
      "package_name": packageName,
      "layout_name": layoutName,
      "view_id_headline": headlineViewId,
      "view_id_image": imageViewId,
      "view_id_body": bodyViewId,
      "view_id_icon": iconViewId,
      "view_id_call_to_action": callToActionViewId,
      "view_id_media": mediaViewId,
      "view_id_attribution": attributionViewId,
      "res_id_attribution": attributionTextResId,
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
