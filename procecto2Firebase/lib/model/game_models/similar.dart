import 'package:procecto2/model/game_models/companies.dart';
import 'package:procecto2/model/game_models/cover.dart';
import 'package:procecto2/model/game_models/genre.dart';
import 'package:procecto2/model/game_models/keyword.dart';
import 'package:procecto2/model/game_models/mode.dart';
import 'package:procecto2/model/game_models/platform.dart';
import 'package:procecto2/model/game_models/player_perspective.dart';
import 'package:procecto2/model/game_models/screenshot.dart';
import 'package:procecto2/model/game_models/similar.dart';
import 'package:procecto2/model/game_models/video.dart';

class SimilarModel {
  final int id;
  final CoverModel? cover;
  final int createdAt;
  final int firstRelease;
  final List<ModeModel>? modes;
  final List<GenreModel>? genres;
  final List<PlatformModel>? platforms; //PROBANDO
  final List<ScreenshotModel>? screenshots;
  final String summary;
  final List<VideoModel>? videos;
  final double rating;
  final String name;
  final String slug;

  SimilarModel(
      this.id,
      this.cover,
      this.createdAt,
      this.firstRelease,
      this.modes,
      this.genres,
      this.platforms,
      this.screenshots,
      this.summary,
      this.videos,
      this.rating,
      this.slug,
      this.name);

  factory SimilarModel.fromJson(Map<String, dynamic> json) {
    return SimilarModel(
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

      json["platforms"] == null
          ? null
          : (json["platforms"] as List?)
              ?.map((i) => PlatformModel.fromJson(i))
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
      json["slug"] ?? "",
      json["name"] ?? "",
    );
  }
}
