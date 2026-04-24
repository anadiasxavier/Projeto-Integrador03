import 'package:flutter/material.dart';
import '../../widgets/background.dart';

class MesclaScreen extends StatelessWidget {
  const MesclaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text("Mescla"),
      backgroundColor: const Color.fromARGB(255, 0, 19, 48), // azul escuro
      foregroundColor: Colors.white, // texto + ícone branco
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Voltar uma etapa',
        onPressed: () => Navigator.maybePop(context),
      ),
       ),
      body: Background(
        imagem: "assets/puc.png",
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [

              Text(
                "Mescla",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "O local está vazio, apenas o eco da noite...",
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