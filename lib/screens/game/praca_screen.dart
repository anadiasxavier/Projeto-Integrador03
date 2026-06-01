// lib/screens/praca/praca_alimentacao_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../../models/entidade_dialogo.dart';
import '../../main.dart';
import '../../widgets/dialogo_com_guardiao.dart';
import 'narrador_screen.dart';
import 'personagem_screen.dart';
import '../challenge_screen/desafio_praca.dart';

class PracaAlimentacaoScreen extends StatelessWidget {
  const PracaAlimentacaoScreen({super.key});

  static const String _imagemGuardiaoPraca =
      'assets/guardiao/pracaguardiao.png';

  // Etapa 1: Personagem sente o cheiro e observa o ambiente
  List<FalaConfig> get _falasChegada => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Tô chegando na praça de alimentação...',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} ...mas esse cheiro não é comida...',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Tá azedo... tem algo muito errado aqui.',
    ),
  ];

  // Etapa 2: Personagem reage à sujeira
  List<FalaConfig> get _falasNojo => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[triste]" : "[tristeM]"} Que lugar nojento... ninguém limpa isso há dias.',
    ),
  ];

  // Etapa 3: Personagem ouve sons e se assusta
  List<FalaConfig> get _falasSons => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} Eu ouvi algo sendo arrastado...',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} A cadeira se mexeu sozinha... e a bandeja caiu.',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Tem alguma coisa aqui comigo.',
    ),
  ];

  // Etapa 4: Personagem pergunta quem está ali
  List<FalaConfig> get _falasQuemTaAi => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} Quem tá aí?!',
    ),
  ];

  // Etapa 5: Guardião responde enigmaticamente
  static final List<FalaConfig> _falasGuardiao1 = [
    FalaConfig.guardiao('Restos... decisões...'),
    FalaConfig.guardiao('Escolhas malfeitas.'),
  ];

  // Etapa 6: Personagem observa as marcas
  List<FalaConfig> get _falasMarcas => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} Essas marcas estão aparecendo sozinhas...',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Parece que esse lugar quer me mostrar algo.',
    ),
  ];

  // Etapa 7: Personagem vê o painel se formando
  List<FalaConfig> get _falasPainel => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} A mesa tá tremendo... as bandejas estão se mexendo sozinhas.',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} Isso virou um painel...',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Esses restos parecem peças de um quebra-cabeça.',
    ),
  ];

  // Etapa 8: Guardião explica o desafio
  static final List<FalaConfig> _falasGuardiaoDesafio = [
    FalaConfig.guardiao('Tudo tem um lugar...'),
    FalaConfig.guardiao('...mesmo quando você ignora.'),
  ];

  // Etapa 9: Personagem encontra o fragmento
  List<FalaConfig> get _falasRecompensa => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} O que é isso...? Tem algo brilhando na mesa.',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[feliz]" : "[feliz]"} Um fragmento de chave... preciso guardar isso.',
    ),
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
              'Você entra na praça de alimentação e o cheiro é forte, azedo e velho.\n\n'
              'As luzes falham sobre mesas vazias e bandejas esquecidas.',
          dica: 'Toque em Continuar para observar melhor.',
          exibirNarracaoEmCaixa: true,
          proximaTela: PersonagemScreen(
            imagemFundo: "assets/praca.png",
            falasConfig: _falasChegada,
            exibirReacoes: true,
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
      falasConfig: _falasNojo,
      exibirReacoes: true,
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
          'Um som de arrasto corta o silêncio.\n\n'
          'Uma cadeira se move sozinha e uma bandeja cai com estrondo.',
      dica: 'Toque em Continuar para reagir.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/praca.png",
        falasConfig: _falasSons,
        exibirReacoes: true,
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
          'O ar pesa e um arrepio sobe pela sua espinha.\n\n'
          'Algo invisível parece observar cada passo seu.',
      dica: 'Toque em Continuar para ouvir a resposta.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/praca.png",
        falasConfig: _falasQuemTaAi,
        exibirReacoes: true,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapaGuardiaoResponde(),
      ),
    );
  }

  // ETAPA 5: Guardião responde
  Widget _etapaGuardiaoResponde() {
    return DialogoComGuardiao(
      imagemGuardiao: _imagemGuardiaoPraca,
      personagemScreen: PersonagemScreen(
        imagemFundo: "assets/praca.png",
        falasConfig: _falasGuardiao1,
        exibirReacoes: false,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: true,
        proximaTela: _etapaMarcas(),
      ),
    );
  }

  // ETAPA 6: Marcas aparecem sozinhas
  Widget _etapaMarcas() {
    return NarradorScreen(
      imagemFundo: "assets/praca.png",
      corpoNarracao:
          'A voz some e marcas aparecem no chão, sozinhas.\n\n'
          'Os rastros formam um padrão, como se estivessem guiando você.',
      dica: 'Toque em Continuar.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/praca.png",
        falasConfig: _falasMarcas,
        exibirReacoes: true,
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
          'Uma mesa treme no centro da praça.\n\n'
          'Bandejas e restos se reorganizam até virar um painel.',
      dica: 'Toque em Continuar.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/praca.png",
        falasConfig: _falasPainel,
        exibirReacoes: true,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapaInstrucaoDesafio(),
      ),
    );
  }

  // ETAPA 8: Guardião instrui sobre o desafio
  Widget _etapaInstrucaoDesafio() {
    return DialogoComGuardiao(
      imagemGuardiao: _imagemGuardiaoPraca,
      personagemScreen: PersonagemScreen(
        imagemFundo: "assets/praca.png",
        falasConfig: _falasGuardiaoDesafio,
        exibirReacoes: false,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: true,
        proximaTela: const DesafioPracaScreen(),
      ),
    );
  }

  // Método público para ser chamado quando o jogador acerta
  Widget telaAcerto() {
    return NarradorScreen(
      imagemFundo: "assets/praca.png",
      corpoNarracao:
          'O painel se organiza e um brilho surge sobre a mesa.\n\n'
          'Um fragmento de chave aparece diante de você.',
      dica: 'Toque em Continuar.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/praca.png",
        falasConfig: _falasRecompensa,
        exibirReacoes: true,
        instrucaoToque: 'Toque para coletar o fragmento',
        substituirAoAvancarFinal: true,
      ),
    );
  }

  // Método público para ser chamado quando o jogador erra
  static Widget telaErro() {
    return NarradorScreen(
      imagemFundo: "assets/praca.png",
      corpoNarracao:
          'As peças se embaralham outra vez.\n\n'
          'O som de arrasto aumenta e a voz do guardião desaprova.',
      dica: 'Toque em Continuar para tentar novamente.',
      exibirNarracaoEmCaixa: true,
      proximaTela: const DesafioPracaScreen(),
    );
  }
}
