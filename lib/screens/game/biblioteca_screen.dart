import 'package:flutter/material.dart';
import '../../widgets/background.dart';

class BibliotecaScreen extends StatelessWidget {
  const BibliotecaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biblioteca"),
      ),

      body: Background(
        imagem: "assets/biblioteca.png",
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [

              Text(
                "Biblioteca",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Você entrou na biblioteca silenciosa do campus...",
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