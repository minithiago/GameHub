import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/repository/user_repository.dart';

class RecoverPasswordScreen extends StatefulWidget {
  RecoverPasswordScreen({super.key});

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

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
        title: const Text('Recover password'),
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
                stops: const [
                  0.25, //0.15
                  1 //0.9
                ])),
        //color: Style.Colors.introGrey,
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
                          Icons.lock,
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
                        "Recover your password",
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
                        "We will send you an email \n to set a new password",
                        style: TextStyle(
                          //color: Colors.grey,
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
                              TextFormField(
                                controller: _emailController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(
                                      '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'\s')),
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
                                  labelText: "Enter your email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Ajusta el valor de 10.0 según sea necesario
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(110, 182, 255, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  try {
                                    // Muestra el CircularProgressIndicator mientras se procesa la solicitud
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Email sent."),
                                    ));
                                    UserRepository()
                                        .forgotPassword(_emailController.text);
                                  } on Exception catch (_) {
                                    // Oculta el CircularProgressIndicator si ocurre una excepción
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Invalid email."),
                                    ));
                                  }
                                },
                                child: const Text(
                                  'Recover',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16), // Color del texto
                                ),
                              ))
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
