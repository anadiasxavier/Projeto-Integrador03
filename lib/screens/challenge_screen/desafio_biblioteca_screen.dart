import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../../main.dart';
import '../../models/entidade_dialogo.dart';
import '../game/personagem_screen.dart';
import '../game/narrador_screen.dart';
import '../game/exploration_screen.dart';
import '../../services/progress_service.dart';
import '../../widgets/game_timer_widget.dart';
import '../../widgets/dialogo_com_guardiao.dart';

// CLASSE PRIVADA PARA A TELA DE RECOMPENSA
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
        novasChaves: ['Manacás', 'Mescla', 'Praça', 'Arena'],
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
                      color: Colors.amber.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.5),
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
                ),
                const SizedBox(height: 30),
                const Text(
                  "PARABÉNS!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PressStart2P',
                    shadows: [Shadow(color: Colors.amber, blurRadius: 10)],
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
                      color: Colors.amber.withOpacity(0.4),
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
                          color: Colors.amber,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PressStart2P',
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Este fragmento é parte de algo maior.\n"
                        "Continue explorando para encontrar\n"
                        "os outros fragmentos e descobrir\n"
                        "os segredos deste lugar.",
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
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_forward, color: Colors.amber, size: 24),
                        SizedBox(width: 10),
                        Text(
                          "CONTINUAR JORNADA",
                          style: TextStyle(
                            color: Colors.amber,
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

// CLASSE PRINCIPAL DO DESAFIO
class DesafioBibliotecaScreen extends StatefulWidget {
  const DesafioBibliotecaScreen({super.key});

  @override
  State<DesafioBibliotecaScreen> createState() =>
      _DesafioBibliotecaScreenState();
}

class _DesafioBibliotecaScreenState extends State<DesafioBibliotecaScreen>
    with SingleTickerProviderStateMixin {
  
  static const String _imagemGuardiao = 'assets/guardia_biblioteca.png';
  
  int? _respostaSelecionada;
  int _tentativas = 0;
  late AnimationController _animacaoController;

  final String _textoCharada =
      'Você chega com fome,\n'
      'escolhe sem pensar muito,\n'
      'e vai embora quando termina.\n\n'
      'Onde isso acontece?';

  final List<String> _alternativas = [
    'Sala de aula',
    'Praça de alimentação',
    'Laboratório',
  ];

  final int _respostaCorretaIndex = 1;

  static final List<FalaConfig> _falasGuardiaoAcerto = [
    FalaConfig.guardiao('Agora sim…'),
    FalaConfig.guardiao('Você observou.'),
    FalaConfig.guardiao('Você compreendeu.'),
    FalaConfig.guardiao('Pode seguir.'),
  ];

  List<FalaConfig> get _falasPersonagemAcerto => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[feliz]" : "[feliz]"} Então… era isso…',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} Tem algo aqui.',
    ),
  ];

  List<FalaConfig> get _falasPersonagemPegaFragmento => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} Uma... chave?',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} Talvez isso me ajude a sair daqui.',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} Preciso continuar explorando...',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animacaoController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animacaoController.forward();
  }

  @override
  void dispose() {
    _animacaoController.dispose();
    super.dispose();
  }

  void _verificarResposta(int index) {
    setState(() {
      _respostaSelecionada = index;
      _tentativas++;

      if (index == _respostaCorretaIndex) {
        _fluxoAcerto();
      } else {
        _fluxoErro();
      }
    });
  }

  void _fluxoAcerto() {
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NarradorScreen(
            tituloAppBar: "Resposta Correta!",
            imagemFundo: "assets/biblioteca.png",
            corpoNarracao:
                'Um brilho suave emana das páginas.\n\n'
                'As letras douradas brilham com mais intensidade.\n\n'
                'O guardião parece diferente agora…\n\n',
            dica: 'Toque em Continuar.',
            exibirNarracaoEmCaixa: true,
            proximaTela: DialogoComGuardiao(
              imagemGuardiao: _imagemGuardiao,
              personagemScreen: PersonagemScreen(
                imagemFundo: "assets/biblioteca.png",
                falasConfig: _falasGuardiaoAcerto,
                exibirReacoes: false,
                instrucaoToque: 'Toque para continuar',
                substituirAoAvancarFinal: false,
                proximaTela: _etapaGuardiaoDesaparece(),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _etapaGuardiaoDesaparece() {
    return NarradorScreen(
      tituloAppBar: "O Guardião",
      imagemFundo: "assets/biblioteca.png",
      corpoNarracao:
          'O guardião começa a desaparecer…\n\n'
          'Sua forma se torna translúcida, como névoa '
          'se dissipando na escuridão.\n\n'
          'Pela primeira vez, o ambiente parece '
          'menos opressivo.',
      dica: 'Toque em Continuar.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/biblioteca.png",
        falasConfig: _falasPersonagemAcerto,
        exibirReacoes: true,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapaEncontraItem(),
      ),
    );
  }

  Widget _etapaEncontraItem() {
    return NarradorScreen(
      tituloAppBar: "Item Encontrado!",
      imagemFundo: "assets/biblioteca.png",
      corpoNarracao:
          'Dentro do livro, onde antes só havia texto,\n'
          'agora repousa um objeto pequeno e brilhante.\n\n'
          'Ele pulsa com uma luz suave, como se '
          'estivesse vivo.\n\n'
          'Você encontrou: Fragmento de Chave! 🗝️',
      dica: 'Toque em Continuar para pegar o fragmento.',
      exibirNarracaoEmCaixa: true,
      proximaTela: _etapaPersonagemPegaFragmento(),
    );
  }

  Widget _etapaPersonagemPegaFragmento() {
    return PersonagemScreen(
      imagemFundo: "assets/biblioteca.png",
      falasConfig: _falasPersonagemPegaFragmento,
      exibirReacoes: true,
      instrucaoToque: 'Toque para continuar',
      substituirAoAvancarFinal: false,
      proximaTela: const _RecompensaScreen(
        nomeSala: 'Biblioteca',
        imagemFundo: 'assets/biblioteca.png',
      ),
    );
  }

  void _fluxoErro() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
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
              'RESPOSTA INCORRETA',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 14,
                fontFamily: 'PressStart2P',
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Text(
              'O livro se fecha com força.\n\n'
              'O guardião permanece imóvel.\n\n'
              'Ele parece decepcionado…',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'PressStart2P',
                height: 1.6,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (mounted) {
                setState(() {
                  _respostaSelecionada = null;
                });
              }
            },
            child: const Text(
              'TENTAR NOVAMENTE',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 12,
                fontFamily: 'PressStart2P',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("O Desafio do Guardião"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: GameTimerWidget()),
          ),
        ],
      ),
      body: Background(
        imagem: "assets/biblioteca.png",
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_stories,
                    color: Colors.amber,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Text(
                    _textoCharada,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 13,
                      fontFamily: 'PressStart2P',
                      height: 1.8,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ..._alternativas.asMap().entries.map((entry) {
                  final index = entry.key;
                  final alternativa = entry.value;
                  final selecionada = _respostaSelecionada == index;

                  return GestureDetector(
                    onTap: _respostaSelecionada == null
                        ? () => _verificarResposta(index)
                        : null,
                    child: Container(
                      width: 280,
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: selecionada
                            ? (index == _respostaCorretaIndex
                                      ? Colors.green
                                      : Colors.redAccent)
                                  .withOpacity(0.2)
                            : Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selecionada
                              ? (index == _respostaCorretaIndex
                                    ? Colors.green
                                    : Colors.redAccent)
                              : Colors.white24,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${index == 0 ? 'A' : index == 1 ? 'B' : 'C'})',
                            style: TextStyle(
                              color: selecionada
                                  ? (index == _respostaCorretaIndex
                                        ? Colors.green
                                        : Colors.redAccent)
                                  : Colors.white54,
                              fontSize: 14,
                              fontFamily: 'PressStart2P',
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              alternativa,
                              style: TextStyle(
                                color: selecionada
                                    ? (index == _respostaCorretaIndex
                                          ? Colors.green
                                          : Colors.redAccent)
                                    : Colors.white,
                                fontSize: 12,
                                fontFamily: 'PressStart2P',
                              ),
                            ),
                          ),
                          if (selecionada)
                            Icon(
                              index == _respostaCorretaIndex
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: index == _respostaCorretaIndex
                                  ? Colors.green
                                  : Colors.redAccent,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                if (_tentativas > 0)
                  Text(
                    'Tentativas: $_tentativas',
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontFamily: 'PressStart2P',
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