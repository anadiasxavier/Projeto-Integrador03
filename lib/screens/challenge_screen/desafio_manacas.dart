import 'dart:math';
import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../game/manacas_screen.dart';
import '../game/narrador_screen.dart';
import '../game/personagem_screen.dart';

class DesafioManacasScreen extends StatefulWidget {
  const DesafioManacasScreen({super.key});

  @override
  State<DesafioManacasScreen> createState() => _DesafioManacasScreenState();
}

class _DesafioManacasScreenState extends State<DesafioManacasScreen> {
  List<String> board = List.filled(9, '');
  bool jogadorTurno = true;

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
      if (board[i] == '') livres.add(i);
    }

    int escolha = livres[Random().nextInt(livres.length)];

    setState(() => board[escolha] = 'O');

    if (verificar('O')) {
      _erro();
    }
  }

  bool verificar(String p) {
    List<List<int>> wins = [
      [0,1,2],[3,4,5],[6,7,8],
      [0,3,6],[1,4,7],[2,5,8],
      [0,4,8],[2,4,6],
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
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        title: const Text("Guardião",
            style: TextStyle(color: Colors.red)),
        content: const Text("Impulsivo...",
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                board = List.filled(9, '');
              });
            },
            child: const Text("Tentar novamente"),
          )
        ],
      ),
    );
  }

  void _vitoria() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => NarradorScreen(
          imagemFundo: "assets/manacas.png",
          corpoNarracao:
              'O tabuleiro para...\n\nO guardião observa em silêncio.',
          proximaTela: PersonagemScreen(
            imagemFundo: "assets/manacas.png",
            falasCustom: const [
              '...Você observou.',
              'Leve isso.',
            ],
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
      ),
      body: Background(
        imagem: "assets/manacas.png",
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.vpn_key,
                  size: 80, color: Colors.amber),
              const SizedBox(height: 20),
              const Text(
                "FRAGMENTO OBTIDO!",
                style: TextStyle(
                  color: Colors.amber,
                  fontFamily: 'PressStart2P',
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
                child: const Text("Voltar"),
              )
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
                      crossAxisCount: 3),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => jogar(i),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                  ),
                  child: Center(
                    child: Text(
                      board[i],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
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