import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../../models/entidade_dialogo.dart';
import 'personagem_screen.dart';
import '../challenge_screen/desafio_manacas.dart';

class ManacasScreen extends StatelessWidget {
  const ManacasScreen({super.key});

  static final List<FalaConfig> _falasManacas = [

    FalaConfig.guardiao(
      'Você não deveria estar aqui.',
    ),

    FalaConfig.personagem(
      'Me desculpa, eu acabei dormindo na aula e não estou conseguindo ir embora… você pode me ajudar?',
    ),

    FalaConfig.guardiao(
      'Você é engraçada… AQUI ninguém vai embora tão fácil.',
    ),

    FalaConfig.personagem(
      'O que você quer dizer com isso?',
    ),

    FalaConfig.guardiao(
      'Este lugar mudou… E agora ele escolhe quem pode sair.',
    ),

    FalaConfig.personagem(
      'Isso não faz sentido… eu só quero ir pra casa!',
    ),

    FalaConfig.guardiao(
      'Então prove.',
    ),

    FalaConfig.guardiao(
      'Cada lugar deste campus guarda um fragmento…',
    ),

    FalaConfig.guardiao(
      'Memórias esquecidas… erros e decisões.',
    ),

    FalaConfig.guardiao(
      'Se quiser sair… você precisa enfrentar o que está escondido aqui.',
    ),

    FalaConfig.guardiao(
      'Ganhe de mim… e eu te darei a chave para a próxima sala.',
    ),

    FalaConfig.personagem(
      'Isso só pode ser brincadeira…',
    ),

    FalaConfig.guardiao(
      'Você acha que é apenas um jogo.',
    ),

    FalaConfig.guardiao(
      'Todo jogo aqui cobra um preço.',
    ),

    FalaConfig.personagem(
      'Tá… é só um jogo… eu consigo fazer isso.',
    ),

    FalaConfig.guardiao(
      'Não se trata de vencer… Se trata de entender.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manacás"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Background(
        imagem: "assets/manacas.png",
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 40),

                const Text(
                  "MANACÁS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PressStart2P',
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12),
                  ),

                  child: const Text(
                    "As luzes piscam lentamente.\n"
                    "O ambiente parece vazio.\n"
                    "Mas algo observa você no silêncio...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontFamily: 'PressStart2P',
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                GestureDetector(
                  onTap: () => _iniciarFluxo(context),

                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.4),
                      ),
                    ),

                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        Icon(
                          Icons.explore,
                          color: Colors.green,
                          size: 28,
                        ),

                        SizedBox(width: 15),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(
                              "EXPLORAR MANACÁS",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.bold,
                                fontFamily:
                                    'PressStart2P',
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              "Investigar o ambiente estranho",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _iniciarFluxo(BuildContext context) {

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) => PersonagemScreen(
          imagemFundo: "assets/manacas.png",

          // MUDOU AQUI
          falasConfig: _falasManacas,

          instrucaoToque: 'Toque para continuar',
          substituirAoAvancarFinal: false,

          proximaTela:
              const DesafioManacasScreen(),
        ),
      ),
    );
  }
}