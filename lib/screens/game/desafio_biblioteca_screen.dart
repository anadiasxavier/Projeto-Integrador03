import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import 'personagem_screen.dart';
import 'narrador_screen.dart';

class DesafioBibliotecaScreen extends StatefulWidget {
  const DesafioBibliotecaScreen({super.key});

  @override
  State<DesafioBibliotecaScreen> createState() =>
      _DesafioBibliotecaScreenState();
}

class _DesafioBibliotecaScreenState extends State<DesafioBibliotecaScreen>
    with SingleTickerProviderStateMixin {
  int? _respostaSelecionada;
  int _tentativas = 0;
  late AnimationController _animacaoController;

  final String _textoCharada =
      '"Você chega com fome,\n'
      'escolhe sem pensar muito,\n'
      'e vai embora quando termina.\n\n'
      'Onde isso acontece?"';

  final List<String> _alternativas = [
    'Sala de aula',
    'Praça de alimentação',
    'Laboratório',
  ];

  final int _respostaCorretaIndex = 1;

  static const List<String> _falasGuardiaoFinal = [
    'Por um breve instante... você compreendeu.',
    'E quando o medo se cala... eu deixo de existir.',
    'Mas não se engane... isso não é o fim...',
    '...apenas o que você conseguiu enxergar.',
  ];

  static const List<String> _falasPersonagemFinal = [
    'Eu... acertei?',
    'Dentro do livro surge um brilho.',
    'Nele... há uma chave.',
    'Consegui! Um Fragmento de Chave!',
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
                'O livro brilha intensamente!\n\n'
                'As letras douradas dançam nas páginas, '
                'reconhecendo a resposta correta.\n\n'
                'O guardião pareceu surpreso... se é que isso é possível '
                'para alguém sem boca.\n\n'
                'O ambiente opressivo começa a se dissipar.',
            dica: 'Toque em Continuar.',
            exibirNarracaoEmCaixa: true,
            proximaTela: PersonagemScreen(
              imagemFundo: "assets/biblioteca.png",
              falasCustom: _falasGuardiaoFinal,
              instrucaoToque: 'Toque para continuar',
              substituirAoAvancarFinal: false,
              proximaTela: PersonagemScreen(
                imagemFundo: "assets/biblioteca.png",
                falasCustom: _falasPersonagemFinal,
                instrucaoToque: 'Toque para continuar',
                substituirAoAvancarFinal: false,
                proximaTela: _telaFragmentoObtido(),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _fluxoErro() {
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
              'O livro se fecha momentaneamente.\n'
              'O guardião permanece imóvel, observando.\n\n'
              'Tente novamente...',
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
              Navigator.pop(context);
              setState(() {
                _respostaSelecionada = null;
              });
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

  Widget _telaFragmentoObtido() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fragmento de Chave"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
      ),
      body: Background(
        imagem: "assets/biblioteca.png",
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber.withValues(alpha: 0.2),
                  border: Border.all(color: Colors.amber, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.3),
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
                "O guardião desapareceu.\n"
                "A biblioteca está em paz agora.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
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
                    color: Colors.white.withValues(alpha: 0.1),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("O Desafio do Guardião"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                    color: Colors.brown.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.4),
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
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.3),
                    ),
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
                                .withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.08),
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