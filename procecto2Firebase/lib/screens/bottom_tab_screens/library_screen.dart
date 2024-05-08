import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/repository/user_repository.dart';
import 'package:procecto2/screens/friends_screen.dart';
import 'package:procecto2/screens/main_screen.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:procecto2/widgets/LibraryScreen/librarygames.dart';
import 'package:procecto2/widgets/LibraryScreen/searchLibraryGame.dart';

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

  Future<String?> getUserAvatar() async {
    // Llamamos a la función fetchUserData() para obtener los datos del usuario
    Map<String, dynamic>? userData = await UserRepository().fetchUserData();

    // Verificamos si se encontró algún usuario con el correo electrónico dado
    if (userData != null) {
      // Accedemos al valor del campo "nickname" del usuario
      String? avatar = userData['avatar'];

      if (avatar == "") {
        return "https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg";
      }

      // Devolvemos el valor del nickname
      return avatar;
    } else if (userData == null) {
      // Si no se encontró ningún usuario, devolvemos null
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String _avatar = 'assets/default_avatar.jpg';
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
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Theme.of(context).colorScheme.secondary,
                padding: const EdgeInsets.all(20.0),
                child: Row(children: [
                  FutureBuilder<String?>(
                    future: getUserAvatar(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // Actualiza el valor de _avatar si el futuro ha completado
                        _avatar = snapshot.data ?? "https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg";
                      }

                      return Positioned(
                        top: 30, // Margen arriba
                        left: MediaQuery.of(context).size.width / 2.90, // Margen a la izquierda
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(_avatar),
                          //backgroundColor: Colors.amber,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20.0),
                  const Text(
                    'Your Library',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      //color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 90.0),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FriendsScreen()),
                      );
                    },
                    icon: const Icon(
                      Icons.people,
                      size: 28, // Tamaño más grande del icono
                      //color: Colors.white, // Color blanco del icono
                    ),
                  ),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    //color: Colors.white
                    ),
                  decoration: InputDecoration(
                    fillColor: Colors.grey,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Search your library",
                    hintStyle: const TextStyle(
                      //color: Colors.white
                      ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        print(_searchController.text);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DiscoverScreenWidget6(
                                  SwitchBlocSearch(), _searchController.text)),
                        );
                      },
                      //color: Colors.white,
                    ),
                  ),
                  onSubmitted: (_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DiscoverScreenWidget6(
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
                      OptionCard(title: 'All'),
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
              ? const Color.fromARGB(255, 28, 231, 131)
              : Theme.of(context).colorScheme.tertiary, // Cambiar el color si está seleccionado
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
                color: isSelected ? Colors.black : Colors.white, // Ca,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
