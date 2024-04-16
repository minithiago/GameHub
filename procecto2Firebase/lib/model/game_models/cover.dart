class CoverModel {
  final int id;
  final int height;
  final int width;
  final String imageId;
  final String url;

  CoverModel(this.id, this.height, this.width, this.imageId, this.url);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'height': height,
      'width': width,
      'image_id': imageId,
      'url': url,
    };
  }

  CoverModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        height = json["height"],
        width = json["width"],
        imageId = json["image_id"],
        url = json["url"];
}
