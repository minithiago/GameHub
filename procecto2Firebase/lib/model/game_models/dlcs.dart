class dlcModel {
  final int id;
  final List<CoverModel3>? cover;
  final String name;

  dlcModel(
    this.id,
    this.cover,
    this.name,
  );

  dlcModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        cover = json["cover"] == null
            ? null
            : json["cover"] is List
                ? (json["cover"] as List?)
                    ?.map((dlcJson) => CoverModel3.fromJson(dlcJson))
                    .toList()
                : [
                    CoverModel3.fromJson(json["cover"]),
                  ],
        name = json["name"] ?? "";

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
  final String imageId;

  CoverModel3(this.imageId);

  Map<String, dynamic> toJson() {
    return {
      'image_id': imageId,
    };
  }

  CoverModel3.fromJson(Map<String, dynamic> json) : imageId = json["image_id"];
}
