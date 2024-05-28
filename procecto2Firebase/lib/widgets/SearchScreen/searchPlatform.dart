import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/screens/games_screens/platformSearch_screen.dart';

class DiscoverScreenWidget3 extends StatelessWidget {
  final SwitchBlocSearch _switchBlocSearch;
  final String query;

  DiscoverScreenWidget3(this._switchBlocSearch, this.query);

  void _showGrid() {
    print("Single Clicked");
    _switchBlocSearch.showGridSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exclusives',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            //_switchBlocSearch.closeSearch();
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Theme.of(context)
          .colorScheme
          .secondary, // Cambia el color de fondo del body
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
                    return PlatformSearchScreen(query);
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
