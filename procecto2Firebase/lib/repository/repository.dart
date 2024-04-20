import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:procecto2/model/game_response.dart';

class GameRepository {
  static String mainUrl = "https://api.igdb.com/v4/games";
  static String releaseUrl = "https://api.igdb.com/v4/release_dates";

  final String apiKey = "vdpz4bxk5i2n66evywgfgpn9xzi5rc";

  Future<GameResponse> getGames() async {
    //Discover games
    //juegos con rating > 80 ;sort date desc;

    try {
      final response = await http.post(Uri.parse(mainUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Client-ID':
                'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
          },
          body: //"fields cover.*,similar_games.*,similar_games.cover.*;where cover.image_id != null & similar_games != null & total_rating >= 80 ; limit 33;"
              "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & total_rating >= 80 ; limit 99; sort first_release_date desc;");
      print("Juegos: ${response.statusCode}");
      //print(response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return GameResponse.fromJson(data);
      } else {
        throw Exception('Error al obtener datos de la API');
      }
    } catch (error) {
      print("Exception occurred: $error");
      return GameResponse.withError("$error");
    }
  }

  Future<GameResponse> getBestGames() async {
    //Best games all time
    //sort follows desc depcreated
    try {
      final response = await http.post(Uri.parse(mainUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Client-ID':
                'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
          },
          body:
              "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & total_rating >= 90 ; limit 33; sort total_rating_count desc;");
      print("Juegos2: ${response.statusCode}");

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return GameResponse.fromJson(data);
      } else {
        throw Exception('Error al obtener datos de la API');
      }
    } catch (error) {
      print("Exception occurred: $error");
      return GameResponse.withError("$error");
    }
  }

  Future<GameResponse> getSlider() async {
    final now = DateTime.parse(DateTime.now().toString());
    var nowDate = now.millisecondsSinceEpoch;
    //Discover slider
    //ultimos releases con nota mayor que 70
    //hypes > 3
    var response = await http.post(Uri.parse(mainUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Client-ID':
              'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
        },
        body:
            "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & screenshots != null & first_release_date <= $nowDate & total_rating >= 60 ; limit 10; sort first_release_date desc; ");
    print("Slider: ${response.statusCode}");
    return GameResponse.fromJson(jsonDecode(response.body));
  }

  Future<GameResponse> getSlider2() async {
    final now = DateTime.parse(DateTime.now().toString());
    var nowDate = now.millisecondsSinceEpoch;
    print(nowDate);
    //Search slider
    //Incoming Games
    var response = await http.post(Uri.parse(mainUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Client-ID':
              'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
        },
        body:
            "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & screenshots != null & first_release_date >= $nowDate & hypes >= 25 & category = 0; limit 10; sort first_release_date desc; ");
    print("Slider2: ${response.statusCode}");
    return GameResponse.fromJson(jsonDecode(response.body));
  }

  Future<GameResponse> getSlider3() async {
    final now = DateTime.parse(DateTime.now().toString());
    var nowDate = now.millisecondsSinceEpoch;
    print(nowDate);
    //Search slider
    //Incoming espansions category = 2
    var response = await http.post(Uri.parse(mainUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Client-ID':
              'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
        },
        body:
            "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & screenshots != null & first_release_date >= $nowDate & category = 2; limit 10; sort first_release_date desc; ");
    print("Slider3: ${response.statusCode}");
    return GameResponse.fromJson(jsonDecode(response.body));
  }

  Future<GameResponse> getGames2() async {
    //juegos con mas de 90 de rating recientes
    //no se utiliza de momento
    try {
      final response = await http.post(Uri.parse(mainUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Client-ID':
                'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
          },
          body:
              "fields *,cover.*,dlcs.*,dlcs.cover.*,similar_games.*,similar_games.cover.*,involved_companies.*,involved_companies.company.*,game_engines.*,game_modes.*, genres.*,keywords.*,platforms.*, platforms.platform_logo.*, player_perspectives.*,screenshots.*,videos.*;where cover.image_id != null & screenshots != null & videos != null & aggregated_rating >= 80 & rating >= 80; limit 33; sort first_release_date desc;");
      print("Juegos: ${response.statusCode}");

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return GameResponse.fromJson(data);
      } else {
        throw Exception('Error al obtener datos de la API');
      }
    } catch (error) {
      print("Exception occurred: $error");
      return GameResponse.withError("$error");
    }
  }

  Future<GameResponse> searchGame(String query) async {
    var response = await http.post(Uri.parse(mainUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Client-ID':
              'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
        },
        body:
            "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & rating > 20; limit 99; search \"$query\";");
    print("${response.statusCode}");
    return GameResponse.fromJson(jsonDecode(response.body));
  }

  Future<GameResponse> searchGenreGame(String query) async {
    var response = await http.post(Uri.parse(mainUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Client-ID':
              'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
        },
        body:
            "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & rating > 20 & genres = $query ; limit 99;");
    print("${response.statusCode}");
    return GameResponse.fromJson(jsonDecode(response.body));
  }

  Future<GameResponse> searchPlatformGame(String query) async {
    //release_dates.platform o platforms
    var response = await http.post(Uri.parse(mainUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Client-ID':
              'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
        },
        body:
            "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & total_rating > 20 & platforms = $query ; limit 99;");
    print("${response.statusCode}");
    return GameResponse.fromJson(jsonDecode(response.body));
  }
}
