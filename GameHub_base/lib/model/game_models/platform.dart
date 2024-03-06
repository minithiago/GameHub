class PlatformModel {
  final int id;
  final String name;
  //final String alternative_name;
  //final String abbreviation;

  PlatformModel(
    this.id,
    this.name,
  );

  PlatformModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];
  //alternative_name = json["alternative_name"],
}
