import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/repository/repository.dart';
import 'package:rxdart/subjects.dart';

class GetGamesBloc {
  final GameRepository _repository = GameRepository();
  final BehaviorSubject<GameResponse> _subject =
      BehaviorSubject<GameResponse>();

  getGames() async {
    GameResponse response = await _repository.getGamesDiscover();
    _subject.sink.add(response);
  }

  getGames2() async {
    GameResponse response = await _repository.getGamesDiscover2();
    _subject.sink.add(response);
  }

  getGames3() async {
    GameResponse response = await _repository.getGamesDiscover3();
    _subject.sink.add(response);
  }

  /*

  getGames2() async {
    GameResponse response = await _repository.getGames2();
    _subject.sink.add(response);
  }

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
  */

  dispose() {
    _subject.close();
  }

  BehaviorSubject<GameResponse> get subject => _subject;
}

final getGamesBloc = GetGamesBloc();

class GetGamesBloc2 {
  final GameRepository _repository = GameRepository();
  final BehaviorSubject<GameResponse> _subject =
      BehaviorSubject<GameResponse>();

  getGames2() async {
    GameResponse response = await _repository.getGamesDiscover2();
    _subject.sink.add(response);
  }
  

  dispose() {
    _subject.close();
  }

  BehaviorSubject<GameResponse> get subject => _subject;
}

final getGamesBloc2 = GetGamesBloc2();

class GetGamesBloc3 {
  final GameRepository _repository = GameRepository();
  final BehaviorSubject<GameResponse> _subject =
      BehaviorSubject<GameResponse>();

  getGames3() async {
    GameResponse response = await _repository.getGamesDiscover3();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<GameResponse> get subject => _subject;
}

final getGamesBloc3 = GetGamesBloc3();
