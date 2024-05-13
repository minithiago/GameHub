import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/screens/games_screens/discover_screen_grid.dart';
import 'package:procecto2/screens/games_screens/discover_screen_list.dart';
import 'package:procecto2/widgets/DiscoverScreen/home_slider.dart';

class DiscoverScreen extends StatelessWidget {
  final SwitchBloc _switchBloc;

  const DiscoverScreen(this._switchBloc, {super.key});

  void _showGrid() {
    print("Single Clicked");
    _switchBloc.showGrid();
  }

  void _showList() {
    print("List Clicked");
    _switchBloc.showList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HomeSlider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "New releases".toUpperCase(),
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  //color: Colors.white,
                ),
              ),
            ),
            StreamBuilder<SwitchItem>(
              stream: _switchBloc.itemStream,
              initialData: _switchBloc.defaultItem,
              builder:
                  (BuildContext context, AsyncSnapshot<SwitchItem> snapshot) {
                switch (snapshot.data) {
                  case SwitchItem.LIST:
                    return IconButton(
                      icon: const Icon(SimpleLineIcons.list, size: 20.0),
                      //color: Colors.white,
                      onPressed: _showGrid,
                    );
                  case SwitchItem.GRID:
                    return IconButton(
                      icon: const Icon(SimpleLineIcons.grid, size: 20.0),
                      //color: Colors.white,
                      onPressed: _showList,
                    );
                  default:
                    return Container();
                }
              },
            )
          ],
        ),
        Expanded(
          child: StreamBuilder<SwitchItem>(
            stream: _switchBloc.itemStream,
            initialData: _switchBloc.defaultItem,
            builder:
                (BuildContext context, AsyncSnapshot<SwitchItem> snapshot) {
              switch (snapshot.data) {
                case SwitchItem.LIST:
                  return DiscoverScreenGrid(); // Usa la clase DiscoverScreenGrid
                case SwitchItem.GRID:
                  return DiscoverScreenList(); // Usa la clase DiscoverScreenList
                default:
                  return Container();
              }
            },
          ),
        ),
      ],
    );
  }
}
