class LanguageModel {
  final int id;
  final List<LanguageDetailsModel>? language; // Cambio aquí

  LanguageModel(this.id, this.language);

  LanguageModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        language = json["language"] == null
            ? null
            : json["language"] is List
                ? (json["language"] as List?)
                    ?.map((languageJson) =>
                        LanguageDetailsModel.fromJson(languageJson))
                    .toList()
                : [
                    LanguageDetailsModel.fromJson(json["language"]),
                  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language': language == null
          ? null
          : language!.length == 1
              ? language![0].toJson()
              : language!.map((language) => language.toJson()).toList(),
    };
  }
}

class LanguageDetailsModel {
  final String name;
  final int id;

  LanguageDetailsModel(this.id, this.name);

  LanguageDetailsModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];

  Map<String, dynamic> toJson() {
    return {'name': name, 'id': id};
  }
}
