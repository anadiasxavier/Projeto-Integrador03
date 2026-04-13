import 'package:flutter/material.dart';
import '../widgets/background.dart';
import '../main.dart';

class PersonagemScreen extends StatefulWidget {
  final Widget proximaTela;

  const PersonagemScreen({
    super.key,
    required this.proximaTela,
  });

  @override
  State<PersonagemScreen> createState() => _PersonagemScreenState();
}

class _PersonagemScreenState extends State<PersonagemScreen> {
  int indice = 0;

  List<String> falas = [
    "Onde eu estou...?",
    "Isso é o campus?",
    "Está tudo muito estranho...",
    "Preciso descobrir o que aconteceu...",
  ];

  void proximaFala() {
    if (indice < falas.length - 1) {
      setState(() {
        indice++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => widget.proximaTela,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String imagem = generoJogador == "feminino"
        ? "assets/personagemfeminina.png"
        : "assets/personagem.png";

    return Scaffold(
      body: Background(
        child: Stack(
          children: [

            /// CAIXA DE DIÁLOGO
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: proximaFala,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white),
                  ),

                  child: Row(
                    children: [

                      /// PERSONAGEM
                      Image.asset(imagem, width: 70, height: 70),

                      const SizedBox(width: 10),

                      /// TEXTO
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                               generoJogador == "feminino" 
                               ? "Você (Ela)" 
                               : "Você (Ele)",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontFamily: 'PressStart2P',
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              falas[indice],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'PressStart2P',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}