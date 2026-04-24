import 'package:flutter/material.dart';
import '../../widgets/background.dart';

class ManacasScreen extends StatelessWidget {
  const ManacasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text("Manacás"),
      backgroundColor: const Color.fromARGB(255, 0, 19, 48), // azul escuro
      foregroundColor: Colors.white, // texto + ícone branco
       ),

      body: Background(
        imagem: "assets/puc.png",
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Manacás",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "As árvores balançam no vento da noite...",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
