import 'dart:async';

enum SwitchItem { LIST, GRID }

class SwitchBloc {
  final StreamController<SwitchItem> _switchController =
      StreamController<SwitchItem>.broadcast();

  SwitchItem defaultItem = SwitchItem.LIST;

  Stream<SwitchItem> get itemStream => _switchController.stream;

  void showList() {
    _switchController.sink.add(SwitchItem.LIST);
  }

  void showGrid() {
    _switchController.sink.add(SwitchItem.GRID);
  }

  close() {
    _switchController.close();
  }
}

final switchBloc = SwitchBloc();

class SwitchBlocSearch {
  final StreamController<SwitchItem> _switchControllerSearch =
      StreamController<SwitchItem>.broadcast();

  SwitchItem defaultItem = SwitchItem.LIST;

  Stream<SwitchItem> get itemStream => _switchControllerSearch.stream;

  void showListSearch() {
    _switchControllerSearch.sink.add(SwitchItem.LIST);
  }

  void showGridSearch() {
    _switchControllerSearch.sink.add(SwitchItem.GRID);
  }

  closeSearch() {
    _switchControllerSearch.close();
  }
}

final switchBlocSearch = SwitchBloc();
