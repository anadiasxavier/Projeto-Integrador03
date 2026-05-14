import 'dart:math';
import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../game/narrador_screen.dart';
import '../game/personagem_screen.dart';

class DesafioManacasScreen extends StatefulWidget {
  const DesafioManacasScreen({super.key});

  @override
  State<DesafioManacasScreen> createState() =>
      _DesafioManacasScreenState();
}

class _DesafioManacasScreenState
    extends State<DesafioManacasScreen> {

  List<String> board = List.filled(9, '');

  static const List<String> _falasFinais = [
    '...Você observou.',
    'Talvez exista esperança para você.',
    'Leve isso.',
  ];

  void jogar(int index) {
    if (board[index] != '') return;

    setState(() => board[index] = 'X');

    if (verificar('X')) {
      _vitoria();
      return;
    }

    if (!board.contains('')) {
      _erro();
      return;
    }

    _jogadaGuardiao();
  }

  void _jogadaGuardiao() {
    List<int> livres = [];

    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        livres.add(i);
      }
    }

    int escolha = livres[Random().nextInt(livres.length)];

    setState(() {
      board[escolha] = 'O';
    });

    if (verificar('O')) {
      _erro();
    }
  }

  bool verificar(String p) {
    List<List<int>> wins = [
      [0,1,2],
      [3,4,5],
      [6,7,8],
      [0,3,6],
      [1,4,7],
      [2,5,8],
      [0,4,8],
      [2,4,6],
    ];

    for (var w in wins) {
      if (board[w[0]] == p &&
          board[w[1]] == p &&
          board[w[2]] == p) {
        return true;
      }
    }

    return false;
  }

  void _erro() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.close,
              color: Colors.redAccent,
              size: 28,
            ),
            SizedBox(width: 10),
            Text(
              'VOCÊ FALHOU',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontFamily: 'PressStart2P',
              ),
            ),
          ],
        ),
        content: const Text(
          'O guardião observa em silêncio.\n\n'
          'O tabuleiro reinicia diante de você.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontFamily: 'PressStart2P',
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              setState(() {
                board = List.filled(9, '');
              });
            },
            child: const Text(
              'TENTAR NOVAMENTE',
              style: TextStyle(
                color: Colors.green,
                fontFamily: 'PressStart2P',
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _vitoria() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => NarradorScreen(
          tituloAppBar: "Vitória",
          imagemFundo: "assets/manacas.png",
          corpoNarracao:
              'O tabuleiro para de se mover.\n\n'
              'O guardião permanece imóvel.\n\n'
              'Pela primeira vez... o silêncio parece diferente.',
          dica: 'Toque em Continuar.',
          exibirNarracaoEmCaixa: true,
          proximaTela: PersonagemScreen(
            imagemFundo: "assets/manacas.png",
            falasCustom: _falasFinais,
            instrucaoToque: 'Toque para continuar',
            substituirAoAvancarFinal: false,
            proximaTela: _fragmento(),
          ),
        ),
      ),
    );
  }

  Widget _fragmento() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fragmento de Chave"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
      ),
      body: Background(
        imagem: "assets/manacas.png",
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber.withOpacity(0.2),
                  border: Border.all(
                    color: Colors.amber,
                    width: 3,
                  ),
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
                "O guardião desaparece lentamente.\n"
                "O silêncio do Manacás finalmente acaba.",
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
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
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
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                        size: 24,
                      ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jogo do Guardião"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
      ),
      body: Background(
        imagem: "assets/manacas.png",
        child: Center(
          child: SizedBox(
            width: 300,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: 9,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => jogar(i),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Center(
                    child: Text(
                      board[i],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'PressStart2P',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}