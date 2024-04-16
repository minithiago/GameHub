class CompanyModel {
  final int id;
  final List<CompanyDetailsModel>? company; // Cambio aquí

  CompanyModel(this.id, this.company);

  CompanyModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        company = json["company"] == null
            ? null
            : json["company"] is List
                ? (json["company"] as List?)
                    ?.map((companyJson) =>
                        CompanyDetailsModel.fromJson(companyJson))
                    .toList()
                : [
                    CompanyDetailsModel.fromJson(json["company"]),
                  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company == null
          ? null
          : company!.length == 1
              ? company![0].toJson()
              : company!.map((company) => company.toJson()).toList(),
    };
  }
}

class CompanyDetailsModel {
  final String name;
  final int id;

  CompanyDetailsModel(this.id, this.name);

  CompanyDetailsModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];

  Map<String, dynamic> toJson() {
    return {'name': name, 'id': id};
  }
}
