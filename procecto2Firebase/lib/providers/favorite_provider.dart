import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:procecto2/model/game.dart'; // Asegúrate de importar tu modelo GameModel aquí

class FavoriteGamesProvider with ChangeNotifier {
  List<GameModel> _favoriteGames = [];
  static const String _kFavoriteGamesKey = 'favorite_games';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    GameModel? gameToRemove =
        _favoriteGames.firstWhere((game) => game.name == gameName);

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
    final User? user = _auth.currentUser;
    if (user == null) {
      // Usuario no autenticado, no cargar favoritos
      return;
    }

    String userKey = '$_kFavoriteGamesKey${user.email}';
    String? favoriteGamesJson = await _storage.read(key: userKey);
    if (favoriteGamesJson != null && favoriteGamesJson.isNotEmpty) {
      List<Map<String, dynamic>> gameListJson =
          jsonDecode(favoriteGamesJson).cast<Map<String, dynamic>>();
      _favoriteGames = gameListJson.map((json) {
        GameModel game = GameModel.fromJson(json);
        game.favorite = true;
        return game;
      }).toList();
    }
    notifyListeners();
  }

  Future<void> _saveFavoriteGames() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      // Usuario no autenticado, no guardar favoritos
      return;
    }

    String userKey = '$_kFavoriteGamesKey${user.email}';
    String favoriteGamesJson = jsonEncode(_favoriteGames);
    await _storage.write(key: userKey, value: favoriteGamesJson);
  }
}
