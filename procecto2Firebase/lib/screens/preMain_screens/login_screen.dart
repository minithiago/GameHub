import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/repository/user_repository.dart';
import 'package:procecto2/screens/main_screen.dart';
import 'package:procecto2/screens/preMain_screens/recover_screen.dart';
import 'package:procecto2/screens/preMain_screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary, //background
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Login'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  const Color.fromRGBO(110, 182, 255, 1),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.15, 0.9])),
        //color: Theme.of(context).colorScheme.background,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.waving_hand,
                          size: 70,
                          //color: Colors.white,
                        ),
                      ]),
                  const SizedBox(
                    height: 20,
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Hello again!",
                        style: TextStyle(
                          //color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "We are glad to see you again! \n Continue with your account",
                        style: TextStyle(
                          //color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Email(emailController: _emailController),
                              const SizedBox(height: 30),

                              Password(passwordController: _passwordController),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              RecoverPasswordScreen(),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            const begin = Offset(1.0, 0.0);
                                            const end = Offset.zero;
                                            const curve = Curves.ease;

                                            var tween = Tween(
                                                    begin: begin, end: end)
                                                .chain(
                                                    CurveTween(curve: curve));
                                            var offsetAnimation =
                                                animation.drive(tween);

                                            return SlideTransition(
                                              position: offsetAnimation,
                                              child: child,
                                            );
                                          },
                                          transitionDuration:
                                              const Duration(milliseconds: 250),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'I forgot my password ',
                                      style: TextStyle(
                                        fontSize: 13,
                                        //color: Colors.white,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ROW - REGISTER
                            ],
                          ),
                          const SizedBox(height: 30),
                          LoginButton(
                            formKey: _formKey,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            //loginProvider: loginProvider,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Opacity(
                                  opacity: 0.7,
                                  child: Text(
                                    "Don't have an account?  ",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignupScreen()),
                                    );
                                  },
                                  child: const Text(
                                    'Create one',
                                    style: TextStyle(
                                      fontSize: 13,
                                      //color: Colors.white,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class Email extends StatelessWidget {
  const Email({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
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
          return 'Wrong email format';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(128, 255, 255, 255),
        prefixIcon: const Icon(Icons.email),
        //prefixIconColor: Colors.white,
        labelText: "Enter your email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              10.0), // Ajusta el valor de 10.0 según sea necesario
        ),
      ),
    );
  }
}

class Password extends StatefulWidget {
  const Password({
    super.key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.done,
      controller: widget._passwordController,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      obscureText: _obscureText,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.length < 8) {
          return 'Password should be at least 8 digits';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(128, 255, 255, 255),
        prefixIcon: const Icon(Icons.lock_outline),
        //prefixIconColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              10.0), // Ajusta el valor de 10.0 según sea necesario
        ),
        labelText: 'Enter your password',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    //required this.loginProvider,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  //final LoginProvider loginProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 55,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context)
                .colorScheme
                .primary, //const Color.fromARGB(255, 0, 136, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              String email = _emailController.text;
              String password = _passwordController.text;

              try {
                // Muestra el CircularProgressIndicator mientras se procesa la solicitud
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(
                      child: buildLoadingWidget(),
                    );
                  },
                );

                // Ejecuta el proceso de inicio de sesión
                User? newUser =
                    await UserRepository().loginUser(email, password);

                // Oculta el CircularProgressIndicator después de completar el proceso
                Navigator.pop(context);

                if (newUser != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(
                        currentIndex: 0,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Invalid email or password."),
                  ));
                }
              } on Exception catch (_) {
                // Oculta el CircularProgressIndicator si ocurre una excepción
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Invalid email or password."),
                ));
              }
            }
          },
          child: const Text(
            'Login',
            style: TextStyle(
              //color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ), // Color del texto
          ),
        ));
  }
}
