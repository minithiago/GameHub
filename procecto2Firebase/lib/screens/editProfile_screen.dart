import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:procecto2/repository/user_repository.dart';
import 'package:procecto2/services/upload_image.dart';
import 'package:procecto2/style/theme.dart' as Style;

class editAccountScreen extends StatefulWidget {
  final image;

  const editAccountScreen({super.key, this.image});

  @override
  State<editAccountScreen> createState() => _editAccountScreenState();
}

class _editAccountScreenState extends State<editAccountScreen> {
  File? imagen_to_upload;
  final TextEditingController _nicknameController = TextEditingController();

  /*Future<String?> getUserUID() async {
    // Llamamos a la función fetchUserData() para obtener los datos del usuario
    Map<String, dynamic>? userData = await UserRepository().fetchUserData();

    // Verificamos si se encontró algún usuario con el correo electrónico dado
    if (userData != null) {
      // Accedemos al valor del campo "nickname" del usuario
      String? uid = userData['uid'];

      // Devolvemos el valor del nickname
      return uid;
    } else {
      // Si no se encontró ningún usuario, devolvemos null
      return null;
    }
  }*/
  Future<String?> getUserAvatar() async {
    // Llamamos a la función fetchUserData() para obtener los datos del usuario
    Map<String, dynamic>? userData = await UserRepository().fetchUserData();

    // Verificamos si se encontró algún usuario con el correo electrónico dado
    if (userData != null) {
      // Accedemos al valor del campo "nickname" del usuario
      String? avatar = userData['avatar'];

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
    //UserRepository().storageGetAuthData();
    //FirebaseFirestore db = FirebaseFirestore.instance;
    String userEmail = "";

    User? user = FirebaseAuth.instance.currentUser;

    print(user);

    // Verifica si hay un usuario autenticado
    if (user != null) {
      // El usuario está autenticado, puedes obtener su ID
      userEmail = user.email!;
      print('email: $userEmail');
    } else {
      // No hay usuario autenticado
      print('No user logged in');
    }

    Future<XFile?> getImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      return image;
    }

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
                      2.9, // Margen a la izquierda
                  child: imagen_to_upload != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: FileImage(imagen_to_upload!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage:
                              AssetImage('assets/images/default_avatar.jpg'),
                        ),
                ),

                Positioned(
                  top: 120, // Margen arriba
                  right: 110, // Margen a la izquierda
                  child: IconButton(
                    onPressed: () async {
                      final imagen = await getImage();
                      setState(() {
                        imagen_to_upload = File(imagen!.path);
                      });
                      //final uploaded = await uploadImage(imagen_to_upload!);
                    }, //selectImage,
                    icon: const Icon(Icons.add_a_photo),
                    color: Colors.white,
                  ),
                ),

                Positioned(
                  top: 170,
                  left: 20,
                  right: 20,
                  child: Form(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nicknameController,
                            decoration: InputDecoration(
                              filled: true,
                              //enabled: true,
                              fillColor: Color.fromARGB(128, 255, 255, 255),
                              prefixIcon: Icon(Icons.person),
                              prefixIconColor: Colors.white,
                              hintText: "Enter a new nickname",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Ajusta el valor de 10.0 según sea necesario
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 300,
                  left: 30,
                  right: 30,
                  child: SizedBox(
                    height: 50, // Establece la altura deseada del botón
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        String? profilePic;
                        String nickname = _nicknameController.text;

                        if (imagen_to_upload != null) {
                          profilePic = await uploadImage(imagen_to_upload!);
                        } else {
                          profilePic = await getUserAvatar();
                        }
                        bool success = await UserRepository()
                            .updateUser(userEmail, nickname, profilePic!);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("User modified completed.")));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Error modifying the user.")));
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.edit, size: 24.0),
                          Text("Modify"),
                          Icon(Icons.check, size: 32.0),
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
