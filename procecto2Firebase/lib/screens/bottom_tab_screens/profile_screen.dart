import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:procecto2/providers/account_form_provider.dart';
import 'package:procecto2/providers/login_provider.dart';
import 'package:procecto2/screens/preMain_screens/intro_screen.dart';
import 'package:procecto2/services/config.dart';
import 'package:procecto2/services/auth_service.dart';
import 'package:procecto2/utils.dart';
import 'package:procecto2/style/theme.dart' as Style;

import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key, this.image});

  final Uint8List? image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    print(currentAccount.nickname);
    print(currentAccount.email);

    if (currentAccount.nickname == null) {
      return Scaffold(
        backgroundColor: Style.Colors.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Not registered',
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
                child: Text('Login'),
              ),
            ],
          ),
        ),
      );
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AccountFormProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
          lazy: false,
        ),
      ],
      child: Scaffold(
        backgroundColor: Style.Colors.backgroundColor,
        body: SafeArea(
          bottom: true,
          child: Center(
            child: Stack(
              children: [
                Positioned(
                  top: 30,
                  left: MediaQuery.of(context).size.width / 5,
                  child: const Text(
                    "Account information",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: 90, // Margen arriba
                  left: MediaQuery.of(context).size.width /
                      3, // Margen a la izquierda
                  child: image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(image!),
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
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(128, 255, 255, 255),
                              prefixIcon: Icon(Icons.person),
                              prefixIconColor: Colors.white,
                              labelText: currentAccount.nickname,
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
                              prefixIcon: Icon(Icons.mail),
                              prefixIconColor: Colors.white,
                              labelText: currentAccount.email,
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
                          Positioned(
                            top: 380, // Margen arriba
                            left: MediaQuery.of(context).size.width /
                                1.8, // Margen a la izquierda
                            child: FilledButton(
                              onPressed: () async {
                                currentAccount.token = "";
                                LoginProvider().logout();
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
