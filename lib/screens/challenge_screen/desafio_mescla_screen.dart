import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import '../../main.dart';
import '../game/personagem_screen.dart';
import '../game/exploration_screen.dart';
import '../../services/progress_service.dart';
import '../../widgets/game_timer_widget.dart';

class MesclaPuzzleScreen extends StatefulWidget {
  const MesclaPuzzleScreen({super.key});

  @override
  State<MesclaPuzzleScreen> createState() => _MesclaPuzzleScreenState();
}

class _MesclaPuzzleScreenState extends State<MesclaPuzzleScreen> {
  bool _travado = false;
  final ProgressService _progress = ProgressService();

  // ⭐ FALAS DO GUARDIÃO COM GÊNERO
  List<String> get _falasGuardiaoFinal => [
    '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} ...PROCESSO CONCLUÍDO.',
    '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Você não respondeu para mim...',
    '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} respondeu para o sistema.',
    '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Siga o fluxo.',
    '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} Onde as máquinas jogam sozinhas...',
    '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} há outra peça esperando.',
  ];

  // ⭐ FALAS DO PERSONAGEM COM GÊNERO
  List<String> get _falasPersonagemFinal => [
    '${generoJogador == "feminino" ? "[feliz]" : "[feliz]"} Funcionou... acho que agora ele me deixou passar...',
    '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} Vejo algo brilhar próximo aos equipamentos.',
    '${generoJogador == "feminino" ? "[feliz]" : "[feliz]"} É um fragmento... de chave!',
    '${generoJogador == "feminino" ? "[determinada]" : "[determinado]"} Preciso continuar minha jornada.',
  ];

  // Tela do computador (sem gênero, é uma mensagem fixa)
  Widget _telaComputadorConcluido() {
    return PersonagemScreen(
      imagemFundo: "assets/mescla.png",
      falasCustom: [
        'Olhando para a tela do computador...',
        'Uma mensagem começa a piscar no monitor:',
        '',
        '    "DESAFIO CONCLUÍDO!"',
        '    "SIGA PARA A PRÓXIMA SALA"',
        '',
        'O sistema parece ter se estabilizado...',
      ],
      instrucaoToque: 'Toque para continuar',
      substituirAoAvancarFinal: true,
      proximaTela: const SizedBox.shrink(),
    );
  }

  static const List<String> _linhasSistema = <String>[
    'PROCESSO INICIADO...',
    'ANÁLISE NECESSÁRIA',
  ];

  static const String _charada =
      'Sou criado para resolver problemas,\n'
      'mas quando estou incompleto,\n'
      'posso gerar mais erros do que soluções.\n\n'
      'Sigo lógica, mas posso falhar sem aviso.\n'
      'O que eu sou?';

  static const List<String> _opcoes = <String>[
    'Máquina',
    'Algoritmo',
    'Energia',
  ];

  void _fluxoAcerto() async {
    // ⭐ FLUXO SEQUENCIAL DE FALAS
    // Primeiro: Falas do Guardião (Sistema)
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PersonagemScreen(
          imagemFundo: "assets/mescla.png",
          falasCustom: _falasGuardiaoFinal, // ⭐ Com gênero
          exibirReacoes: true,
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
          imagemFundo: "assets/mescla.png",
          falasCustom: _falasPersonagemFinal, // ⭐ Com gênero
          exibirReacoes: true,
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

  // Função que salva o progresso localmente e no Firestore
  Future<void> _salvarProgressoERetornar() async {
    try {
      await _progress.marcarSalaConcluida(raJogador, 'Mescla');
      print('Progresso do Mescla salvo com sucesso!');
    } catch (e) {
      print('Erro ao salvar progresso do Mescla: $e');
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

  void _selecionarOpcao(int index) async {
    if (_travado) return;

    final bool ok = index == 1; // "Algoritmo"
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ERRO... ERRO... ERRO...'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _travado = true);
      await Future<void>.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      setState(() => _travado = false);
      return;
    }

    _fluxoAcerto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mescla - Desafio'),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar uma etapa',
          onPressed: () => Navigator.maybePop(context),
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
      body: Background(
        imagem: 'assets/mescla.png',
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 340,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ícone do sistema
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.cyan, width: 2),
                    ),
                    child: const Icon(
                      Icons.computer,
                      color: Colors.cyan,
                      size: 40,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  const Text(
                    'PUZZLE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                  const SizedBox(height: 14),
                  ..._linhasSistema.map(
                    (l) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        l,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontFamily: 'PressStart2P',
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _charada,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'PressStart2P',
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (int i = 0; i < _opcoes.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        onPressed: _travado ? null : () => _selecionarOpcao(i),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withValues(alpha: 0.25),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: i == 1 ? Colors.green.withOpacity(0.5) : Colors.white.withValues(alpha: 0.2),
                              width: i == 1 ? 2 : 1,
                            ),
                          ),
                        ),
                        child: Text(
                          _opcoes[i],
                          style: const TextStyle(
                            fontFamily: 'PressStart2P',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  if (_travado)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Sistema instável... aguarde.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 10,
                          fontFamily: 'PressStart2P',
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