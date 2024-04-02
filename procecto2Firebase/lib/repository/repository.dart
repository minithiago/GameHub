import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:procecto2/model/game_response.dart';

class GameRepository {
  static String mainUrl = "https://api.igdb.com/v4/games";
  static String releaseUrl = "https://api.igdb.com/v4/release_dates";

  final String apiKey = "vdpz4bxk5i2n66evywgfgpn9xzi5rc";

  Future<GameResponse> getGames() async {
    //Best games all time
    //sort follows desc
    try {
      final response = await http.post(Uri.parse(mainUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Client-ID':
                'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
          },
          body:
              "fields *, cover.*,game_modes.*, genres.*,platforms.*,screenshots.*,videos.*;where cover.image_id != null & aggregated_rating >= 90 ; limit 33; sort first_release_date desc;");
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

  Future<GameResponse> getSlider() async {
    final now = DateTime.parse(DateTime.now().toString());
    var nowDate = now.millisecondsSinceEpoch;
    //ultimos releases con nota mayor que 70
    var response = await http.post(Uri.parse(mainUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Client-ID':
              'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
        },
        body:
            "fields *,cover.*,game_engines.*,game_modes.*,release_dates.*, genres.*,keywords.*,platforms.*, player_perspectives.*,screenshots.*,videos.*;where cover.image_id != null & first_release_date <= $nowDate & hypes > 5 & rating >= 70 | aggregated_rating >= 70 ; limit 10; sort first_release_date desc; ");
    print("Slider: ${response.statusCode}");
    return GameResponse.fromJson(jsonDecode(response.body));
  }

  Future<GameResponse> getGames2() async {
    //juegos con mas de 90 de rating recientes
    try {
      final response = await http.post(Uri.parse(mainUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Client-ID':
                'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
          },
          body:
              "fields *,cover.*,game_engines.*,game_modes.*, genres.*,keywords.*,platforms.*, platforms.platform_logo.*, player_perspectives.*,screenshots.*,videos.*;where cover.image_id != null & screenshots != null & videos != null & aggregated_rating >= 90 ; limit 33; sort first_release_date desc;");
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
            "fields *,cover.*,game_engines.*,game_modes.*,release_dates.*, genres.*,keywords.*,platforms.*, platforms.platform_logo.*, player_perspectives.*,screenshots.*,videos.*;where cover.image_id != null & screenshots != null & videos != null & rating > 20; limit 99; search \"$query\";");
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
            "fields *,cover.*,game_engines.*,game_modes.*,release_dates.*, genres.*,keywords.*,platforms.*, platforms.platform_logo.*, player_perspectives.*,screenshots.*,videos.*;where cover.image_id != null & screenshots != null & videos != null & rating > 20 & genres = $query ; limit 99;");
    print("${response.statusCode}");
    return GameResponse.fromJson(jsonDecode(response.body));
  }

  Future<GameResponse> searchPlatformGame(String query) async {
    //esclusivos de plataforma (category0 = esxlusivo)
    //release_dates.platform o platforms
    var response = await http.post(Uri.parse(mainUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Client-ID':
              'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
        },
        body:
            "fields *,cover.*,game_engines.*,game_modes.*,release_dates.*, genres.*,keywords.*,platforms.*, platforms.platform_logo.*, player_perspectives.*,screenshots.*,videos.*;where cover.image_id != null & rating > 20 & category = 0 & platforms = $query ; limit 99;");
    print("${response.statusCode}");
    return GameResponse.fromJson(jsonDecode(response.body));
  }
}
