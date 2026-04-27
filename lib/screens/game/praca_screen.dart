import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import 'narrador_screen.dart';
import 'personagem_screen.dart';
import '../challenge_screen/desafio_praca.dart';

class PracaAlimentacaoScreen extends StatelessWidget {
  const PracaAlimentacaoScreen({super.key});

  // Etapa 1: Personagem sente o cheiro e observa o ambiente
  static const List<String> _falasChegada = [
    'Tô chegando na praça de alimentação...',
    '...mas esse cheiro... não é comida...',
    'Tá azedo, velho... quase podre...',
    'As luzes tão piscando, as mesas sujas...',
    'E essas bandejas espalhadas... tem algo muito errado aqui...',
  ];

  // Etapa 2: Personagem reage à sujeira
  static const List<String> _falasNojo = [
    'Que lugar nojento...',
    'Parece que ninguém limpa isso há dias...',
  ];

  // Etapa 3: Personagem ouve sons e se assusta
  static const List<String> _falasSons = [
    'Eu ouvi algo sendo arrastado...',
    'Aquela cadeira se mexeu sozinha...',
    '...e a bandeja caiu...',
    'Mas não tem ninguém aqui...',
    'Tem alguma coisa comigo...',
  ];

  // Etapa 4: Personagem pergunta quem está ali
  static const List<String> _falasQuemTaAi = [
    'Quem tá aí?!',
  ];

  // Etapa 5: Guardião responde enigmaticamente
  static const List<String> _falasGuardiao1 = [
    'Restos...',
    'Decisões...',
    'Escolhas malfeitas...',
  ];

  // Etapa 6: Personagem observa as marcas
  static const List<String> _falasMarcas = [
    'Essas marcas... tão aparecendo sozinhas...',
    'Como se algo estivesse sendo arrastado...',
    'Acho que esse lugar não quer me prender...',
    'Ele quer que eu entenda alguma coisa...',
  ];

  // Etapa 7: Personagem vê o painel se formando
  static const List<String> _falasPainel = [
    'Aquela mesa... tá tremendo...',
    'As bandejas tão se mexendo sozinhas...',
    'Tão se encaixando...',
    'Isso virou um painel...',
    'E esses restos... parecem peças de um quebra-cabeça...',
  ];

  // Etapa 8: Guardião explica o desafio
  static const List<String> _falasGuardiaoDesafio = [
    'Tudo tem um lugar...',
    '...mesmo quando você ignora.',
  ];

  // Etapa 9: Personagem encontra o fragmento
  static const List<String> _falasRecompensa = [
    'O que é isso...?',
    'Tem algo brilhando ali... na mesa.',
    'Eu... acho que isso não estava aqui antes...',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Background(
        imagem: "assets/praca.png",
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    const Text(
                      "PRAÇA DE ALIMENTAÇÃO",
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
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Text(
                        "Luzes instáveis piscam sobre mesas vazias.\n"
                        "Bandejas espalhadas, restos esquecidos.\n"
                        "O silêncio é cortado por sons inexplicáveis...",
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

                    // Botão para iniciar o fluxo linear da história
                    GestureDetector(
                      onTap: () => _iniciarFluxoPraca(context),
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.4),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.explore, color: Colors.orange, size: 28),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "EXPLORAR A PRAÇA",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'PressStart2P',
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Investigar o ambiente abandonado",
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

  void _iniciarFluxoPraca(BuildContext context) {
    // ETAPA 1: Personagem chega e sente o cheiro
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NarradorScreen(
          imagemFundo: "assets/praca.png",
          corpoNarracao:
              'Você empurra a porta de vidro e entra na praça de alimentação.\n\n'
              'O ar está denso, carregado de um odor desagradável. '
              'Não é cheiro de comida fresca... é algo azedo, velho, quase podre.\n\n'
              'As luzes no teto piscam de forma irregular, '
              'lançando sombras que dançam pelas mesas vazias.\n\n'
              'Bandejas estão espalhadas por toda parte, '
              'com restos de comida abandonados há dias.',
          dica: 'Toque em Continuar para observar melhor.',
          exibirNarracaoEmCaixa: true,
          proximaTela: PersonagemScreen(
            imagemFundo: "assets/praca.png",
            falasCustom: _falasChegada,
            instrucaoToque: 'Toque para continuar',
            substituirAoAvancarFinal: false,
            proximaTela: _etapaNojo(),
          ),
        ),
      ),
    );
  }

  // ETAPA 2: Personagem sente nojo
  Widget _etapaNojo() {
    return PersonagemScreen(
      imagemFundo: "assets/praca.png",
      falasCustom: _falasNojo,
      instrucaoToque: 'Toque para continuar',
      substituirAoAvancarFinal: false,
      proximaTela: _etapaSons(),
    );
  }

  // ETAPA 3: Sons e eventos estranhos
  Widget _etapaSons() {
    return NarradorScreen(
      imagemFundo: "assets/praca.png",
      corpoNarracao:
          'Enquanto você observa o ambiente, um som corta o silêncio.\n\n'
          'É algo sendo arrastado lentamente pelo chão.\n\n'
          'Uma cadeira se move sozinha na sua frente, '
          'arrastando-se alguns centímetros para o lado.\n\n'
          'Logo em seguida, uma bandeja cai de uma mesa vazia, '
          'espalhando restos pelo chão com um estrondo metálico.',
      dica: 'Toque em Continuar para reagir.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/praca.png",
        falasCustom: _falasSons,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapaPergunta(),
      ),
    );
  }

