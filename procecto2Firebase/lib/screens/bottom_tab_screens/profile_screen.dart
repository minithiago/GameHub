import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:procecto2/providers/account_form_provider.dart';
import 'package:procecto2/providers/favorite_provider.dart';
import 'package:procecto2/providers/login_provider.dart';
import 'package:procecto2/repository/user_repository.dart';
import 'package:procecto2/screens/preMain_screens/intro_screen.dart';
import 'package:procecto2/utils.dart';
import 'package:procecto2/style/theme.dart' as Style;

import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  final image;

  const AccountScreen({super.key, this.image});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

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
  }

  @override
  Widget build(BuildContext context) {
    UserRepository().storageGetAuthData();
    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? _password;

    /*if (LoginProvider.currentUser.email == "Guest") {
      return Scaffold(
        backgroundColor: Style.Colors.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
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
      ],
      child: Scaffold(
        backgroundColor: Style.Colors.backgroundColor,
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
                        return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtiene el nickname
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
                  top: 120, // Margen arriba
                  left: MediaQuery.of(context).size.width /
                      1.8, // Margen a la izquierda
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                    color: Colors.white,
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
                        return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtiene el nickname
                      } else {
                        final nickname = snapshot.data ??
                            'user'; // Obtiene el nickname o establece "user" si no hay ninguno
                        return Text(
                          nickname,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
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
                        child: Column(
                          children: [
                            const Icon(
                              SimpleLineIcons.game_controller,
                              size: 60,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${favoriteGamesProvider.favoriteGames.length} games',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                        child: Column(
                          children: [
                            Icon(
                              SimpleLineIcons.people,
                              size: 60,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '3 friends',
                              style: TextStyle(color: Colors.grey),
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
                              prefixIconColor: Colors.white,
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
                                  return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtiene el nickname
                                } else {
                                  _password = snapshot.data ??
                                      'Password'; // Obtiene el nickname o establece "user" si no hay ninguno
                                  return TextField(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.lock_outline),

                                      prefixIconColor: Colors.white,
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
                            height: 200,
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
