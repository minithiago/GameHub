import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/model/game.dart';
import 'package:procecto2/screens/bottom_tab_screens/profile_screen.dart';
import 'package:procecto2/screens/main_screen.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:procecto2/widgets/librarygames.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreenWidgetState createState() => _LibraryScreenWidgetState();
}

class _LibraryScreenWidgetState extends State<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  late SwitchBloc _switchBloc;

  @override
  void initState() {
    super.initState();
    _switchBloc = SwitchBloc();
  }

  void _showGrid() {
    print("Grid Clicked");
    _switchBloc.showGrid();
  }

  void _showList() {
    print("List Clicked");
    _switchBloc.showList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Style.Colors.backgroundColor,
            padding: EdgeInsets.all(20.0),
            child: Row(children: [
              const CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
              ),
              SizedBox(width: 20.0),
              const Text(
                'Your Library',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 60.0),
              IconButton(
                onPressed: () => const MainScreen(),
                icon: const Icon(
                  Icons.search,
                  size: 28, // Tamaño más grande del icono
                  color: Colors.white, // Color blanco del icono
                ),
              ),
            ]),
          ),
          Container(
              //color: Colors.amber,
              height: 70,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  const OptionCard(title: 'Favorites'),
                  OptionCard(title: 'Wishlist'),
                  OptionCard(title: 'Owned'),
                  IconButton(
                    onPressed: () => AccountScreen(),
                    icon: const Icon(
                      Icons.add,
                      size: 30, // Tamaño más grande del icono
                      color: Colors.white, // Color blanco del icono
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height -
                279, // Altura del contenedor hasta abajo de la pantalla
            child: LibraryScreenWidget(
              switchBloc,
            ),
          ),

          // Add more widgets for the rest of your content here
        ],
      ),
    );
  }
}

class OptionCard extends StatefulWidget {
  final String title;

  const OptionCard({Key? key, required this.title}) : super(key: key);

  @override
  _OptionCardState createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        width: 95, // Ancho de cada tarjeta de opción
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.orange
              : Style.Colors.introGrey, // Cambiar el color si está seleccionado
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
