import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier{
    ThemeData _themeData = darkTheme;

    ThemeData get themeData => _themeData;
    

    set themeData(ThemeData themedata){
      _themeData = themedata;
      notifyListeners();
    }

    void toggleTheme() {
      if (_themeData == ligthTheme){
        themeData = darkTheme;
        print("oscuro");
        notifyListeners();

      }else {
        themeData = ligthTheme;
        print("claro");
        notifyListeners();
      }
    }
}

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color.fromARGB(255, 53, 56, 64),
    secondary: Color(0xFF20232a),
    primary: Color.fromARGB(255, 255, 255, 255),
    tertiary: Color.fromARGB(255, 41, 41, 41),
    
  )
);
ThemeData ligthTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color.fromARGB(255, 255, 255, 255),
    secondary: Color(0xFFECEFF1),//Color.fromARGB(255, 83, 114, 188), azul interesante
    primary: Color.fromARGB(255, 0, 0, 0),
    tertiary: Color.fromARGB(255, 175, 175, 175),
  )
);