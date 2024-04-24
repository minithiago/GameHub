import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/repository/repository.dart';
import 'package:rxdart/subjects.dart';
import 'dart:math';

class GetSliderBloc {
  final GameRepository _repository = GameRepository();
  final BehaviorSubject<GameResponse> _subject =
      BehaviorSubject<GameResponse>();

  getSliderRandom() async {

    Random random = Random();
    int randomNumber = random.nextInt(4);
    GameResponse response = await _repository.getSlider();

    switch (randomNumber) {
    case 0:
      response = await _repository.getSlider();
      break;
    case 1:
      response = await _repository.getSliderRandom();
      break;
    case 2:
      response = await _repository.getSliderRandom2();
      break;
    case 3:
      response = await _repository.getSliderRandom3();
      break;
    case 4:
      response = await _repository.getSliderRandom4();
      break;
  }

    //GameResponse response = await _repository.getSlider();
    _subject.sink.add(response);
  }

  getSlider2() async {
    GameResponse response = await _repository.getSlider2();
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
