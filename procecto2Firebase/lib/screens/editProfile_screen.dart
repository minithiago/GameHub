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

class editAccountScreen extends StatefulWidget {
  final image;

  const editAccountScreen({super.key, this.image});

  @override
  State<editAccountScreen> createState() => _editAccountScreenState();
}

class _editAccountScreenState extends State<editAccountScreen> {
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
    return "";
  }

  @override
  Widget build(BuildContext context) {
    UserRepository().storageGetAuthData();
    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? _password;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Style.Colors.introGrey, //background
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Edit"),
      ),
      body: Scaffold(
        backgroundColor: Style.Colors.backgroundColor,
        body: SafeArea(
          bottom: true,
          child: Center(
            child: Stack(
              children: [
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
                  top: 120, // Margen arriba
                  right: 110, // Margen a la izquierda
                  child: IconButton(
                    onPressed: () {}, //selectImage,
                    icon: const Icon(Icons.add_a_photo),
                    color: Colors.white,
                  ),
                ),

                Positioned(
                  top: 200,
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

                          const SizedBox(
                            height: 20,
                          ),
                          Positioned(
                            //top: 580,
                            //left: MediaQuery.of(context).size.width / 1.8,
                            child: SizedBox(
                              height:
                                  50, // Establece la altura deseada del botón
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () async {
                                  //UserRepository().logout();

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
                                    Icon(Icons.edit, size: 24.0),
                                    Text("Modify"),
                                    Icon(Icons.check, size: 32.0),
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
