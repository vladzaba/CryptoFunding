import 'package:crypto_funding_app/pages/adding_item_page.dart';

import 'package:crypto_funding_app/pages/login_page.dart';
import 'package:crypto_funding_app/pages/register_page.dart';

import 'package:crypto_funding_app/providers/database_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/profile_page.dart';
import 'services/authentication_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseProvider>(
            create: (context) => DatabaseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Arcade',
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        home: FirebaseAuth.instance.currentUser == null
            ? const LoginPage()
            : const HomePage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
          '/add_item': (context) => const AddingItemPage(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}
