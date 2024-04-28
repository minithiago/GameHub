import 'package:flutter/material.dart';
import 'package:procecto2/model/user_log_data.dart';
import 'package:procecto2/providers/providers.dart';
import 'package:procecto2/repository/user_repository.dart';
import 'package:procecto2/screens/preMain_screens/intro_screen.dart';
import 'package:provider/provider.dart';
import 'package:procecto2/screens/preMain_screens/login_screen.dart';
import 'package:procecto2/screens/main_screen.dart';
//import 'package:procecto2/widgets/formatted_message.dart';
//import 'package:procecto2/widgets/screen_transitions.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: UserRepository().storageGetAuthData(),
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            if (snapshot.data![0] == '' || snapshot.data![1] == '') {
              Future.microtask(
                () {
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const IntroScreen(),
                        transitionDuration: const Duration(milliseconds: 500),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                      ),
                    );
                  }
                },
              );
            } else {
              String email = snapshot.data![0];
              String password = snapshot.data![1];
              print("Esto es el mail:");
              print(email);
              print("Esto es la pswd:");
              print(password);
              Future.microtask(() async {
                try {
                  await UserRepository().loginUser(
                    email,
                    password,
                  );
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const MainScreen(),
                        transitionDuration: const Duration(milliseconds: 500),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                      ),
                    );
                  }
                } on Exception {
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const IntroScreen(),
                        transitionDuration: const Duration(milliseconds: 500),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Error")));
                  }
                }
              });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
