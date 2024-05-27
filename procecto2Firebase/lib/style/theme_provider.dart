import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ThemeData _themeData = darkTheme;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themedata) {
    _themeData = themedata;
    _saveThemePreference(themedata == darkTheme ? 'dark' : 'light');
    notifyListeners();
  }

  Future<void> _saveThemePreference(String theme) async {
    await _storage.write(key: 'theme', value: theme);
  }

  Future<void> loadThemePreference() async {
    final theme = await _storage.read(key: 'theme');
    if (theme == 'light') {
      themeData = ligthTheme;
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Color.fromARGB(255, 255, 255, 255),
        //statusBarColor: Color.fromARGB(255, 255, 255, 255),
      ));
    } else {
      themeData = darkTheme;
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Color.fromARGB(255, 53, 56, 64),
        //statusBarColor: Color.fromARGB(255, 53, 56, 64),
      ));
    }
  }

  void toggleTheme() {
    if (_themeData == ligthTheme) {
      themeData = darkTheme;

      _saveThemePreference('dark');
      loadThemePreference(); // Guarda el tema oscuro
    } else {
      themeData = ligthTheme;

      _saveThemePreference('light');
      loadThemePreference(); // Guarda el tema claro
    }
    notifyListeners();
  }
}

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color.fromARGB(255, 53, 56, 64),
    secondary: Color(0xFF20232a),
    primary: Color.fromARGB(255, 255, 255, 255),
    tertiary: Color.fromARGB(255, 118, 118, 118),
  ),
);
final ThemeData ligthTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color.fromARGB(255, 255, 255, 255),
    secondary:
        Color(0xFFECEFF1), //Color.fromRGBO(110, 182, 255, 1), azul interesante
    primary: Color.fromARGB(255, 21, 21, 21),
    tertiary: Color.fromARGB(255, 175, 175, 175),
  ),
);
