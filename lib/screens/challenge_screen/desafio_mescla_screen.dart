import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import '../../models/entidade_dialogo.dart';
import '../../main.dart';
import '../game/personagem_screen.dart';
import '../game/exploration_screen.dart';
import '../../services/progress_service.dart';

class MesclaPuzzleScreen extends StatefulWidget {
  const MesclaPuzzleScreen({super.key});

  @override
  State<MesclaPuzzleScreen> createState() => _MesclaPuzzleScreenState();
}

class _MesclaPuzzleScreenState extends State<MesclaPuzzleScreen> {
  bool _travado = false;
  final ProgressService _progress = ProgressService();
  int? _selectedIndex;
  bool _errou = false;

  // FALAS DO PERSONAGEM DEPOIS DE CONCLUIR O DESAFIO DO MESCLA
  List<FalaConfig> get _falasPersonagemFinal => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[feliz]" : "[feliz]"} Funcionou!',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} Espera... tem algo brilhando perto das máquinas',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[feliz]" : "[feliz]"} É um fragmento de chave!',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[feliz]" : "[feliz]"} Com isso, talvez eu consiga acessar o próximo ambiente!',
    ),
  ];

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
    'Programa',
  ];

  // SE ELE ACERTAR A ALTERNATIVA
  void _fluxoAcerto() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PersonagemScreen(
          imagemFundo: "assets/mescla.png",
          falasConfig: _falasPersonagemFinal,
          exibirReacoes: true,
          instrucaoToque: 'Toque para continuar',
          substituirAoAvancarFinal: true,
          proximaTela: _telaFragmentoObtido(),
        ),
      ),
    );
  }

  // Função que salva o progresso localmente e no Firestore
  Future<void> _salvarProgressoERetornar() async {
    try {
      await _progress.marcarSalaConcluida(raJogador, 'Mescla', novasChaves: []);
      await _progress.removerChave(
        raJogador,
        'Mescla',
      ); // ← Remove a chave após concluir
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

  // ───── Decide acerto ou erro ao tocar uma alternativa ────────
  void _selecionarOpcao(int index) async {
    const int indexCorreta = 1; // "Algoritmo"

    if (index == indexCorreta) {
      // acertou alternativa então vai seguir o fluxo de acerto
      setState(() => _selectedIndex = index);
      _fluxoAcerto();
    } else {
      // errou alternativa
      //marca erro e bloqueia
      setState(() {
        _selectedIndex = index;
        _travado = true;
        _errou = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // limpa e libera para nova tentativa
      setState(() {
        _selectedIndex = null;
        _travado = false;
        _errou = false;
      });
    }
  }

  // FRAGMENTO DE CHAVE FOR OBTIDO
  Widget _telaFragmentoObtido() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fragmento de Chave'),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
      ),
      body: Background(
        imagem: 'assets/mescla.png',
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // Animação de entrada do ícone da chave
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

                // Título de parabéns
                const Text(
                  'PARABÉNS!',
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

                // Caixa com a descrição do fragmento
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
                      Text('🗝️', style: TextStyle(fontSize: 40)),
                      SizedBox(height: 10),
                      Text(
                        'Você conseguiu um',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'PressStart2P',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'FRAGMENTO DE CHAVE',
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
                        'As telas voltam a piscar.\n'
                        'O Mescla parece... instável de novo.\n'
                        'Mas agora você tem uma peça a mais para sair daqui.',
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

                // Botão para continuar a jornada
                GestureDetector(
                  onTap: _salvarProgressoERetornar,
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
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.amber,
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'CONTINUAR JORNADA',
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

  // TELA PRINCIPAL DO DESAFIO DO MESCLA
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
      ),
      body: Background(
        imagem: 'assets/mescla.png',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header: ícone + status do sistema ──────────────────────
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.cyan, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.computer,
                        color: Colors.cyan,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        // Centraliza os textos PROCESSO INICIADO / ANÁLISE NECESSÁRIA
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _linhasSistema
                            .map(
                              (linha) => Text(
                                linha,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 8,
                                  fontFamily: 'PressStart2P',
                                  height: 1.7,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 50,
                ), // espaço entre caixa da charada e da analise necessária
                // ── Caixa da charada ────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.cyan.withOpacity(0.35),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    _charada,
                    // Justifica o texto da charada para eliminar o alinhamento torto
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'PressStart2P',
                      height: 1.8,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Alternativas ────────────────────────────────────────────
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(_opcoes.length, (i) {
                      final bool selecionada = _selectedIndex == i;
                      final bool correta = i == 1; // "Algoritmo"
                      final Color corBorda = selecionada
                          ? (correta ? Colors.greenAccent : Colors.redAccent)
                          : Colors.white.withOpacity(0.2);
                      final Color corFundo = selecionada
                          ? (correta
                                ? Colors.green.withOpacity(0.15)
                                : Colors.red.withOpacity(0.15))
                          : Colors.white.withOpacity(0.06);
                      final Color corTexto = selecionada
                          ? (correta ? Colors.greenAccent : Colors.redAccent)
                          : Colors.white;
                      final String letra = ['A', 'B', 'C', 'D'][i];

                      return Padding(
                        // Espaçamento fixo de 10px entre cada alternativa
                        padding: const EdgeInsets.only(
                          bottom: 10,
                        ), // espaço entre as alternativas
                        child: GestureDetector(
                          onTap: (_travado || _selectedIndex != null)
                              ? null
                              : () => _selecionarOpcao(i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: corFundo,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: corBorda, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                // Letra da alternativa
                                Text(
                                  '$letra)',
                                  style: TextStyle(
                                    color: selecionada
                                        ? corTexto
                                        : Colors.white38,
                                    fontSize: 11,
                                    fontFamily: 'PressStart2P',
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Texto da alternativa
                                Expanded(
                                  child: Text(
                                    _opcoes[i],
                                    style: TextStyle(
                                      color: corTexto,
                                      fontSize: 11,
                                      fontFamily: 'PressStart2P',
                                    ),
                                  ),
                                ),
                                if (selecionada)
                                  Icon(
                                    correta ? Icons.check_circle : Icons.cancel,
                                    color: corTexto,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // ── Mensagem de erro estática ─────────────────────────
                if (_errou)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 150),
                    child: Text(
                      'Resposta incorreta! Tente novamente.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontFamily: 'PressStart2P',
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
