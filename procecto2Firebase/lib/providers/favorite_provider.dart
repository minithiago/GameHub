import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:procecto2/model/game.dart'; // Asegúrate de importar tu modelo GameModel aquí

class FavoriteGamesProvider with ChangeNotifier {
  List<GameModel> _favoriteGames = [];
  static const String _kFavoriteGamesKey = 'favorite_games';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

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

  void refreshFavorites() {
    notifyListeners();
  }

  Future<void> _loadFavoriteGames() async {
    String? favoriteGamesJson = await _storage.read(key: _kFavoriteGamesKey);
    if (favoriteGamesJson != null && favoriteGamesJson.isNotEmpty) {
      // Convierte el JSON de la lista de juegos a una lista de objetos GameModel
      List<Map<String, dynamic>> gameListJson =
          jsonDecode(favoriteGamesJson).cast<Map<String, dynamic>>();
      _favoriteGames =
          gameListJson.map((json) => GameModel.fromJson(json)).toList();
    }
    notifyListeners();
  }

  Future<void> _saveFavoriteGames() async {
    // Convierte la lista de objetos GameModel a JSON y luego guárdala
    String favoriteGamesJson = jsonEncode(_favoriteGames);
    await _storage.write(key: _kFavoriteGamesKey, value: favoriteGamesJson);
  }
}
