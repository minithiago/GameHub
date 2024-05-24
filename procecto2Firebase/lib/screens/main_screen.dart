import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/screens/bottom_tab_screens/discover_screen.dart';
import 'package:procecto2/screens/bottom_tab_screens/library_screen.dart';
import 'package:procecto2/screens/bottom_tab_screens/profile_screen.dart';
import 'package:procecto2/screens/bottom_tab_screens/search_screen.dart';

class MainScreen extends StatefulWidget {
  final int currentIndex;

  const MainScreen({Key? key, required this.currentIndex}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  late PageController _pageController;
  //late SwitchBloc _switchBloc;
  //late SwitchBlocSearch _switchBlocSearch;

  GlobalKey bottomNavigationKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    //_switchBloc = SwitchBloc();
    //_switchBlocSearch = SwitchBlocSearch();
    _currentIndex = widget.currentIndex;
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  /*void _showGrid() {
    print("Grid Clicked");
    _switchBloc.showGrid();
    //_switchBlocSearch.showGridSearch();
  }

  void _showList() {
    print("List Clicked");
    _switchBloc.showList();
    //_switchBlocSearch.showListSearch();
  }
  */

  @override
  Widget build(BuildContext context) {
    _pageController.initialPage = _currentIndex;
    return Scaffold(
      backgroundColor: Theme.of(context)
          .colorScheme
          .secondary, //color del fondo de los juegos
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          elevation: 0.5,
          iconTheme: const IconThemeData(
            color: Color.fromRGBO(110, 182, 255, 1),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
      body: SizedBox.expand(
        child: PageView(
          //physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            //aqui van las paginas del bottomBar
            DiscoverScreen(SwitchBloc()),
            const SearchScreen(),
            const LibraryScreen(),
            const AccountScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        containerHeight: 60.0,
        backgroundColor: Theme.of(context)
            .colorScheme
            .background, //color de la barra de navegación
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
          //favoriteGamesProvider.loadFavoriteGames();
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            activeColor: const Color(0xFF010101),
            title: const Text(
              ' Discover',
              style: TextStyle(
                  color: Color.fromRGBO(110, 182, 255, 1), fontSize: 13.0),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Icon(
                SimpleLineIcons.game_controller,
                size: 18.0,
                color: _currentIndex == 0
                    ? const Color.fromRGBO(110, 182, 255, 1)
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          BottomNavyBarItem(
            activeColor: const Color(0xFF010101),
            title: const Text(
              ' Search',
              style: TextStyle(
                  color: Color.fromRGBO(110, 182, 255, 1), fontSize: 13.0),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Icon(
                SimpleLineIcons.magnifier,
                size: 18.0,
                color: _currentIndex == 1
                    ? const Color.fromRGBO(110, 182, 255, 1)
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          BottomNavyBarItem(
            activeColor: const Color(0xFF010101),
            title: const Text(
              ' Library',
              style: TextStyle(
                  color: Color.fromRGBO(110, 182, 255, 1), fontSize: 13.0),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Icon(
                SimpleLineIcons.layers,
                size: 18.0,
                color: _currentIndex == 2
                    ? const Color.fromRGBO(110, 182, 255, 1)
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          BottomNavyBarItem(
            activeColor: const Color(0xFF010101),
            title: const Text(
              ' Profile',
              style: TextStyle(
                  color: Color.fromRGBO(110, 182, 255, 1), fontSize: 13.0),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Icon(
                SimpleLineIcons.user,
                size: 18.0,
                color: _currentIndex == 3
                    ? const Color.fromRGBO(110, 182, 255, 1)
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
