class CompanyModel {
  final int id;
  final String name;
  CompanyModel(this.id, this.name);

  CompanyModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];
}



//PROBANDO