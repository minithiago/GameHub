import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:procecto2/repository/user_repository.dart';
import 'package:procecto2/screens/editProfile_screen.dart';
import 'package:procecto2/screens/friends_screen.dart';
import 'package:procecto2/screens/main_screen.dart';
import 'package:procecto2/screens/preMain_screens/intro_screen.dart';
import 'package:procecto2/style/theme_provider.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int games = 0;
  int friends = 0;
  bool isLightMode = true;

  Future<String?> getUserNickname() async {
    // Llamamos a la función fetchUserData() para obtener los datos del usuario
    Map<String, dynamic>? userData = await UserRepository().fetchUserData();

    // Verificamos si se encontró algún usuario con el correo electrónico dado
    if (userData != null) {
      // Accedemos al valor del campo "nickname" del usuario
      String? nickname = userData['nickname'];

      // Devolvemos el valor del nickname
      return nickname;
    } else {
      // Si no se encontró ningún usuario, devolvemos null
      return null;
    }
  }
  Future<int?> getUserFriendsCountByEmail() async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email',
              isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id;
        QuerySnapshot friendsSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Friends')
            .get();
        friends = friendsSnapshot.size;
      } else {
        print(
            'No user with this email ${FirebaseAuth.instance.currentUser!.email.toString()}.');
      }
    } catch (e) {
      print('Error obtaining friends from user: $e');
    }
    return null;
  }

  Future<int?> getUserGamesCountByEmail() async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email',
              isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id;
        QuerySnapshot gamesSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Games')
            .get();
        games = gamesSnapshot.size;
      } else {
        print(
            'No se encontró ningún usuario con el correo electrónico ${FirebaseAuth.instance.currentUser!.email.toString()}.');
      }
    } catch (e) {
      print('Error obteniendo la cantidad de juegos del usuario: $e');
    }
    return null;
  }

  Future<String?> getUserPass() async {
    // Llamamos a la función fetchUserData() para obtener los datos del usuario
    Map<String, dynamic>? userData = await UserRepository().fetchUserData();

    // Verificamos si se encontró algún usuario con el correo electrónico dado
    if (userData != null) {
      // Accedemos al valor del campo "nickname" del usuario
      String? password = userData['password'];

      // Devolvemos el valor del nickname
      return password;
    } else {
      // Si no se encontró ningún usuario, devolvemos null
      return null;
    }
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
    return "";
  }

  @override
  Widget build(BuildContext context) {
    UserRepository().storageGetAuthData();

    //var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);
    //FirebaseFirestore db = FirebaseFirestore.instance;
    String? _password;
    String _avatar =
        'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg';
    String _nickname = ''; // Nombre predeterminado
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserRepository(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context)
            .colorScheme
            .secondary, //Style.Colors.backgroundColor,
        body: SafeArea(
          bottom: true,
          child: Center(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.secondary,
                        const Color.fromRGBO(110, 182, 255, 1)
                        //Color.fromARGB(255, 29, 166, 251)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.10, 0.8],
                    ),
                  ),
                ),
                /*
                const Positioned(
                  top: 30,
                  left: 0,
                  right: 0, // Ocupa todo el ancho disponible
                  child: Text(
                    "Account information",
                    textAlign:
                        TextAlign.center, // Centra el texto horizontalmente
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),*/
                Positioned(
                  top: 30,
                  left: MediaQuery.of(context).size.width / 3,
                  child: FutureBuilder<String?>(
                    future: getUserAvatar(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        _avatar = snapshot.data ??
                            'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg';
                      }

                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4.0),
                        ),
                        child: CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(_avatar),
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                    top: 20, // Margen arriba
                    left: 10, // Margen a la izquierda
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          // Cambia el estado del modo cada vez que se pulsa
                          isLightMode = !isLightMode;
                        });
                        // También puedes llamar a la función para cambiar el tema aquí si lo deseas
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme();
                      },
                      icon: isLightMode
                          ? const Icon(Icons.dark_mode)
                          : const Icon(Icons.light_mode),
                      // Muestra el icono correspondiente según el estado actual
                    )),

                Positioned(
                  top: 20, // Margen arriba
                  right: 10, // Margen a la izquierda
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const editAccountScreen(),
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
                    icon: const Icon(Icons.edit),
                    //color: Colors.white,
                  ),
                ),
                Positioned(
                  top: 170,
                  left: 0,
                  right: 0,
                  child: FutureBuilder<String?>(
                    future: getUserNickname(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        _nickname = snapshot.data ?? 'user';
                      }

                      return Text(
                        _nickname,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  top: 220, // Ajusta la posición vertical según necesites
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FutureBuilder<int?>(
                          future: getUserGamesCountByEmail(),
                          builder: (context, snapshot) {
                            //final nickname = snapshot.data ?? 'user'; // Obtiene el nickname o establece "user" si no hay ninguno

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainScreen(
                                                  currentIndex: 2)),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                  child: const Icon(
                                    SimpleLineIcons.game_controller,
                                    size: 60,
                                    //color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Texto con indicador de carga condicional
                                snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? const Text(
                                        '0 games',
                                        style: TextStyle(
                                            //color: Theme.of(context).colorScheme.tertiary
                                            ),
                                      ) // Muestra un indicador de carga mientras se obtiene el número de juegos
                                    : Text(
                                        '$games games',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                              ],
                            );
                          },
                        ),
                      ),
                      
                      Expanded(
                        child: FutureBuilder<int?>(
                          future: getUserFriendsCountByEmail(),
                          builder: (context, snapshot) {
                            //final nickname = snapshot.data ?? 'user'; // Obtiene el nickname o establece "user" si no hay ninguno

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FriendsScreen()),
                                );
                              },
                                  child: const Icon(
                                    SimpleLineIcons.people,
                                    size: 60,
                                    //color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Texto con indicador de carga condicional
                                snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? const Text(
                                        '0 friends',
                                        style: TextStyle(
                                            //color: Theme.of(context).colorScheme.tertiary
                                            ),
                                      ) // Muestra un indicador de carga mientras se obtiene el número de juegos
                                    : Text(
                                        '$friends friends',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 290,
                  left: 20,
                  right: 20,
                  child: Form(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 50),
                          SizedBox(
                            height: 90,
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.tertiary,
                                prefixIcon: Icon(Icons.mail),
                                prefixIconColor:
                                    Theme.of(context).colorScheme.primary,
                                hintText: FirebaseAuth
                                    .instance.currentUser!.email
                                    .toString(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          //SizedBox(height: 20),
                          FutureBuilder<String?>(
                            future: getUserPass(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                _password = snapshot.data ?? 'Password';
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                _password = snapshot.data ?? 'Password';
                              }
                              return TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock_outline),
                                  prefixIconColor:
                                      Theme.of(context).colorScheme.primary,
                                  filled: true,
                                  fillColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  hintText: _password,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 100),
                          SizedBox(
                            height: 50,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                                UserRepository().logout();
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const IntroScreen(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.exit_to_app, size: 24.0),
                                  Text(
                                    "Logout",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(Icons.arrow_right, size: 32.0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //aqui va los texts
              ],
            ),
          ),
        ),
      ),
    );
  }
}
