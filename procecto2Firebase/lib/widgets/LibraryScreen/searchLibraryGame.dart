import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/screens/games_screens/librarySearch_screen.dart';

class DiscoverScreenWidget6 extends StatelessWidget {
  final SwitchBlocSearch _switchBlocSearch;
  final String query;

  const DiscoverScreenWidget6(this._switchBlocSearch, this.query, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Results by $query',
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
                    return LibrarySearchScreenGrid(query);
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
