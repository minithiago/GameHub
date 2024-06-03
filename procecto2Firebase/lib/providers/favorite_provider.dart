import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:http/http.dart' as http;

class FavoriteGamesProvider with ChangeNotifier {
  List<GameModel> _allGames = [];
  List<GameModel> _favoriteGames = [];
  List<GameModel> _wishlistGames = [];
  List<GameModel> _beatenGames = [];

  static const String _kFavoriteGamesKey = 'favorite_games';
  static const String _kWishlistGamesKey = 'wishlist_games';
  static const String _kBeatenGamesKey = 'beaten_games';
  static const String _kAllGamesKey = 'all_games';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FavoriteGamesProvider() {
    _auth.authStateChanges().listen((User? user) {
      _handleAuthStateChanged(user);
    });
    _init();
  }

  Future<void> _init() async {
    if (_auth.currentUser != null) {
      List<String> userGames =
          await getGamesForUserEmail(_auth.currentUser!.email.toString());
      GameResponse response = await libraryGames(userGames);
      _allGames = response.games;

      List<String> userGames2 = await getPlayingGamesForUserEmail(
          _auth.currentUser!.email.toString());
      GameResponse response2 = await libraryGames(userGames2);
      _favoriteGames = response2.games;

      List<String> userGames3 =
          await getWantGamesForUserEmail(_auth.currentUser!.email.toString());
      GameResponse response3 = await libraryGames(userGames3);
      _wishlistGames = response3.games;

      List<String> userGames4 =
          await getBeatenGamesForUserEmail(_auth.currentUser!.email.toString());
      GameResponse response4 = await libraryGames(userGames4);
      _beatenGames = response4.games;

      notifyListeners();
    }
  }

  List<GameModel> get allGames => _allGames;
  List<GameModel> get favoriteGames => _favoriteGames;
  List<GameModel> get wishlistGames => _wishlistGames;
  List<GameModel> get beatenGames => _beatenGames;

  void addToAllGames(GameModel game) {
    _allGames.add(game);
    _saveAllGames();
    notifyListeners();
  }

  void addToFavorites(GameModel game) {
    game.favorite = true;
    if (!_favoriteGames.contains(game)) {
      _favoriteGames.add(game);
    }
    _saveFavoriteGames();
    notifyListeners();
  }

  void removeFavorite(GameModel game) {
    game.favorite = false;
    _favoriteGames.remove(game);
    _saveFavoriteGames();
    notifyListeners();
  }

  void addToBeaten(GameModel game) {
    if (!_beatenGames.contains(game)) {
      _beatenGames.add(game);
    }
    _saveBeatenGames();
    notifyListeners();
  }

  void removeBeaten(GameModel game) {
    _beatenGames.remove(game);
    _saveBeatenGames();
    notifyListeners();
  }

