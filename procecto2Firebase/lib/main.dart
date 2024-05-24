import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procecto2/firebase_options.dart';
import 'package:procecto2/screens/auth_screens/check_auth_screen.dart';
import 'package:procecto2/services/switch_games.dart';
import 'package:procecto2/style/theme_provider.dart';
import 'package:provider/provider.dart';
import 'providers/providers.dart';

///***********************************///
///                                   ///
///                                   ///
///        Autor: Ivan naranjo        ///
///                                   ///
///                                   ///
///***********************************///

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FavoriteGamesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SwitchState(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    themeProvider.loadThemePreference();

    return MaterialApp(
      title: 'GameHub',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      home: const CheckAuthScreen(),
    );
  }
}
