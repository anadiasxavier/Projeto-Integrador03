import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'screens/auth/start_screen.dart';
import 'screens/game/exploration_screen.dart';

// Guarda info globais do jogador
//O main.dart é só o lugar onde elas ficam guardadas para todo mundo acessar

String generoJogador = "masculino";
String nomeJogador = "";
String raJogador = '';

// Inicializa o app e conecta ao Firebase:
void main() async {
  // Garante que o flutter está pronto
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

// Inicia o app de fato
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Registra a ExplorationScreen com um nome fixo pra navegação
      routes: {
        ExplorationScreen.routeName: (context) =>
            const ExplorationScreen(),
      },
      // Define a primeira tela que o jogador vê
      home: const StartScreen(),
    );
  }
}