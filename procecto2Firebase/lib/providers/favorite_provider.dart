import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:procecto2/model/game.dart'; // Asegúrate de importar tu modelo GameModel aquí

class FavoriteGamesProvider with ChangeNotifier {
  List<GameModel> _favoriteGames = [];
  List<GameModel> _wishlistGames = [];
  static const String _kFavoriteGamesKey = 'favorite_games';
  static const String _kWishlistGamesKey = 'wishlist_games';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<GameModel> get favoriteGames => _favoriteGames;
  List<GameModel> get wishlistGames => _wishlistGames;

  FavoriteGamesProvider() {
    _auth.authStateChanges().listen((User? user) {
      _handleAuthStateChanged(user);
    });
  }

  void addToFavorites(GameModel game) {
    game.favorite = true;
    _favoriteGames.add(game);
    _saveFavoriteGames();
    notifyListeners();
  }

  void removeFavorite(GameModel game) {
    game.favorite = false;
    _favoriteGames.remove(game);
    _saveFavoriteGames();
    notifyListeners();
  }

  void addToWishlist(GameModel game) {
    game.wishlist = true;
    _wishlistGames.add(game);
    _saveWishlistGames();
    notifyListeners();
  }

  void removeWishlist(GameModel game) {
    game.wishlist = false;
    _wishlistGames.remove(game);
    _saveWishlistGames();
    notifyListeners();
  }

  void removeFavoriteByName(String gameName) {
    GameModel? gameToRemove = _favoriteGames.firstWhere(
      (game) => game.name == gameName,
    );

    if (gameToRemove != null) {
      gameToRemove.favorite = false;
      _favoriteGames.remove(gameToRemove);
      _saveFavoriteGames();
      notifyListeners();
    }
  }

  void removeWishlistByName(String gameName) {
    GameModel? gameToRemove = _wishlistGames.firstWhere(
      (game) => game.name == gameName,
    );

    if (gameToRemove != null) {
      gameToRemove.wishlist = false;
      _wishlistGames.remove(gameToRemove);
      _saveWishlistGames();
      notifyListeners();
    }
  }

  void refreshFavorites() {
    _saveFavoriteGames();
    notifyListeners();
  }

  void refreshWishlist() {
    _saveWishlistGames();
    notifyListeners();
  }

  Future<void> _handleAuthStateChanged(User? user) async {
    if (user != null) {
      await _loadFavoriteGames(user);
      await _loadWishlistGames(user);
    } else {
      _favoriteGames = [];
      _wishlistGames = [];
      notifyListeners();
    }
  }

  Future<void> _loadFavoriteGames(User user) async {
    String userKey = '$_kFavoriteGamesKey${user.email}';
    String? favoriteGamesJson = await _storage.read(key: userKey);
    if (favoriteGamesJson != null && favoriteGamesJson.isNotEmpty) {
      List<Map<String, dynamic>> gameListJson =
          jsonDecode(favoriteGamesJson).cast<Map<String, dynamic>>();
      _favoriteGames = gameListJson.map((json) {
        return GameModel.fromJson(json)..favorite = true;
      }).toList();
    } else {
      _favoriteGames = [];
    }
    notifyListeners();
  }

  Future<void> _loadWishlistGames(User user) async {
    String userKey = '$_kWishlistGamesKey${user.email}';
    String? wishlistGamesJson = await _storage.read(key: userKey);
    if (wishlistGamesJson != null && wishlistGamesJson.isNotEmpty) {
      List<Map<String, dynamic>> gameListJson =
          jsonDecode(wishlistGamesJson).cast<Map<String, dynamic>>();
      _wishlistGames = gameListJson.map((json) {
        return GameModel.fromJson(json)..wishlist = true;
      }).toList();
    } else {
      _wishlistGames = [];
    }
    notifyListeners();
  }

  Future<void> _saveFavoriteGames() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    String userKey = '$_kFavoriteGamesKey${user.email}';
    String favoriteGamesJson =
        jsonEncode(_favoriteGames.map((game) => game.toJson()).toList());
    await _storage.write(key: userKey, value: favoriteGamesJson);
  }

  Future<void> _saveWishlistGames() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    String userKey = '$_kWishlistGamesKey${user.email}';
    String wishlistGamesJson =
        jsonEncode(_wishlistGames.map((game) => game.toJson()).toList());
    await _storage.write(key: userKey, value: wishlistGamesJson);
  }
}
