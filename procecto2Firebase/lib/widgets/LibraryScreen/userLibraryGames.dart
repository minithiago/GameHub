import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/screens/games_screens/library_screen_grid.dart';
import 'package:procecto2/screens/games_screens/library_screen_list.dart';

class UserLibraryScreenWidget extends StatefulWidget {
  final SwitchBloc _switchBloc;
  final String _usuario;

  const UserLibraryScreenWidget(this._switchBloc, this._usuario, {Key? key})
      : super(key: key);

  @override
  _UserLibraryScreenWidgetState createState() =>
      _UserLibraryScreenWidgetState();
}

class _UserLibraryScreenWidgetState extends State<UserLibraryScreenWidget> {
  String _filter = '';
  String _nameFilter = '';

  void _updateFilter(String newFilter) {
    setState(() {
      _filter = newFilter;
    });
  }

  void _applyNameFilter(String name) {
    setState(() {
      _nameFilter = name;
    });
  }

  void _showGrid() {
    print("Single Clicked");
    widget._switchBloc.showGrid();
  }

  void _showList() {
    print("List Clicked");
    widget._switchBloc.showList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: TextButton.icon(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoActionSheet(
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            onPressed: () {
                              _updateFilter('Release date');
                              Navigator.pop(context);
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Release date',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              _updateFilter('Rating');
                              Navigator.pop(context);
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Rating',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              _updateFilter('Name');
                              Navigator.pop(context);
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.abc,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Name',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.swap_vert,
                  color: Colors.white,
                ),
                label: Text(
                  _filter.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            StreamBuilder<SwitchItem>(
              stream: widget._switchBloc.itemStream,
              initialData: widget._switchBloc.defaultItem,
              builder:
                  (BuildContext context, AsyncSnapshot<SwitchItem> snapshot) {
                switch (snapshot.data) {
                  case SwitchItem.LIST:
                    return IconButton(
                      icon: const Icon(SimpleLineIcons.list, size: 18.0),
                      color: Colors.white,
                      onPressed: _showGrid,
                    );
                  case SwitchItem.GRID:
                    return IconButton(
                      icon: const Icon(SimpleLineIcons.grid, size: 18.0),
                      color: Colors.white,
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
            stream: widget._switchBloc.itemStream,
            initialData: widget._switchBloc.defaultItem,
            builder:
                (BuildContext context, AsyncSnapshot<SwitchItem> snapshot) {
              switch (snapshot.data) {
                case SwitchItem.LIST:
                  return LibraryScreenGrid(
                    filtro: _filter,
                    busqueda: _nameFilter,
                    usuario: widget._usuario,
                  );
                case SwitchItem.GRID:
                  return LibraryScreenList();
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
