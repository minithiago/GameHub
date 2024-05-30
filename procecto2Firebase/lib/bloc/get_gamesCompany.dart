import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/repository/repository.dart';
import 'package:rxdart/subjects.dart';
/*
class GetGamesBloc9 {
  final GameRepository _repository = GameRepository();
  final BehaviorSubject<GameResponse> _subject =
      BehaviorSubject<GameResponse>();

  getCompanySearchedGames(String query) async {
    GameResponse response = await _repository.searchCompany(query);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<GameResponse> get subject => _subject;
}

final getGamesBlocCompany = GetGamesBloc9();*/

class GetGamesBloc9 {
  final BehaviorSubject<GameResponse> _subject9 =
      BehaviorSubject<GameResponse>();
  final BehaviorSubject<bool> _loadingSubject9 = BehaviorSubject<bool>();
  int _offset9 = 0;
  List<GameModel> _allGames9 = [];
  final GameRepository _repository9 = GameRepository();

  bool _isLoading = false;

  Stream<bool> get loadingStream => _loadingSubject9.stream;

  void getGamesCompany(String query) async {
    _offset9 = 0;
    _setLoading(true);
    GameResponse response =
        await _repository9.searchCompany(query, offset: _offset9);
    _allGames9 = response.games;
    _subject9.sink.add(GameResponse(_allGames9, ''));
    _setLoading(false);
  }

  void getMoreGamesCompany(String query) async {
    if (_isLoading) return;
    _setLoading(true);
    _offset9 += 17; // Incrementa el offset para la siguiente carga
    GameResponse response =
        await _repository9.searchCompany(query, offset: _offset9);
    if (response.games.isNotEmpty) {
      _allGames9.addAll(response.games);
      _subject9.sink.add(GameResponse(_allGames9, ''));
    }
    _setLoading(false);
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    _loadingSubject9.sink.add(isLoading);
  }

  void dispose3() {
    _subject9.close();
    _loadingSubject9.close();
  }

  BehaviorSubject<GameResponse> get subject => _subject9;
}

final getGamesBlocCompany = GetGamesBloc9();
