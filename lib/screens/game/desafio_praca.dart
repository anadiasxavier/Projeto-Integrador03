// arquivo: desafio_praca_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import 'narrador_screen.dart';
import 'praca_screen.dart';

class DesafioPracaScreen extends StatefulWidget {
  const DesafioPracaScreen({super.key});

  @override
  State<DesafioPracaScreen> createState() => _DesafioPracaScreenState();
}

class _DesafioPracaScreenState extends State<DesafioPracaScreen> {
  // Lógica do quebra-cabeça aqui
  bool _resolvido = false;

  void _verificarResolucao() {
    // Substitua pela lógica real do puzzle
    // Se acertou:
    if (_resolvido) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PracaAlimentacaoScreen.telaAcerto(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PracaAlimentacaoScreen.telaErro(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Desafio dos Restos"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
      ),
      body: Background(
        imagem: "assets/praca.png",
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "REORGANIZE AS PEÇAS",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'PressStart2P',
                ),
              ),
              const SizedBox(height: 30),
              // Seu widget de puzzle aqui
              const Text(
                "[QUEBRA-CABEÇA AQUI]",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _verificarResolucao,
                child: const Text("Tentar Resolver"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}