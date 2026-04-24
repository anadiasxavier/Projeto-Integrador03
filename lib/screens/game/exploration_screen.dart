import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import 'arena_screen.dart';
import 'biblioteca_screen.dart';
import 'manacas_screen.dart';
import 'mescla_screen.dart';
import 'praca_screen.dart';
import 'narrador_screen.dart';
import 'personagem_screen.dart';

class ExplorationScreen extends StatelessWidget {
  const ExplorationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // widget de estrutura básica da tela
      // estrutura básica da tela
      appBar: AppBar(
      title: const Text("Exploração do Campus"),
      backgroundColor: const Color.fromARGB(255, 0, 19, 48), // azul escuro
      foregroundColor: Colors.white, // texto + ícone branco
       ),

      body: Background(
        imagem: "assets/puc.png",
        child: Stack(
          children: [
            /// CONTEÚDO PRINCIPAL
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.explore, size: 80, color: Colors.white),

                    const SizedBox(height: 20),

                    const Text(
                      "Explorando o Campus...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PressStart2P',
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Defina sua localização atual e comece sua jornada!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),

                    const SizedBox(height: 30),

                    buildAmbiente(
                      context,
                      "Biblioteca",
                      "",
                      Icons.menu_book,
                      const BibliotecaScreen(),
                      "assets/biblioteca.png",
                    ),

                    buildAmbiente(
                      context,
                      "Manacás",
                      "",
                      Icons.coffee,
                      const ManacasScreen(),
                      "assets/manacas.png",
                    ),

                    buildAmbiente(
                      context,
                      "Mescla",
                      "",
                      Icons.laptop,
                      const MesclaScreen(),
                      "assets/mescla.png",
                    ),

                    buildAmbiente(
                      context,
                      "Praça de Alimentação",
                      "",
                      Icons.restaurant,
                      const PracaScreen(),
                      "assets/praca.png",
                    ),

                    buildAmbiente(
                      context,
                      "Arena Gamer",
                      "",
                      Icons.sports_esports,
                      const ArenaScreen(),
                      "assets/arena.png",
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
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
  Widget tela,
  String imagemFundo,
) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NarradorScreen(
            imagemFundo: imagemFundo,
            proximaTela: PersonagemScreen(
              imagemFundo: imagemFundo,
              proximaTela: tela,
            ),
          ),
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
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icone, color: Colors.white, size: 20),

          const SizedBox(height: 10),

          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontFamily: 'PressStart2P',
            ),
          ),
        ],
      ),
    ),
  );
}
