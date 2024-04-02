import 'package:procecto2/model/game_models/company.dart';

class CompaniesModel {
  final int id;
  final List<CompanyModel>? company;

  CompaniesModel(this.id, this.company);

  CompaniesModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        company = json["company"] == null
            ? null
            : (json["company"] as List?)
                ?.map((i) => CompanyModel.fromJson(i))
                .toList();
}




//PROBANDO