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

  @override
  Widget build(BuildContext context) {
    UserRepository().storageGetAuthData();
    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);
    FirebaseFirestore db = FirebaseFirestore.instance;

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
                      3, // Margen a la izquierda
                  child: _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage:
                              AssetImage('assets/images/default_avatar.jpg'),
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
                  child: Text(
                    textAlign: TextAlign.center,
                    db.collection("Users").get().toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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
                          TextFormField(
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
                          TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(128, 255, 255, 255),
                              prefixIcon: Icon(Icons.lock_outline),
                              prefixIconColor: Colors.white,
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Ajusta el valor de 10.0 según sea necesario
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Positioned(
                            top: 400, // Margen arriba
                            left: MediaQuery.of(context).size.width /
                                1.8, // Margen a la izquierda
                            child: FilledButton(
                              onPressed: () async {
                                UserRepository().fetchUserData();
                              },
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.exit_to_app, size: 24.0),
                                  Text("HGola"),
                                  Icon(Icons.arrow_right, size: 32.0),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 380, // Margen arriba
                            left: MediaQuery.of(context).size.width /
                                1.8, // Margen a la izquierda
                            child: FilledButton(
                              onPressed: () async {
                                UserRepository().logout();
                                //LoginProvider.currentUser.token = "";
                                //LoginProvider().logout();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const IntroScreen()),
                                    (Route<dynamic> route) => false);
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
