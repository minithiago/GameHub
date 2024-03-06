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
