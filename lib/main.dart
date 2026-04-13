import 'package:flutter/material.dart';
import 'screens/start_screen.dart';

String generoJogador = "masculino";
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );

  }
}