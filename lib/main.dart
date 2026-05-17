import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'screens/auth/start_screen.dart';
import 'screens/game/exploration_screen.dart';

String generoJogador = "masculino";
String nomeJogador = "";
String raJogador = '';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      routes: {

        ExplorationScreen.routeName:
            (context) =>
                const ExplorationScreen(),
      },

      home: const StartScreen(),
    );
  }
}