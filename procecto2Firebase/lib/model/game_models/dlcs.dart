import 'package:procecto2/model/game_models/cover.dart';

class dlcModel {
  final int id;
  //final CoverModel? cover;

  dlcModel(
    this.id,
    /*this.cover*/
  );

  dlcModel.fromJson(Map<String, dynamic> json) : id = json["id"];
  //cover = json["cover"];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      //'cover': cover,
    };
  }
}
