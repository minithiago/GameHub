import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/screens/games_screens/gamesSearch_screen.dart';

class DiscoverScreenWidget5 extends StatelessWidget {
  final SwitchBloc _switchBloc;

  DiscoverScreenWidget5(this._switchBloc);

  void _showGrid() {
    print("Single Clicked");
    _switchBloc.showGrid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context)
          .colorScheme
          .secondary, // Cambia el color de fondo del body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<SwitchItem>(
              stream: _switchBloc.itemStream,
              initialData: _switchBloc.defaultItem,
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
