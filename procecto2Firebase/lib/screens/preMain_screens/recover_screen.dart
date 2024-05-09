import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procecto2/repository/user_repository.dart';

class RecoverPasswordScreen extends StatelessWidget {
  RecoverPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          appBar: AppBar(
            backgroundColor:
                Theme.of(context).colorScheme.secondary, //background
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              //color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Recover password'),
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
                      Color.fromARGB(255, 83, 114, 188),
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
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Email(emailController: _emailController),
                                  const SizedBox(height: 30),
                                ],
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 83, 114, 188),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () async {
                                      UserRepository().forgotPassword(
                                          _emailController.text);
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
