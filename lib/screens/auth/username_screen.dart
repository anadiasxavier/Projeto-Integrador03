import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../game/exploration_screen.dart';
import '../../main.dart'; 

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
      appBar: AppBar(title: const Text("Nome do Jogador")),

      body: Background(
        child: Center(
          child: SizedBox(
            width: 320,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Digite seu nome para começar a aventura",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'PressStart2P',
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                /// CAMPO NOME
                TextField(
                  controller: nomeController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.black54,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    labelText: "Seu nome",
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Escolha seu personagem",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'PressStart2P',
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 30),

                /// BOTÕES
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: generoSelecionado == "masculino"
                            ? Colors.green
                            : Colors.grey,
                        minimumSize: const Size(200, 50),
                      ),
                      onPressed: () {
                        setState(() {
                          generoSelecionado = "masculino";
                        });
                      },
                      child: const Text(
                        "Masculino",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'PressStart2P',
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: generoSelecionado == "feminino"
                            ? Colors.pink
                            : Colors.grey,
                        minimumSize: const Size(200, 50),
                      ),
                      onPressed: () {
                        setState(() {
                          generoSelecionado = "feminino";
                        });
                      },
                      child: const Text(
                        "Feminino",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'PressStart2P',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                /// BOTÃO COMEÇAR
                GestureDetector(
                  onTap: () {
                    if (nomeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Digite seu nome para continuar!",
                            style: TextStyle(
                              fontFamily: 'PressStart2P',
                              fontSize: 10,
                            ),
                          ),
                        ),
                      );
                      return;
                    }

                    ///  SALVA O GÊNERO 
                    generoJogador = generoSelecionado;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExplorationScreen(),
                      ),
                    );
                  },

                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 28,
                        ),

                        const SizedBox(width: 10),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Começar aventura",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                fontFamily: 'PressStart2P',
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "Entrar no jogo",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
