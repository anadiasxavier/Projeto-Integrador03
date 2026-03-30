import 'package:flutter/material.dart';
import '../widgets/background.dart';
import 'exploration_screen.dart';
import '../main.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {

  TextEditingController nomeController = TextEditingController();

  String generoSelecionado = "masculino";

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Nome do Jogador"),
      ),

      body: Background(

        child: Center(

          child: Container(
            width: 320,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Text(
                  "Digite seu nome para começar a aventura",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 30),

                /// CAMPO NOME
                TextField(
                  controller: nomeController,

                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: "Seu nome",
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Escolha seu personagem",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 20),

                /// BOTÕES DE GÊNERO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    ElevatedButton(
                      child: const Text("Masculino"),
                      onPressed: () {

                        setState(() {
                          generoSelecionado = "masculino";
                        });

                      },
                    ),

                    const SizedBox(width: 20),

                    ElevatedButton(
                      child: const Text("Feminino"),
                      onPressed: () {

                        setState(() {
                          generoSelecionado = "feminino";
                        });

                      },
                    ),

                  ],
                ),

                const SizedBox(height: 40),

                /// BOTÃO COMEÇAR
                ElevatedButton(

                  child: const Text("Começar aventura"),

                  onPressed: () {

                    generoJogador = generoSelecionado;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExplorationScreen(),
                      ),
                    );

                  },

                ),

              ],
            ),
          ),

        ),

      ),

    );

  }

}