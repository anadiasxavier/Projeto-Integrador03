import 'package:flutter/material.dart';
import '../../widgets/background.dart';

class PracaScreen extends StatelessWidget {
  const PracaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text("Praça de Alimentação"),
      backgroundColor: const Color.fromARGB(255, 0, 19, 48), // azul escuro
      foregroundColor: Colors.white, // texto + ícone branco
       ),

      body: Background(
        imagem: "assets/praca.png",
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [

              Text(
                "Praça de Alimentação",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Mesas vazias e luzes apagadas...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}