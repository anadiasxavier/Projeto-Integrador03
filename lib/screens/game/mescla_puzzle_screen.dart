import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import 'narrador_screen.dart';
import 'personagem_screen.dart';
import 'mescla_screen.dart';

class MesclaPuzzleScreen extends StatefulWidget {
  const MesclaPuzzleScreen({super.key});

  @override
  State<MesclaPuzzleScreen> createState() => _MesclaPuzzleScreenState();
}

class _MesclaPuzzleScreenState extends State<MesclaPuzzleScreen> {
  bool _travado = false;

  static const List<String> _falasGuardiaoFinal = <String>[
    '...PROCESSO CONCLUÍDO.',
    'Você não respondeu para mim...',
    'respondeu para o sistema.',
    'Siga o fluxo.',
    'Onde as máquinas jogam sozinhas...',
    'há outra peça esperando.',
  ];

  static const List<String> _falasPersonagemFinal = <String>[
    'Funcionou... acho que agora ele me deixou passar...',
    'Vejo algo brilhar próximo aos equipamentos.',
    'É um fragmento... de chave!',
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
  ];

  void _fluxoAcerto() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => NarradorScreen(
          tituloAppBar: 'Resposta Correta!',
          imagemFundo: 'assets/mescla.png',
          corpoNarracao:
              'A interface estabiliza por um instante.\n\n'
              'Linhas de código param de correr sozinhas.\n'
              'Os gráficos congelam.\n\n'
              '“RESPOSTA ACEITA...”\n'
              '“PROCESSO LIBERADO”\n\n'
              'E então... silêncio.\n'
              'Como se o Mescla tivesse respirado.',
          dica: 'Toque em Continuar.',
          exibirNarracaoEmCaixa: true,
          proximaTela: PersonagemScreen(
            imagemFundo: 'assets/mescla.png',
            falasCustom: _falasGuardiaoFinal,
            instrucaoToque: 'Toque para continuar',
            substituirAoAvancarFinal: false,
            proximaTela: PersonagemScreen(
              imagemFundo: 'assets/mescla.png',
              falasCustom: _falasPersonagemFinal,
              instrucaoToque: 'Toque para continuar',
              substituirAoAvancarFinal: false,
              proximaTela: _telaFragmentoObtido(),
            ),
          ),
        ),
      ),
    );
  }

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
                'FRAGMENTO DE CHAVE\nOBTIDO!',
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
                'As telas voltam a piscar.\n'
                'O Mescla parece... instável de novo.\n'
                'Mas agora você tem uma peça a mais.',
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
                onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
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
                        'VOLTAR AO CAMPUS',
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
              const SizedBox(height: 14),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MesclaScreen()),
                  );
                },
                child: const Text(
                  'Continuar no Mescla',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
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
        title: const Text('Mescla'),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
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
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                        child: Text(_opcoes[i]),
                      ),
                    ),
                  if (_travado)
                    const Text(
                      'Sistema instável... aguarde.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
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

