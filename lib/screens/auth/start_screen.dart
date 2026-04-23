import 'package:flutter/material.dart';
import 'username_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Imagem de fundo
          Positioned.fill(
            child: Image.asset("assets/puc.png", fit: BoxFit.cover), //  Imagem de fundo cobrindo toda a tela
          ),

           /// Camada de escurecimento
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),

          /// CONTEÚDO DA TELA
          Center(
            child: Column( // Centraliza horizontalmente  
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
              children: [ //  Lista de widgets na coluna
                /// TÍTULO
                const Text(
                  "CAMPUS QUEST", // Título do jogo
                  textAlign: TextAlign.center, // Centraliza o texto
                  style: TextStyle( //  Estilo do texto
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PressStart2P',
                    color: Color.fromARGB(255, 255, 213, 0),
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 40),

                
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UsernameScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 320,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        
                        const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 28,
                        ),

                        const SizedBox(width: 14),

                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Novo Jogo",
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                               color: Color.fromARGB(255, 255, 213, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "Começar a aventura no campus",
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 249, 208),
                                fontSize: 13,
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
        ],
      ),
    );
  }
}
