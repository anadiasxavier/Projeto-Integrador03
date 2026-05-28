// lib/screens/biblioteca/biblioteca_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../../main.dart';
import '../../models/entidade_dialogo.dart';
import 'narrador_screen.dart';
import 'personagem_screen.dart';
import '../challenge_screen/desafio_biblioteca_screen.dart';
import '../../widgets/dialogo_com_guardiao.dart';

// Tela principal da biblioteca
// Controla todo o fluxo de narrativa e interação com o guardião
class BibliotecaScreen extends StatelessWidget {
  const BibliotecaScreen({super.key});

  // Constatntes
  // Imagem do guardião da biblioteca
  static const String _imagemGuardiao = 'assets/guardia_biblioteca.png';

  // Diálogo do fluxo (cronológico)
  // 1: Guardião aparece e faz sua fala inicial
  static final List<FalaConfig> _falasGuardiaoInicial = [
    FalaConfig.guardiao('Pare.'),
    FalaConfig.guardiao('Este lugar não foi feito para quem apenas passa.'),
    FalaConfig.guardiao('Aqui… nada é entregue de maneira fácil.'),
    FalaConfig.guardiao('Tudo precisa ser conquistado pela compreensão.'),
  ];

  // Etapa 2: Personagem responde ao guardião com reações
  List<FalaConfig> get _falasPersonagem => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Eu só quero sair daqui… Não estou entendendo!',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} Você vai me impedir?',
    ),
  ];

  // Etapa 3: Guardião explica seu papel e faz sua resposta
  static final List<FalaConfig> _falasGuardiaoResposta = [
    FalaConfig.guardiao('Eu não impeço ninguém.'),
    FalaConfig.guardiao('Apenas observo.'),
    FalaConfig.guardiao('Quem não compreende… permanece comigo.'),
    FalaConfig.guardiao('Quem compreende… avança.'),
  ];

  // Etapa 4: Guardião ordena que o jogador prove seu conhecimento
  static final List<FalaConfig> _falasGuardiaoProve = [
    FalaConfig.guardiao('Prove seu entendimento.'),
    FalaConfig.guardiao('Responda... e saberá se está pronto para partir.'),
  ];

  // Build principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personalizada
      appBar: AppBar(
        title: const Text("Biblioteca"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // Corpo da tela com background personalizado
      body: Background(
        imagem: "assets/biblioteca.png",
        child: Stack(
          children: [
            // Conteúdo centralizado com scroll
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Título da localização
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

                    // Descrição do ambiente
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

                    // Botão de interação principal
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

  // Métodos de navegação e etapas
  // Inicia o fluxo de narrativa da biblioteca
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
              'Ao fundo, uma figura surge das sombras. '
              'Ela quase não parece real.\n\n',
          dica: 'Toque em Continuar para ouvir o guardião.',
          exibirNarracaoEmCaixa: true,
          proximaTela: _etapa1_GuardiaoFalaInicial(),
        ),
      ),
    );
  }

  // 1: Guardião faz sua fala inicial
  Widget _etapa1_GuardiaoFalaInicial() {
    return DialogoComGuardiao(
      imagemGuardiao: _imagemGuardiao,
      personagemScreen: PersonagemScreen(
        imagemFundo: "assets/biblioteca.png",
        falasConfig: _falasGuardiaoInicial,
        exibirReacoes: false,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapa2_PersonagemResponde(),
      ),
    );
  }

  // 2: Personagem responde ao guardião
  Widget _etapa2_PersonagemResponde() {
    return PersonagemScreen(
      imagemFundo: "assets/biblioteca.png",
      falasConfig: _falasPersonagem,
      exibirReacoes: true,
      instrucaoToque: 'Toque para continuar',
      substituirAoAvancarFinal: false,
      proximaTela: _etapa3_GuardiaoResponde(),
    );
  }

  // 3: Guardião responde à reação do personagem
  Widget _etapa3_GuardiaoResponde() {
    return DialogoComGuardiao(
      imagemGuardiao: _imagemGuardiao,
      personagemScreen: PersonagemScreen(
        imagemFundo: "assets/biblioteca.png",
        falasConfig: _falasGuardiaoResposta,
        exibirReacoes: false,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapa4_LivroCai(),
      ),
    );
  }

  // 4: Livro misterioso cai da prateleira
  Widget _etapa4_LivroCai() {
    return NarradorScreen(
      tituloAppBar: "O Livro",
      imagemFundo: "assets/biblioteca.png",
      corpoNarracao:
          'Um livro cai de uma prateleira próxima.\n\n'
          'Ele aterrissa aos seus pés, fechado.\n\n'
          'O guardião permanece imóvel.',
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
          proximaTela: _etapa5_LivroAbre(),
        ),
      ),
    );
  }

  // 5: Livro se abre revelando o enigma
  Widget _etapa5_LivroAbre() {
    return NarradorScreen(
      tituloAppBar: "O Livro Misterioso",
      imagemFundo: "assets/biblioteca.png",
      corpoNarracao:
          'O livro se abre sozinho…\n\n'
          'As páginas viram lentamente, como se '
          'Algo invisível as folheasse.\n\n'
          'Elas param em uma página específica.\n\n'
          'Há um texto escrito em letras douradas '
          'Que brilham fracamente na escuridão…',
      dica: 'Toque em Continuar para ver o enigma.',
      exibirNarracaoEmCaixa: true,
      proximaTela: const DesafioBibliotecaScreen(),
    );
  }
}