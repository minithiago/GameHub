class ArtworkModel {
  final String imageId;

  ArtworkModel(this.imageId);

  Map<String, dynamic> toJson() {
    return {
      'image_id': imageId,
    };
  }

  ArtworkModel.fromJson(Map<String, dynamic> json) : imageId = json["image_id"];
}
