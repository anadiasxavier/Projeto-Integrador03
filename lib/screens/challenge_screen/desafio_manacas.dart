import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/background.dart';
import '../game/personagem_screen.dart';
import '../game/exploration_screen.dart';
import '../../main.dart';
import '../../services/firestore_service.dart';

class DesafioManacasScreen extends StatefulWidget {
  const DesafioManacasScreen({super.key});

  @override
  State<DesafioManacasScreen> createState() => _DesafioManacasScreenState();
}

class _DesafioManacasScreenState extends State<DesafioManacasScreen> {
  List<String> board = List.filled(9, '');
  final FirestoreService firestore = FirestoreService();

  // Falas do guardião (vitória)
  final List<String> _falasGuardiao = [
    '...Você observou.',
    'Talvez exista esperança para você.',
    'Mas isso é apenas o começo.',
    'O silêncio do Manacas te observa.',
  ];

  // Falas do personagem
  final List<String> _falasPersonagem = [
    'Consegui vencer o guardião!',
    'O tabuleiro finalmente parou...',
    'De repente, algo brilha na escuridão.',
  ];

  // Tela do computador
  Widget _telaComputadorConcluido() {
    return PersonagemScreen(
      imagemFundo: "assets/manacas.png",
      falasCustom: [
        'Olhando para o pedestal...',
        'Uma mensagem começa a brilhar:',
        '',
        '    "DESAFIO CONCLUÍDO!"',
        '    "SIGA PARA A PRÓXIMA SALA"',
        '',
        'Mais um passo nessa jornada...',
      ],
      instrucaoToque: 'Toque para continuar',
      substituirAoAvancarFinal: true,
      proximaTela: const SizedBox.shrink(),
    );
  }

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
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
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
          side: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        title: const Row(
          children: [
            Icon(Icons.close, color: Colors.redAccent, size: 28),
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

  void _vitoria() async {
    // Fluxo sequencial de falas
    // Primeiro: Falas do Guardião
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PersonagemScreen(
          imagemFundo: "assets/manacas.png",
          falasCustom: _falasGuardiao,
          instrucaoToque: 'Toque para continuar',
          substituirAoAvancarFinal: true,
          proximaTela: const SizedBox.shrink(),
        ),
      ),
    );

    // Segundo: Falas do Personagem
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PersonagemScreen(
          imagemFundo: "assets/manacas.png",
          falasCustom: _falasPersonagem,
          instrucaoToque: 'Toque para continuar',
          substituirAoAvancarFinal: true,
          proximaTela: const SizedBox.shrink(),
        ),
      ),
    );

    // Terceiro: Tela do Computador
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _telaComputadorConcluido(),
      ),
    );

    // Finalmente: Salva e volta para Exploration
    await _salvarProgressoERetornar();
  }

  // Função que salva o progresso no Firestore
  Future<void> _salvarProgressoERetornar() async {
    try {
      print('Salvando progresso do Manacas...');
      
      await firestore.updatePlayerData(
        raJogador,
        {
          'salasConcluidas': FieldValue.arrayUnion(['Manacas']), // ⭐ SEM ACENTO
        },
      );
      
      print('Progresso do Manacas salvo com sucesso!');
      
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          ExplorationScreen.routeName,
          (route) => false,
        );
      }
    } catch (e) {
      print('Erro ao salvar progresso do Manacas: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
        
        Navigator.pushNamedAndRemoveUntil(
          context,
          ExplorationScreen.routeName,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jogo do Guardião - Manacas"),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone do jogo
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.amber, width: 2),
                ),
                child: const Icon(
                  Icons.games,
                  color: Colors.amber,
                  size: 40,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Tabuleiro
              SizedBox(
                width: 300,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () => jogar(i),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          board[i],
                          style: TextStyle(
                            color: board[i] == 'X' ? Colors.cyan : Colors.redAccent,
                            fontSize: 30,
                            fontFamily: 'PressStart2P',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Dica
              Text(
                'Faça uma linha para vencer!',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                  fontFamily: 'PressStart2P',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}