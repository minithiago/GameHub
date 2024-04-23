import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/screens/games_screens/genreSearch_screen.dart';
import 'package:procecto2/style/theme.dart' as Style;

class DiscoverScreenWidget4 extends StatelessWidget {
  final SwitchBlocSearch _switchBlocSearch;
  final String query;

  DiscoverScreenWidget4(this._switchBlocSearch, this.query);

  void _showGrid() {
    print("Single Clicked");
    _switchBlocSearch.showGridSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Genre',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Style.Colors.introGrey,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            //_switchBlocSearch.closeSearch();
            Navigator.of(context).pop();
          },
        ),
      ),

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
                    return GenreSearchScreen(query);
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
