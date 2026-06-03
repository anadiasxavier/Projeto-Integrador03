import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../../models/entidade_dialogo.dart';
import 'personagem_screen.dart';
import '../challenge_screen/desafio_manacas.dart';
import '../../main.dart';
import '../../widgets/dialogo_com_guardiao.dart';

class ManacasScreen extends StatelessWidget {
  const ManacasScreen({super.key});

  static final List<FalaConfig> _falasGuardiao = [
    FalaConfig.guardiao('Você não deveria estar aqui.'),
    FalaConfig.guardiao('Você é engraçada… AQUI ninguém vai embora tão fácil.'),
    FalaConfig.guardiao(
      'Este lugar mudou… E agora ele escolhe quem pode sair.',
    ),
    FalaConfig.guardiao('Então prove.'),
    FalaConfig.guardiao('Cada lugar deste campus guarda um fragmento…'),
    FalaConfig.guardiao('Memórias esquecidas… erros e decisões.'),
    FalaConfig.guardiao(
      'Se quiser sair… você precisa enfrentar o que está escondido aqui.',
    ),
    FalaConfig.guardiao(
      'Ganhe de mim… e eu te darei a chave para a próxima sala.',
    ),
    FalaConfig.guardiao('Você acha que é apenas um jogo.'),
    FalaConfig.guardiao('Todo jogo aqui cobra um preço.'),
    FalaConfig.guardiao('Não se trata de vencer… Se trata de entender.'),
  ];

  static List<FalaConfig> get _falasPersonagem => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} '
      'Me desculpa, eu acabei dormindo na aula e não estou conseguindo ir embora… você pode me ajudar?',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} '
      'O que você quer dizer com isso?',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[triste]" : "[inquieto]"} '
      'Isso não faz sentido… eu só quero ir pra casa!',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} '
      'Isso só pode ser brincadeira…',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[feliz]" : "[feliz]"} '
      'Tá… é só um jogo… eu consigo fazer isso.',
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
                      border: Border.all(color: Colors.green.withOpacity(0.4)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.explore, color: Colors.green, size: 28),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "EXPLORAR MANACÁS",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PressStart2P',
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

  void _iniciarFluxo(BuildContext context) async {
Future<void> falaGuardiao(String texto) async {
  debugPrint('ABRINDO GUARDIAO: $texto');

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) {
        debugPrint('CONSTRUIU DIALOGO');

        return DialogoComGuardiao(
          imagemGuardiao:
              'assets/guardiao/manacasguardiao.png',

          personagemScreen: PersonagemScreen(
            imagemFundo: "assets/manacas.png",

            falasConfig: [
              FalaConfig.guardiao(texto),
            ],

            exibirReacoes: false,
            instrucaoToque:
                'Toque para continuar',

            substituirAoAvancarFinal:
                true,

            proximaTela:
                const SizedBox.shrink(),
          ),
        );
      },
    ),
  );
}
    Future<void> falaPersonagem(String texto) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PersonagemScreen(
            imagemFundo: "assets/manacas.png",

            falasConfig: [FalaConfig.personagem(texto)],

            exibirReacoes: true,
            instrucaoToque: 'Toque para continuar',

            substituirAoAvancarFinal: true,

            proximaTela: const SizedBox.shrink(),
          ),
        ),
      );
    }

    await falaGuardiao('Você não deveria estar aqui.');

    await falaPersonagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} '
      'Me desculpa, eu acabei dormindo na aula e não estou conseguindo ir embora… você pode me ajudar?',
    );

    await falaGuardiao('Você é engraçada… AQUI ninguém vai embora tão fácil.');

    await falaPersonagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} '
      'O que você quer dizer com isso?',
    );

    await falaGuardiao('Este lugar mudou… E agora ele escolhe quem pode sair.');

    await falaPersonagem(
      '${generoJogador == "feminino" ? "[triste]" : "[inquieto]"} '
      'Isso não faz sentido… eu só quero ir pra casa!',
    );

    await falaGuardiao('Então prove.');

    await falaGuardiao('Cada lugar deste campus guarda um fragmento…');

    await falaGuardiao('Memórias esquecidas… erros e decisões.');

    await falaGuardiao(
      'Se quiser sair… você precisa enfrentar o que está escondido aqui.',
    );

    await falaGuardiao(
      'Ganhe de mim… e eu te darei a chave para a próxima sala.',
    );

    await falaPersonagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} '
      'Isso só pode ser brincadeira…',
    );

    await falaGuardiao('Você acha que é apenas um jogo.');

    await falaGuardiao('Todo jogo aqui cobra um preço.');

    await falaPersonagem(
      '${generoJogador == "feminino" ? "[feliz]" : "[feliz]"} '
      'Tá… é só um jogo… eu consigo fazer isso.',
    );

    await falaGuardiao('Não se trata de vencer… Se trata de entender.');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DesafioManacasScreen()),
    );
  }
}
