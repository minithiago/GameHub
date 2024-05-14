import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:procecto2/model/game.dart'; // Asegúrate de importar tu modelo GameModel aquí

class FavoriteGamesProvider with ChangeNotifier {
  List<GameModel> _favoriteGames = [];
  static const String _kFavoriteGamesKey = 'favorite_games';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  List<GameModel> get favoriteGames => _favoriteGames;

  FavoriteGamesProvider() {
    _loadFavoriteGames();
  }

  void addToFavorites(GameModel game) {
    _favoriteGames.add(game);
    _saveFavoriteGames();
    notifyListeners();
  }

  void removeFavorite(GameModel game) {
    _favoriteGames.remove(game);
    _saveFavoriteGames();
    notifyListeners();
  }

  void removeFavoriteByName(String gameName) {
    // Busca el juego en la lista de favoritos por su nombre
    GameModel? gameToRemove =
        _favoriteGames.firstWhere((game) => game.name == gameName);

    // Si se encuentra el juego, se elimina de la lista y se guarda
    if (gameToRemove != null) {
      _favoriteGames.remove(gameToRemove);
      _saveFavoriteGames();
      notifyListeners();
    }
  }

  void refreshFavorites() {
    _saveFavoriteGames();
    notifyListeners();
  }

  Future<void> _loadFavoriteGames() async {
    String? favoriteGamesJson = await _storage.read(key: _kFavoriteGamesKey);
    if (favoriteGamesJson != null && favoriteGamesJson.isNotEmpty) {
      // Convierte el JSON de la lista de juegos a una lista de objetos GameModel
      List<Map<String, dynamic>> gameListJson =
          jsonDecode(favoriteGamesJson).cast<Map<String, dynamic>>();
      _favoriteGames = gameListJson.map((json) {
        // Convierte el JSON en un objeto GameModel
        GameModel game = GameModel.fromJson(json);
        // Establece la propiedad favorite en true para cada juego cargado
        game.favorite = true;
        return game;
      }).toList();
    }
    notifyListeners();
  }

  Future<void> _saveFavoriteGames() async {
    // Convierte la lista de objetos GameModel a JSON y luego guárdala
    String favoriteGamesJson = jsonEncode(_favoriteGames);
    await _storage.write(key: _kFavoriteGamesKey, value: favoriteGamesJson);
  }
}
