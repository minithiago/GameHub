import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
//import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/providers/favorite_provider.dart';
//import 'package:procecto2/screens/bottom_tab_screens/search_screen_grid.dart';
//import 'package:procecto2/screens/bottom_tab_screens/search_screen_list.dart';
import 'package:procecto2/screens/bottom_tab_screens/discover_screen.dart';
import 'package:procecto2/screens/bottom_tab_screens/library_screen.dart';
import 'package:procecto2/screens/bottom_tab_screens/profile_screen.dart';
import 'package:procecto2/screens/bottom_tab_screens/search_screen.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';
//import 'package:procecto2/widgets/home_slider.dart';
//import 'bottom_tab_screens/discover_screen_grid.dart';
//import 'bottom_tab_screens/discover_screen_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;
  late SwitchBloc _switchBloc;
  //late SwitchBlocSearch _switchBlocSearch;

  GlobalKey bottomNavigationKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _switchBloc = SwitchBloc();
    //_switchBlocSearch = SwitchBlocSearch();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _showGrid() {
    print("Grid Clicked");
    _switchBloc.showGrid();
    //_switchBlocSearch.showGridSearch();
  }

  void _showList() {
    print("List Clicked");
    _switchBloc.showList();
    //_switchBlocSearch.showListSearch();
  }

  @override
  Widget build(BuildContext context) {
    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);
    return Scaffold(
      backgroundColor:
          Style.Colors.backgroundColor, //color del fondo de los juegos
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          elevation: 0.5,
          iconTheme: const IconThemeData(
            color: Style.Colors.mainColor,
          ),
          centerTitle: true,
          backgroundColor: Style.Colors.backgroundColor,
        ),
      ),
      body: SizedBox.expand(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
            //favoriteGamesProvider.loadFavoriteGames();
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
        backgroundColor:
            Style.Colors.introGrey, //color de la barra de navegación
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
          //favoriteGamesProvider.loadFavoriteGames();
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            activeColor: Color(0xFF010101),
            title: const Text(
              ' Discover',
              style: TextStyle(color: Colors.orange, fontSize: 13.0),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Icon(
                SimpleLineIcons.game_controller,
                size: 18.0,
                color: _currentIndex == 0 ? Colors.orange : Colors.white,
              ),
            ),
          ),
          BottomNavyBarItem(
            activeColor: Color(0xFF010101),
            title: const Text(
              ' Search',
              style: TextStyle(color: Colors.orange, fontSize: 13.0),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Icon(
                SimpleLineIcons.magnifier,
                size: 18.0,
                color: _currentIndex == 1 ? Colors.orange : Colors.white,
              ),
            ),
          ),
          BottomNavyBarItem(
            activeColor: Color(0xFF010101),
            title: const Text(
              ' Library',
              style: TextStyle(color: Colors.orange, fontSize: 13.0),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Icon(
                SimpleLineIcons.layers,
                size: 18.0,
                color: _currentIndex == 2 ? Colors.orange : Colors.white,
              ),
            ),
          ),
          BottomNavyBarItem(
            activeColor: Color(0xFF010101),
            title: const Text(
              ' Profile',
              style: TextStyle(color: Colors.orange, fontSize: 13.0),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Icon(
                SimpleLineIcons.user,
                size: 18.0,
                color: _currentIndex == 3 ? Colors.orange : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
