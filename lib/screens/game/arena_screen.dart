// lib/screens/arena/arena_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../../models/entidade_dialogo.dart';
import 'narrador_screen.dart';
import 'personagem_screen.dart';
import '../challenge_screen/desafio_arena_screen.dart';

class ArenaScreen extends StatelessWidget {
  const ArenaScreen({super.key});

  // Falas iniciais do personagem
  static final List<FalaConfig> _falasEntrada = [
    FalaConfig.personagem('A Arena Gamer… tem luz piscando por baixo da porta…'),
    FalaConfig.personagem('E dá pra ouvir som de jogo… cliques rápidos…'),
    FalaConfig.personagem('Parece que tem algo rodando lá dentro…'),
    FalaConfig.personagem('…tem alguém aí?'),
    FalaConfig.personagem('Uma tela… acendeu sozinha'),
    FalaConfig.personagem('Tem alguma coisa rodando aqui… esses comandos… tão passando rápido demais.'),
    FalaConfig.personagem('Parece que tem um desafio aqui…'),
  ];

  // Falas do guardião da arena
  static final List<FalaConfig> _falasGuardiaoArena = [
    FalaConfig.guardiao('Demorou… Você joga ou só reage?'),
    FalaConfig.guardiao('Todo mundo quer sair… mas sair não é o objetivo.'),
    FalaConfig.guardiao('Você passou… por enquanto.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Arena Gamer"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Background(
        imagem: "assets/arena.png",
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                const Text(
                  "ARENA GAMER",
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
                    "A porta abriu sozinha… os monitores estão ligados\n"
                    "As cadeiras estão se mexendo… mas não tem ninguém aqui.\n"
                    "Isso aqui está funcionando… mas quem está jogando?...",
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
                      color: const Color(0xFFB388FF).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFB388FF)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.explore, color: Colors.cyan, size: 28),
                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "EXPLORAR A ARENA",
                                style: TextStyle(
                                  color: Color(0xFFB388FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PressStart2P',
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Explorar a sala",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
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
        builder: (_) => NarradorScreen(
          tituloAppBar: "Arena Gamer",
          imagemFundo: "assets/arena.png",
          corpoNarracao:
              'Você entra na Arena Gamer.\n\n'
              'Luzes piscam.\n'
              'O som de partidas ecoa.\n\n'
              'Mas não há ninguém ali...',

          dica: '',
          exibirNarracaoEmCaixa: true,

          proximaTela: PersonagemScreen(
            imagemFundo: "assets/arena.png",
            falasConfig: _falasEntrada, // 👈 Mudou para falasConfig
            instrucaoToque: 'Toque para continuar',
            substituirAoAvancarFinal: false,
            proximaTela: const DesafioArenaScreen(),
          ),
        ),
      ),
    );
  }

  Widget _etapaGuardiaoArena() {
    return NarradorScreen(
      tituloAppBar: "Presença na Arena",
      imagemFundo: "assets/arena.png",
      corpoNarracao:
          'Uma cadeira começa a girar sozinha.\n\n'
          'Um monitor pisca.\n\n'
          'Uma presença surge diante de você...',
      dica: '',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/arena.png",
        falasConfig: _falasGuardiaoArena, // 👈 Mudou para falasConfig
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: null,
      ),
    );
  }
}