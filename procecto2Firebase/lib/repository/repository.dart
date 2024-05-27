import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:procecto2/model/game_response.dart';

class GameRepository {
  static String mainUrl = "https://api.igdb.com/v4/games";
  static String releaseUrl = "https://api.igdb.com/v4/release_dates";

  final String apiKey = "7ke8gbpbre42gkjtpp5anax289bh6b";

  Future<GameResponse> getGamesDiscover() async {
    //new releases
    //juegos con rating > 60 ;sort date desc;

    try {
      final response = await http.post(Uri.parse(mainUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Client-ID':
                'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
          },
          body: //"fields cover.*,similar_games.*,similar_games.cover.*;where cover.image_id != null & similar_games != null & total_rating >= 80 ; limit 33;"
              "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, language_supports.language.name, game_modes.name, genres.name, platforms.name, screenshots.image_id, artworks.image_id, videos.* ;where id != 192153 & cover.image_id != null & total_rating >= 50 ;sort first_release_date desc; limit 98;");
      print("Juegos New releases: ${response.statusCode}");
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

  Future<GameResponse> getGamesDiscover2() async {
    //Released this year

    var nowDate = 1704118499;

    try {
      final response = await http.post(Uri.parse(mainUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Client-ID':
                'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
          },
          body: //"fields cover.*,similar_games.*,similar_games.cover.*;where cover.image_id != null & similar_games != null & total_rating >= 80 ; limit 33;"
              "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, language_supports.language.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where id != 192153 & cover.image_id != null & total_rating >= 55 & first_release_date >= $nowDate;sort first_release_date asc ; limit 198;");
      print("Juegos released this year: ${response.statusCode}");
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

  Future<GameResponse> getGamesDiscover3() async {
    //Incoming Games
    final now = DateTime.parse(DateTime.now().toString());
    var nowDate = now.millisecondsSinceEpoch;
    var nowDate2 = nowDate ~/ 1000;

    try {
      final response = await http.post(Uri.parse(mainUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Client-ID':
                'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
          },
          body: //"fields cover.*,similar_games.*,similar_games.cover.*;where cover.image_id != null & similar_games != null & total_rating >= 80 ; limit 33;"
              "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, language_supports.language.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & screenshots != null & first_release_date >= ${nowDate2} ; sort first_release_date asc; limit 98;");
      print("Juegos incoming Games: ${response.statusCode}");
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
    //Top Rated Games
    //sort follows desc depcreated
    try {
      final response = await http.post(Uri.parse(mainUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Client-ID':
                'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
          },
          body:
              "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, language_supports.language.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & total_rating >= 89 ; limit 198; sort total_rating_count desc;");
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

  Future<GameResponse> getSliderRandomDelTO() async {
    //Discover slider games
    var response = await http.post(Uri.parse(mainUrl), headers: {
      'Authorization': 'Bearer $apiKey',
      'Client-ID':
          'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
    }, body: '''
        fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, language_supports.language.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;
        where cover.image_id != null & total_rating >= 60 ;
        limit 15 ;
      ''');
    print("Discover SliderRandom: ${response.statusCode}");

    if (response.statusCode == 200) {
      //List<dynamic> data = json.decode(response.body);
      List<dynamic> games = jsonDecode(response.body);
      var random = Random();
      List<dynamic> randomGames =
          (games.toList()..shuffle(random)).take(10).toList();
      return GameResponse.fromJson(randomGames);
    } else {
      throw Exception('Error al obtener datos de la API');
    }

    //return GameResponse.fromJson(jsonDecode(response.body));
  }

  Future<GameResponse> getSlider() async {
    final now = DateTime.parse(DateTime.now().toString());
    var nowDate = now.millisecondsSinceEpoch;
    //Discover slider games
    //hypes > 3
    var response = await http.post(Uri.parse(mainUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Client-ID':
              'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
        },
        body:
            "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, language_supports.language.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & screenshots != null & first_release_date <= $nowDate & total_rating >= 50 & dlcs >= 2; limit 10; sort rating_count desc; ");
    print("Slider: ${response.statusCode}");
    return GameResponse.fromJson(jsonDecode(response.body));
  }

  Future<GameResponse> getSlider2() async {
    final now = DateTime.parse(DateTime.now().toString());
    var nowDate = now.millisecondsSinceEpoch;
    var nowDate2 = nowDate ~/ 1000;
    //print(nowDate);
    //Search slider
    //Most anticipated HYPED GAMES
    var response = await http.post(Uri.parse(mainUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Client-ID':
              'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
        },
        body:
            "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, language_supports.language.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & screenshots != null & first_release_date >= $nowDate2 & category = 0; limit 10; sort hypes desc; ");
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
            "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, language_supports.language.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & screenshots != null & first_release_date >= $nowDate & category = 2; limit 10; sort first_release_date desc; ");
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
            "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, language_supports.language.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & rating > 20; limit 99; search \"$query\";");
    print("${response.statusCode}");
    return GameResponse.fromJson(jsonDecode(response.body));
  }

  Future<GameResponse> searchCompany(String query) async {
    var response = await http.post(Uri.parse(mainUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Client-ID':
              'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
        },
        body:
            "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, language_supports.language.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & involved_companies.company.name = $query & rating > 20; limit 99;");
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
            "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, language_supports.language.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & rating > 20 & genres = $query ; limit 99;");
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
            "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, language_supports.language.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where cover.image_id != null & total_rating > 20 & platforms = $query ; limit 99;");
    print("${response.statusCode}");
    return GameResponse.fromJson(jsonDecode(response.body));
  }

  Future<GameResponse> libraryGames(List<String> gameIds) async {
    // Construye la consulta para seleccionar los juegos que estén dentro de la lista de gameIds
    String query = gameIds.join(',');

    // Realiza la solicitud HTTP con la consulta construida
    var response = await http.post(Uri.parse(mainUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Client-ID':
              'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
        },
        body:
            "fields *, cover.*, dlcs.name, dlcs.cover.*, similar_games.cover.*, involved_companies.company.name, language_supports.language.name, game_modes.name, genres.name, platforms.name, screenshots.*, videos.* ;where id = ($query) ; limit 99;");
    // Devuelve la respuesta del servidor en forma de GameResponse
    return GameResponse.fromJson(jsonDecode(response.body));
  }
}
