import 'package:procecto2/model/game_models/cover.dart';

class dlcModel {
  final int id;
  final List<CoverModel3>? cover;
  final String name;

  dlcModel(
    this.id,
    this.cover,
    this.name,
  );

  dlcModel.fromJson(Map<String, dynamic> json) : id = json["id"],
  cover = json["cover"] == null
            ? null
            : json["cover"] is List
                ? (json["cover"] as List?)
                    ?.map((dlcJson) =>
                        CoverModel3.fromJson(dlcJson))
                    .toList()
                : [
                    CoverModel3.fromJson(json["cover"]),
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
              : cover!.map((dlc) => dlc.toJson()).toList(),
      'name': name,
    };
  }
}
class CoverModel3 {
  final int id;
  final int height;
  final int width;
  final String imageId;
  final String url;

  CoverModel3(this.id, this.height, this.width, this.imageId, this.url);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'height': height,
      'width': width,
      'image_id': imageId,
      'url': url,
    };
  }

  CoverModel3.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        height = json["height"],
        width = json["width"],
        imageId = json["image_id"],
        url = json["url"];
}
