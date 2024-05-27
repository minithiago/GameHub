class CoverModel {
  final String imageId;

  CoverModel(this.imageId);

  Map<String, dynamic> toJson() {
    return {
      'image_id': imageId,
    };
  }

  CoverModel.fromJson(Map<String, dynamic> json) : imageId = json["image_id"];
}
