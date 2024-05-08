import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:procecto2/providers/providers.dart';
import 'package:procecto2/screens/preMain_screens/login_screen.dart';
import 'package:procecto2/screens/preMain_screens/signup_screen.dart';
import 'package:procecto2/style/theme_provider.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 110, 153, 253), //fondo fondo
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Color.fromARGB(255, 83, 114, 188),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [
                    0.25, //0.15
                    1 //0.9
                  ])),

          //color:  Theme.of(context).colorScheme.background ,//Style.Colors.introGrey, //fondo real
          child: Column(
            children: [
              const SizedBox(
                height: 330,
                //color: Colors.amber,
                child:
                    Image(image: AssetImage("assets/images/gamehubFondo.png")),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Icon(
                          SimpleLineIcons.game_controller,
                          size: 70,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(height: 10),
                        const Text(
                          'Explore games',
                          style: TextStyle(
                            //color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
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
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Expand your library',
                          style: TextStyle(
                            //color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
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
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(height: 10),
                        const Text(
                          'Meet friends',
                          style: TextStyle(
                            //color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20, //100
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Welcome to GameHub!",
                    style: TextStyle(
                      //color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Popular games, new releases, incoming games \n explore and add games to your library to \n show it to your friends all of this in one app ",
                    style: TextStyle(
                      //color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //  const Color.fromARGB(255, 255, 119, 0),//color soundcloud
                      backgroundColor: Color.fromARGB(255, 83, 114, 188),
                      //const Color.fromARGB(255, 255, 167, 10),  color gamehub
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const SignupScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 250),
                        ),
                      );
                    },
                    child: const Text(
                      'Create an account',
                      style: TextStyle(
                        //color: Theme.of(context).colorScheme.background,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ), // Color del texto
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  LoginScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 250),
                        ),
                      );
                      /*
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );*/
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ), // Color del texto
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      /*Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const MainScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 250),
                        ),
                      );
                      loginProvider.signup("nickname", "Guest", "password");
                      loginProvider.login("Guest", "password");*/
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                      print("cambiado");
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
