import 'package:flutter/material.dart';

class Colors {
  const Colors();
  static const Color mainColor = Color.fromARGB(255, 242, 97, 1);
  static const Color backgroundColor = Color(0xFF20232a);
  static const Color starsColor = Color.fromARGB(255, 250, 204, 19);
  static const Color grey = Color(0xFFE5E5E5);
  static const Color introGrey = Color.fromARGB(255, 53, 56, 64);
  static const Color form = Color.fromARGB(128, 255, 255, 255);

  static const Color mainColorLight = Color.fromARGB(255, 242, 97, 1);
  static const Color backgroundColorLight = Color.fromARGB(255, 152, 155, 161);
  static const Color starsColorLight = Color.fromARGB(255, 250, 204, 19);
  static const Color greyLight = Color(0xFFE5E5E5);
  static const Color introGreyLight = Color.fromARGB(255, 246, 246, 246);
  static const Color black = Color.fromARGB(255, 11, 11, 11);
}

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);
