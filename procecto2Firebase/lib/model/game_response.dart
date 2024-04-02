import 'game.dart';

class GameResponse {
  final List<GameModel> games;
  final String error;

  GameResponse(this.games, this.error);

  GameResponse.fromJson(List json)
      : games = json.map((i) => GameModel.fromJson(i)).toList(),
        error = "";

  GameResponse.withError(String errorValue)
      : games = List<GameModel>.empty(growable: true),
        error = errorValue;
}

//prueba de library

class GameResponseLibrary {
  final List<GameModel> games;
  final String error;

  GameResponseLibrary(this.games, this.error);

  GameResponseLibrary.fromJson(List json)
      : games = json.map((i) => GameModel.fromJson(i)).toList(),
        error = "";

  GameResponseLibrary.withError(String errorValue)
      : games = List<GameModel>.empty(growable: true),
        error = errorValue;
}
