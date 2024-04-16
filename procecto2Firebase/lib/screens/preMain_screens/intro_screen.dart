import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:procecto2/providers/providers.dart';
//import 'package:procecto2/model/user_log_data.dart';
import 'package:procecto2/screens/preMain_screens/login_screen.dart';
import 'package:procecto2/screens/main_screen.dart';
import 'package:procecto2/screens/preMain_screens/signup_screen.dart';
import 'package:procecto2/widgets/gameHub_logo.dart';
import 'package:provider/provider.dart';
import '../../widgets/widgets.dart';
import 'package:procecto2/style/theme.dart' as Style;

class IntroScreen extends StatelessWidget {
  const IntroScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Style.Colors.introGrey,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: Style.Colors.introGrey,
          child: Column(
            children: [
              const GameHub(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Icon(
                          SimpleLineIcons.game_controller,
                          size: 70,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Explore games',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Icon(
                          SimpleLineIcons.layers,
                          size: 70,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Expand your library',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Icon(
                          SimpleLineIcons.people,
                          size: 70,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Meet friends',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Welcome to GameHub",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Most popular games, new releases, incoming games \n add games to your library all of this in one app ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.white, fontSize: 16), // Color del texto
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                          color: Colors.white, fontSize: 16), // Color del texto
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                      loginProvider.signup("nickname", "Guest", "password");
                      loginProvider.login("Guest", "password");
                    },
                    child: const Text(
                      "Continue without account",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
