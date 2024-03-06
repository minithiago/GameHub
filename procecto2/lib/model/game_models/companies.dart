class CompaniesModel {
  final int id;
  final String name;

  CompaniesModel(this.id, this.name);

  CompaniesModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];
}
