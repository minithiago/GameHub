import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/repository/repository.dart';
import 'package:rxdart/subjects.dart';

class GetGamesBloc9 {
  final GameRepository _repository = GameRepository();
  final BehaviorSubject<GameResponse> _subject =
      BehaviorSubject<GameResponse>();

  getlibraryGames(List<String> gameIds) async {
    GameResponse response = await _repository.libraryGames(gameIds);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<GameResponse> get subject => _subject;
}

final getlibraryGames = GetGamesBloc9();
