import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/screens/games_screens/gamesSearch_screen.dart';
import 'package:procecto2/screens/games_screens/search_screen_grid.dart';
import 'package:procecto2/style/theme.dart' as Style;

class DiscoverScreenWidget5 extends StatelessWidget {
  final SwitchBlocSearch _switchBlocSearch;

  DiscoverScreenWidget5(this._switchBlocSearch);

  void _showGrid() {
    print("Single Clicked");
    _switchBlocSearch.showGridSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Style.Colors.backgroundColor, // Cambia el color de fondo del body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<SwitchItem>(
              stream: _switchBlocSearch.itemStream,
              initialData: _switchBlocSearch.defaultItem,
              builder:
                  (BuildContext context, AsyncSnapshot<SwitchItem> snapshot) {
                switch (snapshot.data) {
                  case SwitchItem.LIST:
                    return SearchScreenScroll();
                  default:
                    return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
