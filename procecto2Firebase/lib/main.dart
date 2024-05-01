import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procecto2/firebase_options.dart';
import 'package:procecto2/screens/auth_screens/check_auth_screen.dart';
import 'package:procecto2/style/light_theme.dart';
import 'package:procecto2/style/theme.dart';
import 'package:provider/provider.dart';
import 'providers/providers.dart';
import 'package:procecto2/style/theme.dart' as Style;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //statusBarColor: Colors.transparent,
    systemNavigationBarColor: Style.Colors.introGrey, //barra de abajo
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
      title: 'GameHub',
      debugShowCheckedModeBanner: false,
      /*theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),*/
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const CheckAuthScreen(),
    );
  }
}
