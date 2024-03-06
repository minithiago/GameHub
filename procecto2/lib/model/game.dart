import 'package:procecto2/model/game_models/genre.dart';
import 'package:procecto2/model/game_models/keyword.dart';
import 'package:procecto2/model/game_models/mode.dart';
import 'package:procecto2/model/game_models/platform.dart';
import 'package:procecto2/model/game_models/player_perspective.dart';
import 'package:procecto2/model/game_models/screenshot.dart';
import 'package:procecto2/model/game_models/video.dart';
import 'game_models/cover.dart';

class GameModel {
  final int id;
  final CoverModel? cover;
  final int createdAt;
  final int firstRelease;
  final List<ModeModel>? modes;
  final List<GenreModel>? genres;
  final List<KeywordModel>? keywords;
  final List<PlatformModel>? platforms;
  final List<PlayerPerspectiveModel>? perspectives;
  final List<ScreenshotModel>? screenshots;
  final String summary;
  final List<VideoModel>? videos;
  final double rating;
  final String name;

  GameModel(
      this.id,
      this.cover,
      this.createdAt,
      this.firstRelease,
      this.modes,
      this.genres,
      this.keywords,
      this.platforms,
      this.perspectives,
      this.screenshots,
      this.summary,
      this.videos,
      this.rating,
      this.name);

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      json["id"],
      json["cover"] == null ? null : CoverModel.fromJson(json["cover"]),
      json["created_at"] ??
          0, // Ajusta el valor predeterminado según tus necesidades
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
      json["keywords"] == null
          ? null
          : (json["keywords"] as List?)
              ?.map((i) => KeywordModel.fromJson(i))
              .toList(),
      json["platforms"] == null
          ? null
          : (json["platforms"] as List?)
              ?.map((i) => PlatformModel.fromJson(i))
              .toList(),
      json["player_perspectives"] == null
          ? null
          : (json["player_perspectives"] as List?)
              ?.map((i) => PlayerPerspectiveModel.fromJson(i))
              .toList(),
      json["screenshots"] == null
          ? null
          : (json["screenshots"] as List?)
              ?.map((i) => ScreenshotModel.fromJson(i))
              .toList(),
      json["summary"] ??
          "No hay descripcion", // Cambiar en juegos poco conocidos
      json["videos"] == null
          ? null
          : (json["videos"] as List?)
              ?.map((i) => VideoModel.fromJson(i))
              .toList(),
      json["total_rating"]?.toDouble() ?? 0.0,
      json["name"] ?? "",
    );
  }
}
