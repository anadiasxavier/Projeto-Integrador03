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

    appBar: AppBar( // barra de navegação, botão de voltar
        title: const Text("Narrador"), // título da barra
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
                    color: Colors.red,
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

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => proximaTela,
  ),
);
                  },
                  child: const Text("Continuar"),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}