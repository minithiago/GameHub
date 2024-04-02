import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procecto2/providers/login_form_provider.dart';
import 'package:procecto2/providers/login_provider.dart';
import 'package:procecto2/screens/main_screen.dart';
import 'package:procecto2/screens/preMain_screens/signup_screen.dart';
import 'package:procecto2/services/auth_service.dart';
import 'package:procecto2/widgets/formatted_message.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context);

    final authService = Provider.of<AuthService>(context);

    return Form(
      key: loginFormProvider.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            children: [
              TextFormField(
                textInputAction: TextInputAction.next,
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
              ),
              const SizedBox(height: 16),
              TextFormField(
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
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
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  if (!loginFormProvider.isValidForm() ||
                      loginFormProvider.isLoading) return;
                  loginFormProvider.isLoading = true;
                  try {
                    await authService.login(
                      loginFormProvider.email,
                      loginFormProvider.password,
                    );

                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    }
                  } on Exception catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.getMessage)));
                    }
                  } finally {
                    loginFormProvider.isLoading = false;
                  }
                },
                child: loginFormProvider.isLoading
                    ? CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary)
                    : Text("Login", style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 16),
              SignUpInkwell(loginFormProvider: loginFormProvider)
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpInkwell extends StatelessWidget {
  const SignUpInkwell({
    super.key,
    required this.loginFormProvider,
  });

  final LoginFormProvider loginFormProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Opacity(opacity: 0.6, child: Text("No hay cuenta")),
        const SizedBox(width: 8),
        InkWell(
          onTap: () {
            if (!loginFormProvider.isLoading) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupScreen()),
              );
            }
          },
          child: Text("signuop"),
        ),
      ],
    );
  }
}
