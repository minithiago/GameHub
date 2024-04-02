import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:procecto2/providers/login_provider.dart';
import 'package:procecto2/screens/preMain_screens/login_screen.dart';
import 'package:procecto2/screens/main_screen.dart';
import 'package:procecto2/utils.dart';
import 'package:procecto2/widgets/gameHub_logo.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:provider/provider.dart';

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

  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Style.Colors.introGrey,
      appBar: AppBar(
        backgroundColor: Style.Colors.introGrey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Register'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Center(
          child: Stack(
            children: [
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

              Positioned(
                top: 90, // Margen arriba
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
                top: 180, // Margen arriba
                left: MediaQuery.of(context).size.width /
                    1.8, // Margen a la izquierda
                child: IconButton(
                  onPressed: selectImage,
                  icon: const Icon(Icons.add_a_photo),
                  color: Colors.white,
                ),
              ),
              Positioned(
                top: 220,
                left: 20,
                right: 20,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          maxLength: 30,
                          controller: _nicknameController,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(
                                '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                          ],
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "The field cannot be empty.";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(128, 255, 255, 255),
                            prefixIcon: Icon(Icons.person),
                            prefixIconColor: Colors.white,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            fillColor: Color.fromARGB(128, 255, 255, 255),
                            prefixIcon: Icon(Icons.mail),
                            prefixIconColor: Colors.white,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.length < 8) {
                              return "The password must be at least 8 characters.";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(128, 255, 255, 255),
                            prefixIcon: Icon(Icons.lock_outline),
                            prefixIconColor: Colors.white,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            prefixIconColor: Colors.white,
                            labelText: "Confirm Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Ajusta el valor de 10.0 según sea necesario
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  String email = _emailController.text;
                                  String password = _passwordController.text;
                                  String nickname = _nicknameController.text;

                                  if (await loginProvider.signup(
                                      nickname, email, password)) {
                                    bool? connected = await loginProvider.login(
                                        email, password);

                                    if (connected != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainScreen()),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("Error de conexión.")));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Usuario o contraseña no válidos.")));
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16), // Color del texto
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
                                      fontSize: 13, color: Colors.grey),
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
                                      fontSize: 13, color: Colors.white),
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
    );
  }
}
