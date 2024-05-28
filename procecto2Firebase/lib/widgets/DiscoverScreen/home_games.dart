import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/screens/games_screens/discover_screen_grid.dart';

class DiscoverScreenWidget80 extends StatelessWidget {
  final SwitchBloc _switchBloc;

  const DiscoverScreenWidget80(this._switchBloc, {super.key});

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
                    return const DiscoverScreenGrid();
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
