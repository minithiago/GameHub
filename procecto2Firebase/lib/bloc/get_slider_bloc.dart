import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/repository/repository.dart';
import 'package:rxdart/subjects.dart';

class GetSliderBloc {
  final GameRepository _repository = GameRepository();
  final BehaviorSubject<GameResponse> _subject =
      BehaviorSubject<GameResponse>();

  getSlider() async {
    GameResponse response = await _repository.getSlider();
    _subject.sink.add(response);
  }

  getSliderSearch(String query) async {
    GameResponse response = await _repository.searchGame(query);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<GameResponse> get subject => _subject;
}

final getSliderBloc = GetSliderBloc();
