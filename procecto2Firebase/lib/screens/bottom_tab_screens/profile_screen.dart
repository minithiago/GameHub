
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/providers/account_form_provider.dart';
import 'package:procecto2/providers/favorite_provider.dart';
import 'package:procecto2/providers/login_provider.dart';
import 'package:procecto2/repository/user_repository.dart';
import 'package:procecto2/screens/editProfile_screen.dart';
import 'package:procecto2/screens/preMain_screens/intro_screen.dart';
import 'package:procecto2/style/theme_provider.dart';
import 'package:procecto2/style/theme.dart' as Style;

import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {

  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int games = 0;
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
    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? _password;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AccountFormProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => UserRepository(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary, //Style.Colors.backgroundColor,
        body: SafeArea(
          bottom: true,
          child: Center(
            child: Stack(
              children: [
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
                  top: 30, // Margen arriba
                  left: MediaQuery.of(context).size.width /
                      2.90, // Margen a la izquierda
                  child: FutureBuilder<String?>(
                    future: getUserAvatar(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return buildLoadingWidget(); // Muestra un indicador de carga mientras se obtiene el nickname
                      } else {
                        final avatar = snapshot.data ??
                            'assets/default_avatar.jpg'; // Obtiene el nickname o establece "user" si no hay ninguno
                        return CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(avatar),
                          //backgroundColor: Colors.amber,
                        );
                      }
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
                      Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                    }, 
                    icon: isLightMode ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
                    // Muestra el icono correspondiente según el estado actual
                  )
                ),

                Positioned(
                  top: 20, // Margen arriba
                  right: 10, // Margen a la izquierda
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const editAccountScreen()),
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return buildLoadingWidget(); // Muestra un indicador de carga mientras se obtiene el nickname
                      } else {
                        final nickname = snapshot.data ??
                            'user'; // Obtiene el nickname o establece "user" si no hay ninguno
                        return Text(
                          nickname,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            //color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
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
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return buildLoadingWidget(); // Muestra un indicador de carga mientras se obtiene el nickname
                            } else {
                              final nickname = snapshot.data ??
                                  'user'; // Obtiene el nickname o establece "user" si no hay ninguno
                              return Column(
                                children: [
                                  const Icon(
                                    SimpleLineIcons.game_controller,
                                    size: 60,
                                    //color: Colors.white,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '${games} games',
                                    style: TextStyle(
                                      //color: Theme.of(context).colorScheme.tertiary
                                      ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                      const Expanded(
                        child: Column(
                          children: [
                            Icon(
                              SimpleLineIcons.people,
                              size: 60,
                              //color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '3 friends',
                              style: TextStyle(
                                //color: Theme.of(context).colorScheme.tertiary
                              ),
                            ),
                          ],
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
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              filled: true,
                              //enabled: false,
                              fillColor: Color.fromARGB(128, 255, 255, 255),
                              prefixIcon: Icon(Icons.mail),
                              //prefixIconColor: Colors.white,
                              hintText: FirebaseAuth.instance.currentUser!.email
                                  .toString(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Ajusta el valor de 10.0 según sea necesario
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          /*
                          TextField(
                            
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(128, 255, 255, 255),
                              prefixIcon: Icon(Icons.lock_outline),
                              suffixIcon: Icon(Icons.lock_outline),
                              prefixIconColor: Colors.white,
                              hintText:"Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Ajusta el valor de 10.0 según sea necesario
                              ),
                            ),
                          ),*/
                          Positioned(
                            child: FutureBuilder<String?>(
                              future: getUserPass(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return buildLoadingWidget(); // Muestra un indicador de carga mientras se obtiene el nickname
                                } else {
                                  _password = snapshot.data ??
                                      'Password'; // Obtiene el nickname o establece "user" si no hay ninguno
                                  return TextField(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.lock_outline),

                                      //prefixIconColor: Colors.white,
                                      filled: true,
                                      fillColor:
                                          Color.fromARGB(128, 255, 255, 255),

                                      hintText:
                                          _password, // Utiliza el nickname como hintText
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 130,
                          ),
                          Positioned(
                            //top: 580,
                            //left: MediaQuery.of(context).size.width / 1.8,
                            child: SizedBox(
                              height:
                                  50, // Establece la altura deseada del botón
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
                                        builder: (context) =>
                                            const IntroScreen()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.exit_to_app, size: 24.0),
                                    Text("Logout"),
                                    Icon(Icons.arrow_right, size: 32.0),
                                  ],
                                ),
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
