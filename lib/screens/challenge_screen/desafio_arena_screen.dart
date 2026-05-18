// lib/screens/challenge_screen/desafio_arena_screen.dart
import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import '../../models/entidade_dialogo.dart';
import '../game/personagem_screen.dart';
import '../game/exploration_screen.dart';
import '../../main.dart';
import '../../services/progress_service.dart';
import '../../widgets/game_timer_widget.dart';
import 'package:audioplayers/audioplayers.dart';

class DesafioArenaScreen extends StatefulWidget {
  const DesafioArenaScreen({super.key});

  @override
  State<DesafioArenaScreen> createState() => _DesafioArenaScreenState();
}

class _DesafioArenaScreenState extends State<DesafioArenaScreen> {
  int perguntaAtual = 0;
  int acertos = 0;
  final ProgressService _progress = ProgressService();

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
  static final List<FalaConfig> _falasGuardiao = [
    FalaConfig.guardiao('Você derrotou todos os adversários...'),
    FalaConfig.guardiao('Os códigos se renderam ao seu comando.'),
    FalaConfig.guardiao('A arena agora reconhece seu poder.'),
    FalaConfig.guardiao('Mas isso é apenas o começo...'),
  ];

  // Falas do personagem
  static final List<FalaConfig> _falasPersonagem = [
    FalaConfig.personagem('Consegui vencer todos os desafios!'),
    FalaConfig.personagem('De repente, algo chama minha atenção...'),
  ];

  // Falas da tela do computador
  static final List<FalaConfig> _falasComputador = [
    FalaConfig.personagem('Olhando para a tela do computador...'),
    FalaConfig.personagem('Uma mensagem aparece no monitor:'),
    FalaConfig.personagem(''),
    FalaConfig.personagem('    "DESAFIO CONCLUÍDO!"'),
    FalaConfig.personagem('    "SIGA PARA A PRÓXIMA SALA"'),
    FalaConfig.personagem(''),
    FalaConfig.personagem('Preciso continuar minha jornada...'),
  ];

  // Falas de erro
  static final List<FalaConfig> _falasErro = [
    FalaConfig.personagem('A tela ficou vermelha…'),
    FalaConfig.personagem('Isso não parece nada bom…'),
    FalaConfig.guardiao('VOCÊ FALHOU NO DESAFIO!'),
    FalaConfig.guardiao('Os jogos nunca perdoam quem erra...'),
    FalaConfig.guardiao('Tente novamente quando estiver pronto.'),
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
          falasConfig: _falasGuardiao, // 👈 Mudou para falasConfig
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
        builder: (context) => PersonagemScreen(
          imagemFundo: "assets/arena.png",
          falasConfig: _falasPersonagem, // 👈 Mudou para falasConfig
          exibirReacoes: true, // 👈 Adicionei reações
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
        builder: (context) => _telaComputadorConcluido(),
      ),
    );
    
    // Salva e volta para Exploration
    await _salvarProgressoERetornar();
  }

  // Tela do computador com a mensagem
  Widget _telaComputadorConcluido() {
    return PersonagemScreen(
      imagemFundo: "assets/arena.png",
      falasConfig: _falasComputador, // 👈 Mudou para falasConfig
      instrucaoToque: 'Toque para continuar',
      substituirAoAvancarFinal: true,
      proximaTela: const SizedBox.shrink(),
    );
  }

  void _fluxoErro() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PersonagemScreen(
          imagemFundo: "assets/arena.png",
          falasConfig: _falasErro, // 👈 Mudou para falasConfig
          instrucaoToque: 'Tente novamente',
          substituirAoAvancarFinal: false,
          proximaTela: const DesafioArenaScreen(),
        ),
      ),
    );
  }

  // Função que salva o progresso localmente e no Firestore
  Future<void> _salvarProgressoERetornar() async {
    try {
      await _progress.marcarSalaConcluida(raJogador, 'Arena');
      print('Progresso da Arena salvo com sucesso!');
    } catch (e) {
      print('Erro ao salvar progresso da Arena: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      ExplorationScreen.routeName,
      (route) => false,
    );
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: const GameTimerWidget(),
            ),
          ),
        ],
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