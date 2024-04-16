import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:procecto2/forms/login_form.dart';
//import 'package:procecto2/providers/login_form_provider.dart';
import 'package:procecto2/providers/login_provider.dart';
import 'package:procecto2/screens/main_screen.dart';
import 'package:procecto2/screens/preMain_screens/signup_screen.dart';
//import 'package:procecto2/services/auth_service.dart';

//import 'package:procecto2/widgets/gameHub_logo.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
//import '../widgets/widgets.dart';
import 'package:procecto2/style/theme.dart' as Style;

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: true);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginFormProvider()),
        ],
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
            title: Text('Log in'),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          body: SafeArea(
              child: Container(
            color: Style.Colors.introGrey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Hello again!",
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
                            "We are glad to see you again! \n Continue with your account",
                            style: TextStyle(
                              color: Colors.grey,
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

                                  Password(
                                      passwordController: _passwordController),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          /*istentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: RequestPasswordScreen(),
                                        withNavBar: false,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.fade,
                                      );
                                      */
                                        },
                                        child: const Text(
                                          'I forgot my password ',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // ROW - REGISTER
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Opacity(
                                          opacity: 0.7,
                                          child: Text(
                                            'No account? ',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignupScreen()),
                                            );
                                          },
                                          child: const Text(
                                            ' Create one.',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              LoginButton(
                                formKey: _formKey,
                                emailController: _emailController,
                                passwordController: _passwordController,
                                loginProvider: loginProvider,
                              ),
                            ],
                          ),
                        ),
                      ),

                      /* GOOGLE SIGN IN
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: FilledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String email = _emailController.text;
                            String password = _passwordController.text;

                            try {
                              bool? connected =
                                  await userProvider.login(email, password);
                              if (connected != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainScreen()),
                                );
                                ;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('bannedAccount')));
                              }
                            } on Exception catch (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('invalidAccount')));
                            }
                          }
                        },
                        child: const Text('Login with Google'),
                      ),
                    ),
                  ),
                  */
                    ],
                  ),
                ),
              ],
            ),
          )),
        ));
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
        fillColor: Color.fromARGB(128, 255, 255, 255),
        prefixIcon: Icon(Icons.email),
        prefixIconColor: Colors.white,
        labelText: "Email",
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
        fillColor: Color.fromARGB(128, 255, 255, 255),
        prefixIcon: Icon(Icons.lock_outline),
        prefixIconColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              10.0), // Ajusta el valor de 10.0 según sea necesario
        ),
        labelText: 'Password',
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
    required this.loginProvider,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final LoginProvider loginProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: FilledButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              String email = _emailController.text;
              String password = _passwordController.text;

              try {
                bool? connected = await loginProvider.login(email, password);
                if (connected != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                }
              } on Exception catch (_) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Invalid email or password.")));
              }
            }
          },
          child: const Text('Login'),
        ));
  }
}