  void addToWishlist(GameModel game) {
    game.wishlist = true;
    if (!_wishlistGames.contains(game)) {
      _wishlistGames.add(game);
    }
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

  void removeFromAllGames(GameModel game) {
    _saveAllGames();
    _saveFavoriteGames();
    _saveWishlistGames();
    _saveBeatenGames();
    _allGames.remove(game);
    _favoriteGames.remove(game);
    _wishlistGames.remove(game);
    _beatenGames.remove(game);
    notifyListeners();
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

  void refreshBeaten() {
    _saveBeatenGames();
    notifyListeners();
  }

  void refreshAll() {
    _saveAllGames();
    notifyListeners();
  }

  void refreshWishlist() {
    _saveWishlistGames();
    notifyListeners();
  }

  Future<void> _handleAuthStateChanged(User? user) async {
    if (user != null) {
      _init();
      await _loadFavoriteGames(user);
      await _loadWishlistGames(user);
      await _loadBeatenGames(user);
      await _loadAllGames(user);
    } else {
      _favoriteGames = [];
      _wishlistGames = [];
      _beatenGames = [];
      _allGames = [];
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

  Future<void> _loadBeatenGames(User user) async {
    String userKey = '$_kBeatenGamesKey${user.email}';
    String? beatenGamesJson = await _storage.read(key: userKey);
    if (beatenGamesJson != null && beatenGamesJson.isNotEmpty) {
      List<Map<String, dynamic>> gameListJson =
          jsonDecode(beatenGamesJson).cast<Map<String, dynamic>>();
      _beatenGames = gameListJson.map((json) {
        return GameModel.fromJson(json)..favorite = true;
      }).toList();
    } else {
      _beatenGames = [];
    }
    notifyListeners();
  }

  Future<void> _loadAllGames(User user) async {
    String userKey = '$_kAllGamesKey${user.email}';
    String? allGamesJson = await _storage.read(key: userKey);
    if (allGamesJson != null && allGamesJson.isNotEmpty) {
      List<Map<String, dynamic>> gameListJson =
          jsonDecode(allGamesJson).cast<Map<String, dynamic>>();
      _allGames = gameListJson.map((json) {
        return GameModel.fromJson(json)..favorite = true;
      }).toList();
    } else {
      _allGames = [];
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

  Future<void> _saveBeatenGames() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    String userKey = '$_kBeatenGamesKey${user.email}';
    String beatenGamesJson =
        jsonEncode(_beatenGames.map((game) => game.toJson()).toList());
    await _storage.write(key: userKey, value: beatenGamesJson);
  }

  Future<void> _saveAllGames() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    String userKey = '$_kAllGamesKey${user.email}';
    String AllGamesJson =
        jsonEncode(_allGames.map((game) => game.toJson()).toList());
    await _storage.write(key: userKey, value: AllGamesJson);
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

Future<List<String>> getGamesForUserEmail(String userEmail) async {
  try {
    // Obtener la referencia al documento del usuario en Firestore utilizando su email
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: userEmail)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      String userId = userSnapshot.docs.first.id;
      // Obtener la referencia a la subcolección "Games" del usuario
      QuerySnapshot gamesSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Games')
          .get();

      // Extraer los IDs de los juegos
      List<String> gameIds = gamesSnapshot.docs.map((doc) {
        // Obtener el campo "id" de cada documento en la subcolección "Games"
        return doc['id']
            .toString(); // Ajusta esto según la estructura de tus documentos
      }).toList();

      return gameIds;
    } else {
      print(
          'No se encontró ningún usuario con el correo electrónico $userEmail.');
      return [];
    }
  } catch (e) {
    print('Error getting games for user: $e');
    return [];
  }
}

Future<List<String>> getPlayingGamesForUserEmail(String userEmail) async {
  try {
    // Obtener la referencia al documento del usuario en Firestore utilizando su email
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: userEmail)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      String userId = userSnapshot.docs.first.id;
      // Obtener la referencia a la subcolección "playing" dentro de "Games" del usuario
      QuerySnapshot gamesSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Games')
          .doc('playing')
          .collection('GamesList')
          .get();

      // Extraer los IDs de los juegos
      List<String> gameIds = gamesSnapshot.docs.map((doc) {
        // Obtener el campo "id" de cada documento en la subcolección "playing"
        return doc['id']
            .toString(); // Ajusta esto según la estructura de tus documentos
      }).toList();

      return gameIds;
    } else {
      print(
          'No se encontró ningún usuario con el correo electrónico $userEmail.');
      return [];
    }
  } catch (e) {
    print('Error getting games for user: $e');
    return [];
  }
}

Future<List<String>> getWantGamesForUserEmail(String userEmail) async {
  try {
    // Obtener la referencia al documento del usuario en Firestore utilizando su email
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: userEmail)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      String userId = userSnapshot.docs.first.id;
      // Obtener la referencia a la subcolección "playing" dentro de "Games" del usuario
      QuerySnapshot gamesSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Games')
          .doc('want')
          .collection('GamesList')
          .get();

      // Extraer los IDs de los juegos
      List<String> gameIds = gamesSnapshot.docs.map((doc) {
        // Obtener el campo "id" de cada documento en la subcolección "playing"
        return doc['id']
            .toString(); // Ajusta esto según la estructura de tus documentos
      }).toList();

      return gameIds;
    } else {
      print(
          'No se encontró ningún usuario con el correo electrónico $userEmail.');
      return [];
    }
  } catch (e) {
    print('Error getting games for user: $e');
    return [];
  }
}

Future<List<String>> getBeatenGamesForUserEmail(String userEmail) async {
  try {
    // Obtener la referencia al documento del usuario en Firestore utilizando su email
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: userEmail)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      String userId = userSnapshot.docs.first.id;
      // Obtener la referencia a la subcolección "playing" dentro de "Games" del usuario
      QuerySnapshot gamesSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Games')
          .doc('beaten')
          .collection('GamesList')
          .get();

      // Extraer los IDs de los juegos
      List<String> gameIds = gamesSnapshot.docs.map((doc) {
        // Obtener el campo "id" de cada documento en la subcolección "playing"
        return doc['id']
            .toString(); // Ajusta esto según la estructura de tus documentos
      }).toList();

      return gameIds;
    } else {
      print(
          'No se encontró ningún usuario con el correo electrónico $userEmail.');
      return [];
    }
  } catch (e) {
    print('Error getting games for user: $e');
    return [];
  }
}

Future<GameResponse> libraryGames(List<String> gameIds) async {
  // Construye la consulta para seleccionar los juegos que estén dentro de la lista de gameIds
  String query = gameIds.join(',');

  // Realiza la solicitud HTTP con la consulta construida
  var response = await http.post(Uri.parse("https://api.igdb.com/v4/games"),
      headers: {
        'Authorization': 'Bearer 7ke8gbpbre42gkjtpp5anax289bh6b',
        'Client-ID':
            'fpzb1wvydvjsy2hgz4i30gjvrblgra', // Reemplaza con tu ID de cliente
      },
      body:
          "fields *, cover.image_id, dlcs.name, dlcs.cover.image_id, similar_games.cover.image_id, involved_companies.company.name, language_supports.language.name, game_modes.name, genres.name, platforms.name, screenshots.image_id, artworks.image_id;where id = ($query) ; limit 99;");
  // Devuelve la respuesta del servidor en forma de GameResponse
  return GameResponse.fromJson(jsonDecode(response.body));
}
