
class SimilarModel {
  final int id;
  final List<CoverModel2>? cover;
  final String name;
  

  SimilarModel(this.id, this.cover, this.name);

  
  //json["cover"] == null ? null : CoverModel.fromJson(json["cover"]),
  SimilarModel.fromJson(Map<String, dynamic> json) 
    :id = json["id"],
    cover = json["cover"] == null
            ? null
            : json["cover"] is List
                ? (json["cover"] as List?)
                    ?.map((similarJson) =>
                        CoverModel2.fromJson(similarJson))
                    .toList()
                : [
                    CoverModel2.fromJson(json["cover"]),
                  ],
       name =
      json["name"] ?? "";

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cover': cover == null
          ? null
          : cover!.length == 1
              ? cover![0].toJson()
              : cover!.map((company) => company.toJson()).toList(),
      'name': name,
    };
    
  }
    
}

class CoverModel2 {
  final int id;
  final int height;
  final int width;
  final String imageId;
  final String url;

  CoverModel2(this.id, this.height, this.width, this.imageId, this.url);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'height': height,
      'width': width,
      'image_id': imageId,
      'url': url,
    };
  }

  CoverModel2.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        height = json["height"],
        width = json["width"],
        imageId = json["image_id"],
        url = json["url"];
}
