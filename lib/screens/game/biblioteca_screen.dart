import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import 'narrador_screen.dart';
import 'personagem_screen.dart';
import 'desafio_biblioteca_screen.dart';

class BibliotecaScreen extends StatelessWidget {
  const BibliotecaScreen({super.key});

  // Etapa 1: Personagem sente a atmosfera opressiva
  static const List<String> _falasEntrada = [
    'Que silêncio... não tem ninguém aqui.',
    'Tá tudo tão organizado, mas algo não parece certo.',
    'Esse silêncio incomoda... não é normal.',
    'Sinto como se tivesse alguém me observando.',
    'Preciso tomar cuidado e explorar com atenção.',
  ];

  // Etapa 2: Guardião aparece e fala
  static const List<String> _falasGuardiao = [
    'Você ousou entrar...',
    '...mesmo sabendo que aqui o silêncio não é vazio...',
    '...é imposto.',
    'Observe bem... eu não falo... porque não posso.',
    'E talvez... você também não deveria.',
  ];

  // Etapa 3: Personagem reage com medo
  static const List<String> _falasPersonagemMedo = [
    'Me sinto paralisada de medo.',
    'Você também quer me impedir de sair?',
  ];

  // Etapa 4: Guardião fala sobre o livro
  static const List<String> _falasGuardiaoLivro = [
    'Escute... até o silêncio fala aqui.',
    'Os livros... escolhem quando querem ser abertos.',
    'Se caiu diante de você... não foi acaso.',
    'Leia... se tiver coragem de entender.',
  ];

  // Etapa 5: Personagem lê a charada
  static const List<String> _falasLendoCharada = [
    'Um livro caiu bem na minha frente...',
    'Ele se abriu sozinho...',
    'Tem algo escrito aqui:',
    '"Você chega com fome, escolhe sem pensar muito, e vai embora quando termina. Onde isso acontece?"',
    'Não entendo... Ela quer que eu resolva isso?',
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

                    // ÚNICO BOTÃO: Iniciar o fluxo linear da história
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
                                  "EXPLORAR A BIBLIOTECA",
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
    // ETAPA 1: Personagem sente a atmosfera
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NarradorScreen(
          tituloAppBar: "Explorando a Biblioteca",
          imagemFundo: "assets/biblioteca.png",
          corpoNarracao:
              'Você avança cautelosamente pelo corredor principal. '
              'As estantes metálicas se alinham perfeitamente, '
              'carregadas de livros intocados.\n\n'
              'O ar é frio e denso. Cada passo ecoa pelo ambiente vazio.\n\n'
              'O silêncio não é normal. É pesado, opressivo.\n\n'
              'Você sente que não está sozinho...',
          dica: 'Toque em Continuar para seguir explorando.',
          exibirNarracaoEmCaixa: true,
          proximaTela: PersonagemScreen(
            imagemFundo: "assets/biblioteca.png",
            falasCustom: _falasEntrada,
            instrucaoToque: 'Toque para continuar',
            substituirAoAvancarFinal: false,
            proximaTela: _etapaGuardiaoAparece(),
          ),
        ),
      ),
    );
  }

  // ETAPA 2: Guardião aparece
  Widget _etapaGuardiaoAparece() {
    return NarradorScreen(
      tituloAppBar: "Uma Presença...",
      imagemFundo: "assets/biblioteca.png",
      corpoNarracao:
          'De repente, um som seco quebra o silêncio.\n\n'
          'Um livro cai de uma prateleira distante.\n\n'
          'Ao fundo, uma figura esguia surge das sombras. '
          'Veste trajes escuros, sua face está parcialmente oculta.\n\n'
          'Seus olhos perfuram a escuridão, fixos em você.\n\n'
          'Sua boca... está costurada com linha escura.',
      dica: 'Toque em Continuar para ouvir o guardião.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/biblioteca.png",
        falasCustom: _falasGuardiao,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapaPersonagemComMedo(),
      ),
    );
  }

  // ETAPA 3: Personagem reage com medo
  Widget _etapaPersonagemComMedo() {
    return PersonagemScreen(
      imagemFundo: "assets/biblioteca.png",
      falasCustom: _falasPersonagemMedo,
      instrucaoToque: 'Toque para continuar',
      substituirAoAvancarFinal: false,
      proximaTela: _etapaGuardiaoFalaDoLivro(),
    );
  }

  // ETAPA 4: Guardião manda ler o livro
  Widget _etapaGuardiaoFalaDoLivro() {
    return NarradorScreen(
      tituloAppBar: "O Guardião",
      imagemFundo: "assets/biblioteca.png",
      corpoNarracao:
          'O guardião permanece imóvel, mas seus olhos se movem '
          'lentamente em direção ao livro caído.\n\n'
          'Ele ergue a mão pálida, apontando para as páginas abertas '
          'no chão, como se esperasse algo de você.',
      dica: 'Toque em Continuar para ouvir.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/biblioteca.png",
        falasCustom: _falasGuardiaoLivro,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapaLerCharada(),
      ),
    );
  }

  // ETAPA 5: Personagem lê a charada
  Widget _etapaLerCharada() {
    return NarradorScreen(
      tituloAppBar: "O Livro Misterioso",
      imagemFundo: "assets/biblioteca.png",
      corpoNarracao:
          'Um livro antigo está caído no chão, suas páginas abertas.\n\n'
          'Apesar de ninguém tocá-lo, as páginas viram sozinhas, '
          'parando em uma página específica.\n\n'
          'Há um texto escrito em letras douradas que brilham '
          'fracamente na escuridão...',
      dica: 'Toque em Continuar para ler o livro.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/biblioteca.png",
        falasCustom: _falasLendoCharada,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: const DesafioBibliotecaScreen(),
      ),
    );
  }
}
