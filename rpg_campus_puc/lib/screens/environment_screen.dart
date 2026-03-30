import 'package:flutter/material.dart';
import '../widgets/background.dart';

class EnvironmentScreen extends StatelessWidget {

  final String ambiente;

  const EnvironmentScreen(this.ambiente, {super.key});

  @override
  Widget build(BuildContext context) {

    String titulo = "";
    String texto = "";

    if (ambiente == "biblioteca") {
      titulo = "Biblioteca";
      texto = "Você entrou na biblioteca silenciosa do campus...";
    }

    else if (ambiente == "manacas") {
      titulo = "Manacás";
      texto = "As árvores balançam no vento da noite...";
    }

    else if (ambiente == "mescla") {
      titulo = "Mescla";
      texto = "O local está vazio, apenas o eco da noite...";
    }

    else if (ambiente == "praca") {
      titulo = "Praça de Alimentação";
      texto = "Mesas vazias e luzes apagadas...";
    }

    else if (ambiente == "arena") {
      titulo = "Arena Gamer";
      texto = "Os computadores desligados iluminam fracamente o ambiente...";
    }

    return Scaffold(

      appBar: AppBar(
        title: Text(titulo),
      ),

      body: Background(

        child: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                titulo,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              Text(
                texto,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),

              SizedBox(height: 40),

              ElevatedButton(
                child: Text("Voltar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )

            ],
          ),

        ),

      ),

    );

  }
}