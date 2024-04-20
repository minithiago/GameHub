import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/repository/repository.dart';
import 'package:rxdart/subjects.dart';

class GetGamesBloc2 {
  final GameRepository _repository = GameRepository();
  final BehaviorSubject<GameResponse> _subject =
      BehaviorSubject<GameResponse>();

  getBestGames() async {
    GameResponse response = await _repository.getBestGames();
    _subject.sink.add(response);
  }

  getSearchedGames(String query) async {
    GameResponse response = await _repository.searchGame(query);
    _subject.sink.add(response);
  }

  getPlatformSearchedGames(String query) async {
    GameResponse response = await _repository.searchPlatformGame(query);
    _subject.sink.add(response);
  }

  getGenreSearchedGames(String query) async {
    GameResponse response = await _repository.searchGenreGame(query);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<GameResponse> get subject => _subject;
}

final getGamesBloc2 = GetGamesBloc2();
