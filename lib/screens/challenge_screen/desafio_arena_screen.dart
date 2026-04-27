import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../game/personagem_screen.dart';

class DesafioArenaScreen extends StatefulWidget {
  const DesafioArenaScreen({super.key});

  @override
  State<DesafioArenaScreen> createState() => _DesafioArenaScreenState();
}

class _DesafioArenaScreenState extends State<DesafioArenaScreen> {
  int perguntaAtual = 0;
  int acertos = 0;

  final List<Map<String, Object>> perguntas = [
    {
      'pergunta':
          'No jogo Super Mario World, qual é o nome do dinossauro que ajuda Mario?',
      'opcoes': ['Bowser', 'Yoshi', 'Toad'],
      'correta': 1,
    },
    {
      'pergunta':
          'Na franquia The Sims, o que acontece quando um Sim fica muito tempo sem fazer as necessidades?',
      'opcoes': [
        'Ganha habilidades',
        'Desmaia ou morre',
        'Muda de casa'
      ],
      'correta': 1,
    },
    {
      'pergunta':
          'Na série Mortal Kombat, qual é o golpe final clássico?',
      'opcoes': ['Combo', 'Fatality', 'Power Up'],
      'correta': 1,
    },
  ];

  void responder(int index) {
    if (index == perguntas[perguntaAtual]['correta']) {
      acertos++;
    }

    if (perguntaAtual < perguntas.length - 1) {
      setState(() => perguntaAtual++);
    } else {
      _finalizar();
    }
  }

  void _finalizar() {
    if (acertos == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => _telaFragmentoObtido(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PersonagemScreen(
            imagemFundo: "assets/arena.png",
            falasCustom: [
              'A tela ficou vermelha…',
              'Isso não parece nada bom…',
              'RESPOSTA INCORRETA',
            ],
            instrucaoToque: 'Tente novamente',
            substituirAoAvancarFinal: false,
            proximaTela: const DesafioArenaScreen(),
          ),
        ),
      );
    }
  }

  // 🏆 TELA DE RECOMPENSA
  Widget _telaFragmentoObtido() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fragmento de Chave"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
      ),
      body: Background(
        imagem: "assets/arena.png",
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber.withOpacity(0.2),
                  border: Border.all(color: Colors.amber, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.vpn_key,
                  color: Colors.amber,
                  size: 80,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "FRAGMENTO DE CHAVE\nOBTIDO!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PressStart2P',
                ),
              ),

              const SizedBox(height: 15),

              Text(
                "A arena ficou em silêncio.\n"
                "Os monitores desligaram...\n"
                "Mas algo ainda está observando.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontFamily: 'PressStart2P',
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 40),

              GestureDetector(
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.white, size: 24),
                      SizedBox(width: 10),
                      Text(
                        "VOLTAR AO CAMPUS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'PressStart2P',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pergunta = perguntas[perguntaAtual];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Gamer"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/arena.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Pergunta ${perguntaAtual + 1}/3",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontFamily: 'PressStart2P',
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    pergunta['pergunta'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'PressStart2P',
                    ),
                  ),

                  const SizedBox(height: 25),

                  ...(pergunta['opcoes'] as List<String>)
                      .asMap()
                      .entries
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: GestureDetector(
                            onTap: () => responder(e.key),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB388FF)
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFB388FF),
                                ),
                              ),
                              child: Text(
                                e.value,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'PressStart2P',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}