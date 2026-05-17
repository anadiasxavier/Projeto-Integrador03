import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/background.dart';
import '../game/personagem_screen.dart';
import '../game/exploration_screen.dart';
import '../../main.dart';
import '../../services/firestore_service.dart';
import 'package:audioplayers/audioplayers.dart';

class DesafioArenaScreen extends StatefulWidget {
  const DesafioArenaScreen({super.key});

  @override
  State<DesafioArenaScreen> createState() => _DesafioArenaScreenState();
}

class _DesafioArenaScreenState extends State<DesafioArenaScreen> {
  int perguntaAtual = 0;
  int acertos = 0;
  final FirestoreService firestore = FirestoreService();

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
        'Muda de casa',
        'Desmaia ou morre'
      ],
      'correta': 2,
    },
    {
      'pergunta':
          'Na série Mortal Kombat, qual é o golpe final clássico?',
      'opcoes': ['Combo', 'Fatality', 'Power Up'],
      'correta': 1,
    },
  ];

  // Falas do guardião da arena
  final List<String> _falasGuardiao = [
    'Você derrotou todos os adversários...',
    'Os códigos se renderam ao seu comando.',
    'A arena agora reconhece seu poder.',
    'Mas isso é apenas o começo...',
  ];

  // Falas do personagem
  final List<String> _falasPersonagem = [
    'Consegui vencer todos os desafios!',
    'De repente, algo chama minha atenção...',
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
      _fluxoAcerto();
    } else {
      _fluxoErro();
    }
  }

  void _fluxoAcerto() async {
    // Primeiro: Falas do Guardião
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonagemScreen(
          imagemFundo: "assets/arena.png",
          falasCustom: _falasGuardiao,
          instrucaoToque: 'Toque para continuar',
          substituirAoAvancarFinal: true, // ⭐ MUDEI PARA true
          proximaTela: const SizedBox.shrink(),
        ),
      ),
    );
    
    // Segundo: Falas do Personagem
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonagemScreen(
          imagemFundo: "assets/arena.png",
          falasCustom: _falasPersonagem,
          instrucaoToque: 'Toque para continuar',
          substituirAoAvancarFinal: true, // ⭐ MUDEI PARA true
          proximaTela: const SizedBox.shrink(),
        ),
      ),
    );
    
    // Terceiro: Tela do Computador
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _telaComputadorConcluido(),
      ),
    );
    
    // ⭐ FINALMENTE: Salva e volta para Exploration
    await _salvarProgressoERetornar();
  }

  // Tela do computador com a mensagem
  Widget _telaComputadorConcluido() {
    return PersonagemScreen(
      imagemFundo: "assets/arena.png",
      falasCustom: [
        'Olhando para a tela do computador...',
        'Uma mensagem aparece no monitor:',
        '',
        '    "DESAFIO CONCLUÍDO!"',
        '    "SIGA PARA A PRÓXIMA SALA"',
        '',
        'Preciso continuar minha jornada...',
      ],
      instrucaoToque: 'Toque para continuar',
      substituirAoAvancarFinal: true, // ⭐ MUDEI PARA true
      proximaTela: const SizedBox.shrink(),
    );
  }

  void _fluxoErro() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PersonagemScreen(
          imagemFundo: "assets/arena.png",
          falasCustom: [
            'A tela ficou vermelha…',
            'Isso não parece nada bom…',
            'VOCÊ FALHOU NO DESAFIO!',
            'Os jogos nunca perdoam quem erra...',
            'Tente novamente quando estiver pronto.',
          ],
          instrucaoToque: 'Tente novamente',
          substituirAoAvancarFinal: false,
          proximaTela: const DesafioArenaScreen(),
        ),
      ),
    );
  }

  // Função que salva o progresso no Firestore
  Future<void> _salvarProgressoERetornar() async {
    try {
      print('Iniciando salvamento...');
      
      // Salva no Firestore
      await firestore.updatePlayerData(
        raJogador,
        {
          'salasConcluidas': FieldValue.arrayUnion(['Arena']),
        },
      );
      
      print('Progresso da Arena salvo com sucesso!');
      
      // ⭐ VOLTA PARA EXPLORATION SCREEN
      if (mounted) {
        print('Voltando para ExplorationScreen...');
        Navigator.pushNamedAndRemoveUntil(
          context,
          ExplorationScreen.routeName,
          (route) => false,
        );
      }
      
    } catch (e) {
      print('Erro ao salvar progresso da Arena: $e');
      
      // Se deu erro, tenta voltar mesmo assim
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
    final pergunta = perguntas[perguntaAtual];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Desafio da Arena"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
              color: Colors.black.withOpacity(0.85),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color(0xFFB388FF).withOpacity(0.5),
                width: 2,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB388FF).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFB388FF),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.sports_esports,
                      color: Color(0xFFB388FF),
                      size: 40,
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB388FF).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "PERGUNTA ${perguntaAtual + 1}/${perguntas.length}",
                      style: const TextStyle(
                        color: Color(0xFFB388FF),
                        fontSize: 10,
                        fontFamily: 'PressStart2P',
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    pergunta['pergunta'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'PressStart2P',
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  ...(pergunta['opcoes'] as List<String>)
                      .asMap()
                      .entries
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: GestureDetector(
                            onTap: () => responder(e.key),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB388FF)
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFB388FF),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${String.fromCharCode(65 + e.key)})',
                                    style: const TextStyle(
                                      color: Color(0xFFB388FF),
                                      fontSize: 12,
                                      fontFamily: 'PressStart2P',
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Text(
                                      e.value,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'PressStart2P',
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  
                  const SizedBox(height: 20),
                  
                  LinearProgressIndicator(
                    value: (perguntaAtual + 1) / perguntas.length,
                    backgroundColor: Colors.white24,
                    color: const Color(0xFFB388FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  Text(
                    'ACERTOS: $acertos/${perguntas.length}',
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontFamily: 'PressStart2P',
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