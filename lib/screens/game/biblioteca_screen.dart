// lib/screens/biblioteca/biblioteca_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../../main.dart';
import '../../models/entidade_dialogo.dart';
import 'narrador_screen.dart';
import 'personagem_screen.dart';
import '../challenge_screen/desafio_biblioteca_screen.dart';
import '../../widgets/dialogo_com_guardiao.dart';

class BibliotecaScreen extends StatelessWidget {
  const BibliotecaScreen({super.key});

  // Imagem guardião
  static const String _imagemGuardiao = 'assets/guardia_biblioteca.png';

  // Etapa 1: Guardião aparece e fala
  static final List<FalaConfig> _falasGuardiaoInicial = [
    FalaConfig.guardiao('Pare.'),
    FalaConfig.guardiao('Este lugar não é feito para quem apenas passa.'),
    FalaConfig.guardiao('Aqui… nada é entregue.'),
    FalaConfig.guardiao('Tudo precisa ser compreendido.'),
  ];

  // Personagem responde ao guardião com reações
  List<FalaConfig> get _falasPersonagem => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Eu só quero sair daqui…',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} Você vai me impedir?',
    ),
  ];

  // Etapa 3: Guardião explica seu papel
  static final List<FalaConfig> _falasGuardiaoResposta = [
    FalaConfig.guardiao('Eu não impeço.'),
    FalaConfig.guardiao('Eu observo.'),
    FalaConfig.guardiao('Quem não entende… permanece.'),
    FalaConfig.guardiao('Quem entende… avança.'),
  ];

  // Etapa 4: Guardião ordena
  static final List<FalaConfig> _falasGuardiaoProve = [
    FalaConfig.guardiao('Prove.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biblioteca"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Background(
        imagem: "assets/biblioteca.png",
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      "BIBLIOTECA CENTRAL",
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
                        "O silêncio é absoluto.\n"
                        "Estantes alinhadas, mesas vazias.\n"
                        "Uma presença fria observa...",
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
                      onTap: () => _iniciarFluxoBiblioteca(context),
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.cyan.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.cyan.withOpacity(0.4),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.explore, color: Colors.cyan, size: 28),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "BIBLIOTECA",
                                  style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'PressStart2P',
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Investigar o ambiente silencioso",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
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
          ],
        ),
      ),
    );
  }

  void _iniciarFluxoBiblioteca(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NarradorScreen(
          tituloAppBar: "Uma Presença...",
          imagemFundo: "assets/biblioteca.png",
          corpoNarracao:
              'Você avança cautelosamente pelo corredor principal.\n\n'
              'De repente, um som seco quebra o silêncio.\n\n'
              'Ao fundo, uma figura esguia surge das sombras. '
              'Veste trajes escuros, e os olhos, fixos em você.\n\n',
          dica: 'Toque em Continuar para ouvir o guardião.',
          exibirNarracaoEmCaixa: true,
          proximaTela: _etapaGuardiaoFalaInicial(),
        ),
      ),
    );
  }

  Widget _etapaGuardiaoFalaInicial() {
    return DialogoComGuardiao(
      imagemGuardiao: _imagemGuardiao,
      personagemScreen: PersonagemScreen(
        imagemFundo: "assets/biblioteca.png",
        falasConfig: _falasGuardiaoInicial,
        exibirReacoes: false,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapaPersonagemResponde(),
      ),
    );
  }

  Widget _etapaPersonagemResponde() {
    return PersonagemScreen(
      imagemFundo: "assets/biblioteca.png",
      falasConfig: _falasPersonagem,
      exibirReacoes: true,
      instrucaoToque: 'Toque para continuar',
      substituirAoAvancarFinal: false,
      proximaTela: _etapaGuardiaoResponde(),
    );
  }

  Widget _etapaGuardiaoResponde() {
    return DialogoComGuardiao(
      imagemGuardiao: _imagemGuardiao,
      personagemScreen: PersonagemScreen(
        imagemFundo: "assets/biblioteca.png",
        falasConfig: _falasGuardiaoResposta,
        exibirReacoes: false,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapaLivroCai(),
      ),
    );
  }

  Widget _etapaLivroCai() {
    return NarradorScreen(
      tituloAppBar: "O Livro",
      imagemFundo: "assets/biblioteca.png",
      corpoNarracao:
          'Um livro cai de uma prateleira próxima.\n\n'
          'Ele aterrissa aos seus pés, fechado.\n\n'
          'O guardião permanece imóvel, seus olhos '
          'fixos em você.',
      dica: 'Toque em Continuar.',
      exibirNarracaoEmCaixa: true,
      proximaTela: DialogoComGuardiao(
        imagemGuardiao: _imagemGuardiao,
        personagemScreen: PersonagemScreen(
          imagemFundo: "assets/biblioteca.png",
          falasConfig: _falasGuardiaoProve,
          exibirReacoes: false,
          instrucaoToque: 'Toque para continuar',
          substituirAoAvancarFinal: false,
          proximaTela: _etapaLivroAbre(),
        ),
      ),
    );
  }

  Widget _etapaLivroAbre() {
    return NarradorScreen(
      tituloAppBar: "O Livro Misterioso",
      imagemFundo: "assets/biblioteca.png",
      corpoNarracao:
          'O livro se abre sozinho…\n\n'
          'As páginas viram lentamente, como se '
          'algo invisível as folheasse.\n\n'
          'Elas param em uma página específica.\n\n'
          'Há um texto escrito em letras douradas '
          'que brilham fracamente na escuridão…',
      dica: 'Toque em Continuar para ver o enigma.',
      exibirNarracaoEmCaixa: true,
      proximaTela: const DesafioBibliotecaScreen(),
    );
  }
}