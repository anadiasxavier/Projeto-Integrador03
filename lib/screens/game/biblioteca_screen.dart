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

  // Imagem do guardião da biblioteca
  static const String _imagemGuardiao = 'assets/guardia_biblioteca.png';

  // Etapa 1: Guardião aparece e faz sua fala inicial
  static final List<FalaConfig> _falasGuardiaoInicial = [
    FalaConfig.guardiao('Pare.'),
    FalaConfig.guardiao('Este lugar não foi feito para quem apenas passa.'),
    FalaConfig.guardiao('Aqui… nada é entregue de maneira fácil.'),
    FalaConfig.guardiao('Tudo precisa ser conquistado pela compreensão.'),
  ];

  // Etapa 2: Personagem responde ao guardião
  List<FalaConfig> get _falasPersonagem => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Eu só quero sair daqui… Não estou entendendo!',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} Você vai me impedir?',
    ),
  ];

  // Etapa 3: Guardião explica seu papel
  static final List<FalaConfig> _falasGuardiaoResposta = [
    FalaConfig.guardiao('Eu não impeço ninguém.'),
    FalaConfig.guardiao('Sou apenas uma guardiã.'),
    FalaConfig.guardiao('Eu... observo.'),
    FalaConfig.guardiao('Quem não compreende… permanece comigo.'),
    FalaConfig.guardiao('Quem compreende… avança.'),
  ];

  // Etapa 4: Guardião exige que o jogador prove seu conhecimento
  static final List<FalaConfig> _falasGuardiaoProve = [
    FalaConfig.guardiao('Prove seu entendimento.'),
    FalaConfig.guardiao('Responda... e saberá se está pronto para partir.'),
  ];

  // Constrói a tela principal da biblioteca
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior com título e botão de voltar
      appBar: AppBar(
        title: const Text("Biblioteca"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Fundo com a imagem da biblioteca
      body: Background(
        imagem: "assets/biblioteca.png",
        child: Stack(
          children: [
            // Centraliza o conteúdo na tela
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Nome do local
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

                    // Caixa com a descrição do ambiente
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white12),
                      ),
                      // PRIMEIRA TELA APÓS O PERSONAGEM FALAR
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

                    // Botão para investigar o ambiente e iniciar o fluxo
                    GestureDetector(
                      // Clica e cmc o fluxo
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

  // Inicia o fluxo de narrativa da biblioteca -> NarradorScreen que monta
  // Segunda tela após EXPLORAR AMBIENTE
  void _iniciarFluxoBiblioteca(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NarradorScreen(
          tituloAppBar: "Uma Presença...", //Titulo da cena
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

  // Etapa 1: Guardião aparece e faz sua fala inicial
  Widget _etapa1_GuardiaoFalaInicial() {
    return DialogoComGuardiao(
      personagemScreen: PersonagemScreen(
        imagemFundo: "assets/biblioteca.png",
        imagemGuardiao:
            _imagemGuardiao, // adiconando a imagem do guardião no balão de fala dele
        falasConfig: _falasGuardiaoInicial,
        exibirReacoes: false,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapa2_PersonagemResponde(),
      ),
    );
  }

  // Etapa 2: Personagem responde ao guardião
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

  // Etapa 3: Guardião responde ao personagem
  Widget _etapa3_GuardiaoResponde() {
    return DialogoComGuardiao(
      personagemScreen: PersonagemScreen(
        imagemFundo: "assets/biblioteca.png",
        imagemGuardiao:
            _imagemGuardiao, // adiconando a imagem do guardião no balão de fala dele
        falasConfig: _falasGuardiaoResposta,
        exibirReacoes: true,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapa4_LivroCai(),
      ),
    );
  }

  // Etapa 4: Um livro cai misteriosamente da prateleira
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
        personagemScreen: PersonagemScreen(
          imagemFundo: "assets/biblioteca.png",
          imagemGuardiao:
              _imagemGuardiao, // adiconando a imagem do guardião no balão de fala dele
          falasConfig: _falasGuardiaoProve,
          exibirReacoes: false,
          instrucaoToque: 'Toque para continuar',
          substituirAoAvancarFinal: false,
          proximaTela: _etapa5_LivroAbre(),
        ),
      ),
    );
  }

  // Etapa 5: Livro se abre sozinho revelando o enigma
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

  // Retorna a tela de entrada com as primeiras falas do personagem
  static Widget telaEntrada() {
    return const _BibliotecaEntrada();
  }
}

// Tela inicial da biblioteca com as primeiras falas do personagem (Etapa 0)
class _BibliotecaEntrada extends StatelessWidget {
  const _BibliotecaEntrada();

  // Falas do personagem ao entrar na biblioteca pela primeira vez
  List<FalaConfig> get _falasEntrada => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Esse lugar parece abandonado...',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} Mas tenho a sensação de que não estou sozinho.',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Preciso descobrir o que está acontecendo aqui.',
    ),
  ];

  // Mostra as falas iniciais
  @override
  Widget build(BuildContext context) {
    return PersonagemScreen(
      imagemFundo: "assets/biblioteca.png",
      falasConfig: _falasEntrada,
      exibirReacoes: true,
      instrucaoToque: 'Toque para continuar',
      substituirAoAvancarFinal: false,
      proximaTela: const BibliotecaScreen(),
    );
  }
}
