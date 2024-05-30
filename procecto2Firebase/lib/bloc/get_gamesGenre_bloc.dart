import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/repository/repository.dart';
import 'package:rxdart/subjects.dart';
/*
class GetGamesBloc4 {
  final GameRepository _repository = GameRepository();
  final BehaviorSubject<GameResponse> _subject =
      BehaviorSubject<GameResponse>();

  getGenreSearchedGames(String query) async {
    GameResponse response = await _repository.searchGenreGame(query);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<GameResponse> get subject => _subject;
}

final getGamesBlocGenre = GetGamesBloc4();*/

class GetGamesBloc4 {
  final BehaviorSubject<GameResponse> _subject =
      BehaviorSubject<GameResponse>();
  final BehaviorSubject<bool> _loadingSubject = BehaviorSubject<bool>();
  int _offset2 = 0;
  List<GameModel> _allGames = [];
  final GameRepository _repository3 = GameRepository();

  bool _isLoading = false;

  Stream<bool> get loadingStream => _loadingSubject.stream;

  void getGenreSearchedGames(String query) async {
    _offset2 = 0;
    _setLoading(true);
    GameResponse response =
        await _repository3.searchGenreGame(query, offset: _offset2);
    _allGames = response.games;
    _subject.sink.add(GameResponse(_allGames, ''));
    _setLoading(false);
  }

  void getMoreGenreSearchedGames(String query) async {
    if (_isLoading) return;
    _setLoading(true);
    _offset2 += 17; // Incrementa el offset para la siguiente carga
    GameResponse response =
        await _repository3.searchGenreGame(query, offset: _offset2);
    if (response.games.isNotEmpty) {
      _allGames.addAll(response.games);
      _subject.sink.add(GameResponse(_allGames, ''));
    }
    _setLoading(false);
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    _loadingSubject.sink.add(isLoading);
  }

  void dispose3() {
    _subject.close();
    _loadingSubject.close();
  }

  BehaviorSubject<GameResponse> get subject => _subject;
}

final getGamesBlocGenre = GetGamesBloc4();