  // ETAPA 4: Personagem pergunta quem está ali
  Widget _etapaPergunta() {
    return NarradorScreen(
      imagemFundo: "assets/praca.png",
      corpoNarracao:
          'O ar fica ainda mais pesado.\n\n'
          'Você sente um arrepio percorrer sua espinha.\n\n'
          'Há algo neste lugar. Algo que você não pode ver, '
          'mas que certamente pode ver você.\n\n'
          'Suas palavras ecoam pelo salão vazio...',
      dica: 'Toque em Continuar para ouvir a resposta.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/praca.png",
        falasCustom: _falasQuemTaAi,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapaGuardiaoResponde(),
      ),
    );
  }

  // ETAPA 5: Guardião responde
  Widget _etapaGuardiaoResponde() {
    return NarradorScreen(
      imagemFundo: "assets/praca.png",
      corpoNarracao:
          'Das sombras entre as lanchonetes fechadas, '
          'uma voz ecoa, grave e arrastada.\n\n'
          'Não há ninguém visível, mas as palavras preenchem o ambiente '
          'como se viessem de todos os lados ao mesmo tempo.\n\n'
          'A voz parece antiga, cansada, como se carregasse '
          'o peso de incontáveis repetições...',
      dica: 'Toque em Continuar para ouvir.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/praca.png",
        falasCustom: _falasGuardiao1,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapaMarcas(),
      ),
    );
  }

  // ETAPA 6: Marcas aparecem sozinhas
  Widget _etapaMarcas() {
    return NarradorScreen(
      imagemFundo: "assets/praca.png",
      corpoNarracao:
          'A voz do guardião some, mas algo novo chama sua atenção.\n\n'
          'No chão, marcas começam a surgir do nada.\n\n'
          'São como rastros... algo sendo arrastado, '
          'mas não há nada ali para produzi-las.\n\n'
          'As marcas se formam lentamente, '
          'criando padrões que parecem ter um propósito.',
      dica: 'Toque em Continuar.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/praca.png",
        falasCustom: _falasMarcas,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapaPainel(),
      ),
    );
  }

  // ETAPA 7: Mesa treme e painel se forma
  Widget _etapaPainel() {
    return NarradorScreen(
      imagemFundo: "assets/praca.png",
      corpoNarracao:
          'Uma das mesas no centro da praça começa a tremer.\n\n'
          'As bandejas sobre ela deslizam sozinhas, '
          'os restos de comida se reorganizam.\n\n'
          'Tudo se move como se guiado por mãos invisíveis, '
          'formando um padrão... um painel.\n\n'
          'Os elementos se dispõem como peças de um quebra-cabeça '
          'que espera para ser resolvido.',
      dica: 'Toque em Continuar.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/praca.png",
        falasCustom: _falasPainel,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapaInstrucaoDesafio(),
      ),
    );
  }

  // ETAPA 8: Guardião instrui sobre o desafio
  Widget _etapaInstrucaoDesafio() {
    return NarradorScreen(
      imagemFundo: "assets/praca.png",
      corpoNarracao:
          'O painel à sua frente é formado por bandejas, talheres, '
          'restos de comida e objetos desorganizados.\n\n'
          'Cada peça parece querer estar em um lugar específico, '
          'como se a ordem original tivesse sido quebrada.\n\n'
          'A voz do guardião ecoa novamente, '
          'trazendo consigo o peso de um aviso.',
      dica: 'Toque em Continuar para ouvir o guardião.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/praca.png",
        falasCustom: _falasGuardiaoDesafio,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: const DesafioPracaScreen(),
      ),
    );
  }

  // Método público para ser chamado quando o jogador acerta
  static Widget telaAcerto() {
    return NarradorScreen(
      imagemFundo: "assets/praca.png",
      corpoNarracao:
          'O painel se reorganiza perfeitamente.\n\n'
          'Um brilho suave emana da mesa, e um fragmento luminoso '
          'se materializa sobre ela.\n\n'
          'O guardião observa em silêncio enquanto a personagem '
          'se aproxima para recolher sua recompensa.',
      dica: 'Toque em Continuar.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/praca.png",
        falasCustom: _falasRecompensa,
        instrucaoToque: 'Toque para coletar o fragmento',
        substituirAoAvancarFinal: true,
        // proximaTela deve ser definida conforme a progressão do jogo
        // Exemplo: proximaTela: MapaScreen() ou ProximaFaseScreen()
      ),
    );
  }

  // Método público para ser chamado quando o jogador erra
  static Widget telaErro() {
    return NarradorScreen(
      imagemFundo: "assets/praca.png",
      corpoNarracao:
          'As peças se embaralham novamente.\n\n'
          'O som de algo sendo arrastado fica mais intenso.\n\n'
          'Marcas no chão se aproximam de você.\n\n'
          'A voz do guardião ecoa com desaprovação...',
      dica: 'Toque em Continuar para tentar novamente.',
      exibirNarracaoEmCaixa: true,
      proximaTela: const DesafioPracaScreen(), // Retorna ao desafio
    );
  }
}