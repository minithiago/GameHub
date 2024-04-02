import 'package:flutter/foundation.dart';
import 'package:procecto2/model/game.dart';

class FavoriteGamesProvider with ChangeNotifier {
  List<GameModel> _favoriteGames = [];

  List<GameModel> get favoriteGames => _favoriteGames;

  void addToFavorites(GameModel game) {
    _favoriteGames.add(game);
    notifyListeners();
  }

  void removeFavorite(GameModel game) {
    _favoriteGames.remove(game);
    notifyListeners();
  }

  // Otros métodos para manejar la lista de favoritos, como eliminar de favoritos, etc.
}
