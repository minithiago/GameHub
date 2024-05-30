import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/repository/repository.dart';
import 'package:rxdart/subjects.dart';

class GetGamesBloc {
  final BehaviorSubject<GameResponse> _subject =
      BehaviorSubject<GameResponse>();
  final BehaviorSubject<bool> _loadingSubject = BehaviorSubject<bool>();
  int _offset = 0;
  List<GameModel> _allGames = [];
  final GameRepository _repository = GameRepository();

  bool _isLoading = false;

  Stream<GameResponse> get subject => _subject.stream;
  Stream<bool> get loadingStream => _loadingSubject.stream;

  void getGames() async {
    _offset = 0;
    _setLoading(true);
    GameResponse response = await _repository.getGamesDiscover(offset: _offset);
    _allGames = response.games;
    _subject.sink.add(GameResponse(_allGames, ''));
    _setLoading(false);
  }

  void getMoreGames() async {
    if (_isLoading) return;
    _setLoading(true);
    _offset += 12; // Incrementa el offset para la siguiente carga
    GameResponse response = await _repository.getGamesDiscover(offset: _offset);
    if (response.games.isNotEmpty) {
      _allGames.addAll(response.games);
      _subject.sink.add(GameResponse(_allGames, ''));
    }
    _setLoading(false);
    print('pidiendo');
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    _loadingSubject.sink.add(isLoading);
  }

  void dispose() {
    _subject.close();
    _loadingSubject.close();
  }

  /*
  getGames() async {
    GameResponse response = await _repository.getGamesDiscover();
    _subject.sink.add(response);
  }

  getGames2() async {
    GameResponse response = await _repository.getGamesDiscover2();
    _subject.sink.add(response);
  }
*/
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
}

final getGamesBloc = GetGamesBloc();

class GetGamesBloc2 {
  final BehaviorSubject<GameResponse> _subject =
      BehaviorSubject<GameResponse>();
  final BehaviorSubject<bool> _loadingSubject = BehaviorSubject<bool>();
  int _offset2 = 0;
  List<GameModel> _allGames = [];
  final GameRepository _repository = GameRepository();

  bool _isLoading = false;

  Stream<GameResponse> get subject => _subject.stream;
  Stream<bool> get loadingStream => _loadingSubject.stream;

  void getGames2() async {
    _offset2 = 0;
    _setLoading(true);
    GameResponse response =
        await _repository.getGamesDiscover2(offset: _offset2);
    _allGames = response.games;
    _subject.sink.add(GameResponse(_allGames, ''));
    _setLoading(false);
  }

  void getMoreGames2() async {
    if (_isLoading) return;
    _setLoading(true);
    _offset2 += 24; // Incrementa el offset para la siguiente carga
    GameResponse response =
        await _repository.getGamesDiscover2(offset: _offset2);
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

  void dispose() {
    _subject.close();
    _loadingSubject.close();
  }
}

final getGamesBloc2 = GetGamesBloc2();

/*class GetGamesBloc3 {
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

final getGamesBloc3 = GetGamesBloc3();*/

class GetGamesBloc3 {
  final BehaviorSubject<GameResponse> _subject =
      BehaviorSubject<GameResponse>();
  final BehaviorSubject<bool> _loadingSubject = BehaviorSubject<bool>();
  int _offset4 = 0;
  List<GameModel> _allGames = [];
  final GameRepository _repository3 = GameRepository();

  bool _isLoading = false;

  Stream<GameResponse> get subject => _subject.stream;
  Stream<bool> get loadingStream => _loadingSubject.stream;

  void getGames3() async {
    _offset4 = 0;
    _setLoading(true);
    GameResponse response =
        await _repository3.getGamesDiscover3(offset: _offset4);
    _allGames = response.games;
    _subject.sink.add(GameResponse(_allGames, ''));
    _setLoading(false);
  }

  void getMoreGames3() async {
    if (_isLoading) return;
    _setLoading(true);
    _offset4 += 24; // Incrementa el offset para la siguiente carga
    GameResponse response =
        await _repository3.getGamesDiscover3(offset: _offset4);
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
}

final getGamesBloc3 = GetGamesBloc3();
