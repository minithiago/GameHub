import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/screens/main_screen.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:procecto2/widgets/librarygames.dart';
import 'package:procecto2/widgets/searchGame.dart';

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
    /*
    if (LoginProvider.currentUser.email == "Guest") {
      return Scaffold(
        backgroundColor: Style.Colors.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Not Available without account',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              SizedBox(height: 20), // Espacio entre el texto y el botón
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IntroScreen()),
                  );
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      );
    }*/
    return Scaffold(
        backgroundColor: Style.Colors.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Style.Colors.backgroundColor,
                padding: const EdgeInsets.all(20.0),
                child: Row(children: [
                  const CircleAvatar(
                    radius: 30.0,
                    backgroundImage:
                        AssetImage('assets/images/default_avatar.jpg'),
                  ),
                  const SizedBox(width: 20.0),
                  const Text(
                    'Your Library',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 90.0),
                  IconButton(
                    onPressed: () => const MainScreen(),
                    icon: const Icon(
                      Icons.people,
                      size: 28, // Tamaño más grande del icono
                      color: Colors.white, // Color blanco del icono
                    ),
                  ),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: Colors.grey,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Search your library",
                    hintStyle: const TextStyle(color: Colors.white),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        print(_searchController.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DiscoverScreenWidget2(
                                  SwitchBlocSearch(), _searchController.text)),
                        );
                      },
                      color: Colors.white,
                    ),
                  ),
                  onSubmitted: (_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DiscoverScreenWidget2(
                              SwitchBlocSearch(), _searchController.text)),
                    );
                  },
                ),
              ),

              Center(
                child: Container(
                  //color: Colors.amber,
                  height: 70,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const <Widget>[
                      OptionCard(title: 'Owned'),
                      OptionCard(title: 'Wishlist'),
                      OptionCard(title: 'Favorites'),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height:
                    563, //MediaQuery.of(context).size.height - 280, // Altura del contenedor hasta abajo de la pantalla
                child: LibraryScreenWidget(
                  switchBloc,
                ),
              ),

              // Add more widgets for the rest of your content here
            ],
          ),
        ));
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
      child: Center(
          child: Container(
        width: 110, // Ancho de cada tarjeta de opción
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
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
