import 'package:procecto2/model/game_models/artwork.dart';
import 'package:procecto2/model/game_models/company.dart';
import 'package:procecto2/model/game_models/dlcs.dart';
import 'package:procecto2/model/game_models/genre.dart';
import 'package:procecto2/model/game_models/language.dart';
//import 'package:procecto2/model/game_models/keyword.dart';
import 'package:procecto2/model/game_models/mode.dart';
import 'package:procecto2/model/game_models/platform.dart';
//import 'package:procecto2/model/game_models/player_perspective.dart';
import 'package:procecto2/model/game_models/screenshot.dart';
import 'package:procecto2/model/game_models/similar.dart';
import 'game_models/cover.dart';

class GameModel {
  final int id;
  final CoverModel? cover;
  //final int createdAt;
  final int firstRelease;
  final List<ModeModel>? modes;
  final List<GenreModel>? genres;
  //final List<KeywordModel>? keywords;
  final List<PlatformModel>? platforms;
  //final List<PlayerPerspectiveModel>? perspectives;
  final List<ScreenshotModel>? screenshots;
  final List<ArtworkModel>? artworks;
  final List<CompanyModel>? companies;
  final List<SimilarModel>? similar;
  final List<dlcModel>? dlc;
  final List<LanguageModel>? languages;
  final String summary;
  //final List<VideoModel>? videos;
  final double total_rating;
  final String name;
  final String slug;
  bool favorite = false;
  bool wishlist = false;
  bool library = false;

  GameModel(
      this.id,
      this.cover,
      //this.createdAt,
      this.firstRelease,
      this.modes,
      this.genres,
      //this.keywords,
      this.platforms,
      //this.perspectives,
      this.screenshots,
      this.artworks,
      this.companies,
      this.similar,
      this.dlc,
      this.languages,
      this.summary,
      //this.videos,
      this.total_rating,
      this.slug,
      this.name,
      this.favorite,
      this.wishlist,
      this.library);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      //'createdAt': createdAt,
      'first_release_date': firstRelease,
      'summary': summary,
      'total_rating': total_rating,
      'name': name,
      'slug': slug,
      'favorite': favorite,
      'wishlist': wishlist,
      'library': library,
      'cover': cover?.toJson(),
      'modes': modes?.map((mode) => mode.toJson()).toList(),
      'genres': genres?.map((genre) => genre.toJson()).toList(),
      //'keywords': this.keywords?.map((keyword) => keyword.toJson()).toList(),
      'platforms': platforms?.map((platform) => platform.toJson()).toList(),
      //'perspectives': this.perspectives?.map((perspective) => perspective.toJson()).toList(),
      'screenshots':
          screenshots?.map((screenshot) => screenshot.toJson()).toList(),
      'artworks': artworks?.map((artwork) => artwork.toJson()).toList(),
      'involved_companies':
          companies?.map((company) => company.toJson()).toList(),
      'similar_games': similar?.map((game) => game.toJson()).toList(),
      'dlcs': dlc?.map((dlc) => dlc.toJson()).toList(),
      'language_supports':
          languages?.map((language) => language.toJson()).toList(),
      //'videos': videos?.map((video) => video.toJson()).toList(),
    };
    return data;
  }

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
        json["id"],
        json["cover"] == null ? null : CoverModel.fromJson(json["cover"]),
        //json["created_at"] ??    0, // Ajusta el valor predeterminado según tus necesidades
        json["first_release_date"] ?? 0,
        json["game_modes"] == null
            ? null
            : (json["game_modes"] as List?)
                ?.map((i) => ModeModel.fromJson(i))
                .toList(),
        json["genres"] == null
            ? null
            : (json["genres"] as List?)
                ?.map((i) => GenreModel.fromJson(i))
                .toList(),
        //json["keywords"] == null
        //    ? null
        //    : (json["keywords"] as List?)
        //        ?.map((i) => KeywordModel.fromJson(i))
        //        .toList(),
        json["platforms"] == null
            ? null
            : (json["platforms"] as List?)
                ?.map((i) => PlatformModel.fromJson(i))
                .toList(),
        //json["player_perspectives"] == null
        //    ? null
        //    : (json["player_perspectives"] as List?)
        //        ?.map((i) => PlayerPerspectiveModel.fromJson(i))
        //        .toList(),
        json["screenshots"] == null
            ? null
            : (json["screenshots"] as List?)
                ?.map((i) => ScreenshotModel.fromJson(i))
                .toList(),
        json["artworks"] == null
            ? null
            : (json["artworks"] as List?)
                ?.map((i) => ArtworkModel.fromJson(i))
                .toList(),
        json["involved_companies"] == null
            ? null
            : (json["involved_companies"] as List?)
                ?.map((i) => CompanyModel.fromJson(i))
                .toList(),
        json["similar_games"] == null
            ? null
            : (json["similar_games"] as List?)
                ?.map((i) => SimilarModel.fromJson(i))
                .toList(),
        json["dlcs"] == null
            ? null
            : (json["dlcs"] as List?)
                ?.map((i) => dlcModel.fromJson(i))
                .toList(),
        json["language_supports"] == null
            ? null
            : (json["language_supports"] as List?)
                ?.map((i) => LanguageModel.fromJson(i))
                .toList(),
        json["summary"] ??
            "No summary available", // Cambiar en juegos poco conocidos
        /*
        json["videos"] == null
            ? null
            : (json["videos"] as List?)
                ?.map((i) => VideoModel.fromJson(i))
                .toList(),*/
        json["total_rating"] ?? 0.0,
        json["slug"] ?? "",
        json["name"] ?? "",
        false,
        false,
        false);
  }
}

class SimilarGamesModel {
  final String name;
  final int id;

  SimilarGamesModel(this.id, this.name);

  SimilarGamesModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];

  Map<String, dynamic> toJson() {
    return {'name': name, 'id': id};
  }
}
