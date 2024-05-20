import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/model/userModel.dart';
//import 'package:procecto2/providers/login_provider.dart';
import 'package:procecto2/repository/user_repository.dart';
import 'package:procecto2/screens/preMain_screens/login_screen.dart';
import 'package:procecto2/screens/main_screen.dart';
import 'package:procecto2/services/upload_image.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  File? imagen_to_upload;

  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    //final loginProvider = Provider.of<LoginProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Create your account'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Color.fromRGBO(110, 182, 255, 1),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.35, 1])),
          child: Center(
            child: Stack(
              children: [
                /*
              const Positioned(
                top: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "Create your account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              */
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
                  left: MediaQuery.of(context).size.width /
                      1.6, // Margen a la izquierda
                  child: IconButton(
                    onPressed: () async {
                      final imagen = await getImage();
                      setState(() {
                        imagen_to_upload = File(imagen!.path);
                      });
                      final uploaded = await uploadImage(imagen_to_upload!);
                    },
                    //selectImage,
                    icon: const Icon(Icons.add_a_photo),
                    //color: Colors.white,
                  ),
                ),
                Positioned(
                  top: 160,
                  left: 10,
                  right: 10,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          TextFormField(
                            //maxLength: 30,
                            controller: _nicknameController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(
                                  '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                            ],
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "The field cannot be empty.";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(128, 255, 255, 255),
                              prefixIcon: const Icon(Icons.person),
                              //prefixIconColor: Colors.white,
                              labelText: "Username",
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
                            controller: _emailController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(
                                  '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z][a-zA-Z]+")
                                  .hasMatch(value!)) {
                                return "The email format is not valid.";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(128, 255, 255, 255),
                              prefixIcon: const Icon(Icons.mail),
                              //prefixIconColor: Colors.white,
                              labelText: "Email",
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
                            controller: _passwordController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            obscureText: true,
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.length < 8) {
                                return "The password must be at least 8 characters.";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(128, 255, 255, 255),
                              prefixIcon: const Icon(Icons.lock_outline),
                              //prefixIconColor: Colors.white,
                              labelText: "Password",
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
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            obscureText: true,
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.length < 8) {
                                return "The password must be at least 8 characters.";
                              } else if (value != _passwordController.text) {
                                return "Passwords do not match.";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(128, 255, 255, 255),
                              prefixIcon: Icon(Icons.lock_outline),
                              //prefixIconColor: Colors.white,
                              labelText: "Confirm Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Ajusta el valor de 10.0 según sea necesario
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    String email = _emailController.text;
                                    String password = _passwordController.text;
                                    String nickname = _nicknameController.text;
                                    String? profilePic;

                                    if (imagen_to_upload != null) {
                                      profilePic =
                                          await uploadImage(imagen_to_upload!);
                                    } else {
                                      profilePic = "";
                                    }

                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: buildLoadingWidget(),
                                        );
                                      },
                                    );
                                    try {
                                      UserModel user = UserModel(
                                          nickname: nickname,
                                          email: email,
                                          password: password,
                                          profilePicUrl: profilePic!);

                                      User? newUser = await UserRepository()
                                          .registerUser(email, password);

                                      if (newUser != null) {
                                        bool success = await UserRepository()
                                            .addUser(newUser.uid, nickname,
                                                email, password, profilePic);
                                        if (success) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "User register completed.")));
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  const MainScreen(
                                                currentIndex: 0,
                                              ),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              },
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Error creating the user.")));
                                          Navigator.pop(context);
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Email already in use.")));
                                        Navigator.pop(context);
                                      }
                                    } catch (e) {
                                      // Si hay alguna excepción durante el proceso de registro, muestra un mensaje de error
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "An error occurred during registration."),
                                      ));

                                      // Oculta el CircularProgressIndicator en caso de error
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(110, 182, 255, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16),
                                  // Color del texto
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                const Opacity(
                                  opacity: 0.7,
                                  child: Text(
                                    'Do you already have an account?',
                                    style: TextStyle(
                                      fontSize:
                                          13, //color: Theme.of(context).colorScheme.tertiary
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                    );
                                  },
                                  child: const Text(
                                    ' Log in.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      //color: Colors.white
                                    ),
                                  ),
                                ),
                              ],
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
