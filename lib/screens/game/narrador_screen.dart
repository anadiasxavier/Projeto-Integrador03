import 'package:flutter/material.dart';
import '../../widgets/background.dart';

class NarradorScreen extends StatelessWidget {
  final Widget proximaTela;
  final String imagemFundo;

  const NarradorScreen({
    super.key,
    required this.proximaTela,
    required this.imagemFundo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold( // estrutura básica da tela

     appBar: AppBar(
      title: const Text("Narrador"),
      backgroundColor: const Color.fromARGB(255, 0, 19, 48), // azul escuro
      foregroundColor: Colors.white, // texto + ícone branco
       ),

      body: Background(
        imagem: imagemFundo,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Text(
                  "Narrador",
                  style: TextStyle(
                    color:  Color.fromARGB(255, 255, 213, 0),
                    fontSize: 18,
                    fontFamily: 'PressStart2P',
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Você acorda no campus...\n\nEstá escuro.\n\nO silêncio domina o lugar.\n\nVocê não sabe como chegou ali...\n\nMas algo não está certo.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'PressStart2P',
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "💭 Dica:\nExplore o ambiente ao seu redor...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 50),

                //Botão para avançar para a próxima tela
               SizedBox(
                width: 260,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => proximaTela,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Continuar",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 255, 213, 0),
                                fontFamily: 'PressStart2P',
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Seguir na história",
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
              )
              ],
            ),
          ),
        ),
      ),
    );
  }
}