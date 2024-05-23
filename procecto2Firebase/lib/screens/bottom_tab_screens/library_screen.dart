import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/repository/user_repository.dart';
import 'package:procecto2/screens/friends_screen.dart';
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

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    String _avatar =
        'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*const Positioned(
              left: 60,
              top: 50,
              child: Visibility(
                visible: true,
                child: Icon(
                  Icons.notification_important,
                  size: 27,
                  color: Colors.yellow,
                ),
              )),*/

          Container(
            color: Theme.of(context).colorScheme.secondary,
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                FutureBuilder<String?>(
                  future: getUserAvatar(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      _avatar = snapshot.data ??
                          "https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg";
                    }

                    return CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(_avatar),
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
                const Spacer(), // Agregado para ocupar el espacio restante en la fila
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const FriendsScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 250),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.people,
                    size: 30,
                    //color: Colors.white,
                  ),
                ),
              ],
            ),
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

          Expanded(
            child: LibraryScreenWidget(
              switchBloc,
            ),
          )

          // Add more widgets for the rest of your content here
        ],
      ),
    );
  }
}
