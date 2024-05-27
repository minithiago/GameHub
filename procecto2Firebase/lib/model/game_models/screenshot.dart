class ScreenshotModel {
  final String imageId;

  ScreenshotModel(this.imageId);

  Map<String, dynamic> toJson() {
    return {
      'image_id': imageId,
    };
  }

  ScreenshotModel.fromJson(Map<String, dynamic> json)
      : imageId = json["image_id"];
}
