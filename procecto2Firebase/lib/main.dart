import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procecto2/firebase_options.dart';
import 'package:procecto2/screens/auth_screens/check_auth_screen.dart';
import 'package:procecto2/style/theme_provider.dart';
import 'package:provider/provider.dart';
import 'providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent, //Color(0xFF20232a), //barra de abajo

  ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => LoginFormProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteGamesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
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
    return MaterialApp(
      //color: Colors.transparent,
      title: 'GameHub',
      debugShowCheckedModeBanner: false,
      /*theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),*/
      theme: Provider.of<ThemeProvider>(context).themeData,
      //darkTheme: darkTheme, //Provider.of<ThemeProvider>(context).themeData,
      
      //darkTheme: darkTheme,
      home: const CheckAuthScreen(),
    );
  }
}
