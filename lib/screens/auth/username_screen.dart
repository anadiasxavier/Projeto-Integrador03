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
      appBar: AppBar(
      title: const Text("Nome do Jogador"),
      backgroundColor: const Color.fromARGB(255, 0, 19, 48), // azul escuro
      foregroundColor: Colors.white, // texto + ícone branco
    ),

      body: Background(
        imagem: "assets/puc.png",
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
                    color:  Color.fromARGB(255, 255, 213, 0),
                    fontFamily: 'PressStart2P',
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                /// CAMPO NOME
               TextField(
                  controller: nomeController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Seu nome",
                    hintStyle: const TextStyle(color: Colors.white54),

                    filled: true,
                    fillColor: Colors.black54,

                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 204, 204, 204),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  "Escolha seu personagem",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 249, 208),
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
                            ? const Color.fromARGB(255, 195, 9, 71)
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
                    nomeJogador = nomeController.text.trim();

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
                      color: Colors.black.withValues(alpha: 0.4),
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
                                color:  Color.fromARGB(255, 255, 213, 0),
                                fontFamily: 'PressStart2P',
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "Entrar no jogo",
                              style: TextStyle(
                                fontSize: 10,
                                color: Color.fromARGB(255, 255, 249, 208),
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
