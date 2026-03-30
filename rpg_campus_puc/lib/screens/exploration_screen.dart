import 'package:flutter/material.dart';
import '../widgets/background.dart';
import 'environment_screen.dart';
import '../main.dart';

class ExplorationScreen extends StatelessWidget {
  const ExplorationScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Exploração do Campus"),
      ),

      body: Background(

        child: Stack(
          children: [

            /// CONTEÚDO PRINCIPAL
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Icon(
                      Icons.explore,
                      size: 80,
                      color: Colors.white,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Explorando o Campus...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Caminhe pelo campus para encontrar os\nambientes e desbloquear a história!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 30),

                    buildAmbiente(
                      context,
                      "Biblioteca Central",
                      "Vá até este local para interagir",
                      Icons.menu_book,
                      "biblioteca",
                    ),

                    buildAmbiente(
                      context,
                      "Manacás",
                      "Explore o jardim do campus",
                      Icons.coffee,
                      "manacas",
                    ),

                    buildAmbiente(
                      context,
                      "Mescla",
                      "Descubra o que aconteceu aqui",
                      Icons.laptop,
                      "mescla",
                    ),

                    buildAmbiente(
                      context,
                      "Praça de Alimentação",
                      "Talvez haja algo útil aqui",
                      Icons.restaurant,
                      "praca",
                    ),

                    buildAmbiente(
                      context,
                      "Arena Gamer",
                      "Os computadores estão silenciosos",
                      Icons.sports_esports,
                      "arena",
                    ),

                    const SizedBox(height: 80),

                  ],
                ),
              ),
            ),

            /// PERSONAGEM DO JOGADOR
            Positioned(
              bottom: 20,
              right: 20,
              child: Image.asset(
                generoJogador == "feminino"
                    ? "assets/personagemfeminina.png"
                    : "assets/personagem.png",
                height: 150,
              ),
            ),

          ],
        ),

      ),

    );
  }
}

Widget buildAmbiente(
  BuildContext context,
  String titulo,
  String descricao,
  IconData icone,
  String ambiente,
) {

  return GestureDetector(
    onTap: () {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnvironmentScreen(ambiente),
        ),
      );

    },

    child: Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 15),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
        ),
      ),

      child: Row(
        children: [

          Icon(
            icone,
            color: Colors.white,
            size: 26,
          ),

          const SizedBox(width: 14),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                descricao,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),

            ],
          )

        ],
      ),
    ),
  );
}