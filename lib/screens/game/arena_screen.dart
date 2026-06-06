// lib/screens/arena/arena_completo.dart
import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../../models/entidade_dialogo.dart';
import '../game/personagem_screen.dart';
import '../game/exploration_screen.dart';
import '../../main.dart';
import '../../services/progress_service.dart';
import '../game/narrador_screen.dart';
import '../../widgets/dialogo_com_guardiao.dart';

// tela de instruções da arena
class _InstrucoesArenaScreen extends StatelessWidget {
  const _InstrucoesArenaScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instruções"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
      ),
      body: Background(
        imagem: "assets/arena.png",
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Ícone de computador
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFB388FF),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.computer,
                    color: Color(0xFFB388FF),
                    size: 80,
                  ),
                ),
                const SizedBox(height: 30),
                // Caixa de instruções
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFB388FF).withOpacity(0.5),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "COMO JOGAR",
                        style: TextStyle(
                          color: Color(0xFFB388FF),
                          fontSize: 14,
                          fontFamily: 'PressStart2P',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Você vai responder 3 perguntas sobre jogos.\n\n"
                        "Cada pergunta tem 3 alternativas (A, B, C).\n\n"
                        "Toque na resposta correta para avançar.\n\n"
                        "Se errar, terá que recomeçar o desafio.\n",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontFamily: 'PressStart2P',
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Botão COMEÇAR
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DesafioArenaScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 250,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB388FF).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFB388FF)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "COMEÇAR",
                          style: TextStyle(
                            color: Color(0xFFB388FF),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PressStart2P',
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.play_arrow,
                          color: Color(0xFFB388FF),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// tela de recompensa da arena
class _RecompensaScreen extends StatefulWidget {
  final String nomeSala;
  final String imagemFundo;

  const _RecompensaScreen({required this.nomeSala, required this.imagemFundo});

  @override
  State<_RecompensaScreen> createState() => _RecompensaScreenState();
}

class _RecompensaScreenState extends State<_RecompensaScreen> {
  final ProgressService _progress = ProgressService();

  void _salvarProgressoEVoltarExploration() async {
    try {
      await _progress.marcarSalaConcluida(
        raJogador,
        widget.nomeSala,
        novasChaves: ['Manacás', 'Mescla', 'Praça'],
      );
      print('Progresso salvo com sucesso!');
    } catch (e) {
      print('Erro ao salvar progresso: $e');
    }

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ExplorationScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fragmento de Chave"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
      ),
      body: Background(
        imagem: widget.imagemFundo,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1500),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.deepPurpleAccent.withOpacity(0.5),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurpleAccent.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.vpn_key,
                      color: Colors.deepPurpleAccent,
                      size: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "PARABÉNS!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PressStart2P',
                    shadows: [
                      Shadow(color: Colors.deepPurpleAccent, blurRadius: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.deepPurpleAccent.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: const Column(
                    children: [
                      Text("🗝️", style: TextStyle(fontSize: 40)),
                      SizedBox(height: 10),
                      Text(
                        "Você conseguiu um",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'PressStart2P',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "FRAGMENTO DE CHAVE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PressStart2P',
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Este fragmento é parte de algo maior.\n"
                        "Você está quase descobrindo todos os\n"
                        "segredos deste lugar.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontFamily: 'PressStart2P',
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _salvarProgressoEVoltarExploration,
                  child: Container(
                    width: 280,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.deepPurpleAccent.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.deepPurpleAccent,
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "CONTINUAR JORNADA",
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PressStart2P',
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
}

// tela do desafio da arena
class DesafioArenaScreen extends StatefulWidget {
  const DesafioArenaScreen({super.key});

  static const String _imagemGuardiaoArena =
      'assets/guardiao/arenaguardiao.png';

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
      'opcoes': ['Ganha habilidades', 'Muda de casa', 'Desmaia ou morre'],
      'correta': 2,
    },
    {
      'pergunta': 'Na série Mortal Kombat, qual é o golpe final clássico?',
      'opcoes': ['Combo', 'Fatality', 'Power Up'],
      'correta': 1,
    },
  ];

  // Falas do guardião da arena (após acertar tudo)
  static final List<FalaConfig> _falasGuardiao = [
    FalaConfig.guardiao('Hm... você realmente conseguiu chegar até aqui.'),
    FalaConfig.guardiao('Poucos suportam os desafios da arena sem hesitar.'),
    FalaConfig.guardiao('Vejo determinação nos seus passos... isso é raro.'),
    FalaConfig.guardiao('Mas não pense que sua jornada termina aqui.'),
  ];
  // Falas do personagem com reações
  List<FalaConfig> get _falasPersonagem => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"}  O que... era aquilo?!',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Ele… estava me observando?',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} Por que esse lugar ficou tão frio de repente?',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[feliz]" : "[feliz]"} Consegui vencer todos os desafios!',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} De repente, algo chama minha atenção...',
    ),
  ];

  // Falas de erro - alterado para aparecer as reações do personagem e do guardião na tela
  static List<FalaConfig> get _falasErro => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} A tela ficou vermelha…',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} Isso não parece nada bom…',
    ),
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
    if (acertos == perguntas.length) {
      _fluxoAcerto();
    } else {
      _fluxoErro();
    }
  }

  void _fluxoAcerto() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DialogoComGuardiao(
          personagemScreen: PersonagemScreen(
            imagemFundo: "assets/arena.png",
            imagemGuardiao: DesafioArenaScreen
                ._imagemGuardiaoArena, // adiciona a imagem do guardião no balão de fala dele
            falasConfig: _falasGuardiao,
            exibirReacoes: true,
            instrucaoToque: 'Toque para continuar',
            substituirAoAvancarFinal: true,
            proximaTela: _segundaEtapa(),
          ),
        ),
      ),
    );
  }

  Widget _segundaEtapa() {
    return PersonagemScreen(
      imagemFundo: "assets/arena.png",
      falasConfig: _falasPersonagem,
      exibirReacoes: true,
      instrucaoToque: 'Toque para continuar',
      substituirAoAvancarFinal: true,
      proximaTela: const _RecompensaScreen(
        nomeSala: 'Arena',
        imagemFundo: 'assets/arena.png',
      ),
    );
  }

  void _fluxoErro() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PersonagemScreen(
          imagemFundo: "assets/arena.png",
          imagemGuardiao: DesafioArenaScreen
              ._imagemGuardiaoArena, // adiciona a imagem do guardião no balão de fala dele
          falasConfig: _falasErro,
          exibirReacoes:
              true, // exibe as reações do personagem para as falas de erro
          instrucaoToque: 'Tente novamente',
          substituirAoAvancarFinal: false,
          proximaTela: const DesafioArenaScreen(),
        ),
      ),
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
        actions: [],
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
                  ...(pergunta['opcoes'] as List<String>).asMap().entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        onTap: () => responder(e.key),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB388FF).withOpacity(0.15),
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

// tela principal da arena
class ArenaScreen extends StatelessWidget {
  const ArenaScreen({super.key});

  static List<FalaConfig> get _falasEntradaArena => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} A Arena Gamer… tem luz piscando por baixo da porta…',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} E dá pra ouvir som de jogo… cliques rápidos…',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} Parece que tem algo rodando lá dentro…',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} …tem alguém aí?',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} Uma tela… acendeu sozinha...',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} Tem alguma coisa rodando aqui… esses comandos… tão passando rápido demais.',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} Tem um tipo de desafio acontecendo aqui dentro….',
    ),
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
            falasConfig: _falasEntradaArena,
            exibirReacoes: true,
            instrucaoToque: 'Toque para continuar',
            substituirAoAvancarFinal: false,
            proximaTela: const _InstrucoesArenaScreen(),
          ),
        ),
      ),
    );
  }
}
