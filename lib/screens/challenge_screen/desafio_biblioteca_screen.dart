// lib/screens/challenge_screen/desafio_biblioteca_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../../main.dart';
import '../../models/entidade_dialogo.dart';
import '../game/personagem_screen.dart';
import '../game/narrador_screen.dart';
import '../game/exploration_screen.dart';
import '../../services/progress_service.dart';
import '../../widgets/dialogo_com_guardiao.dart';

// CLASSE PRINCIPAL DO DESAFIO
// Tela do desafio da biblioteca onde o jogador responde a charada
class DesafioBibliotecaScreen extends StatefulWidget {
  const DesafioBibliotecaScreen({super.key});

  @override
  State<DesafioBibliotecaScreen> createState() =>
      _DesafioBibliotecaScreenState();
}

class _DesafioBibliotecaScreenState extends State<DesafioBibliotecaScreen>
    with SingleTickerProviderStateMixin {
  
  // Imagem do guardião da biblioteca
  static const String _imagemGuardiao = 'assets/guardia_biblioteca.png';

  // DADOS DO DESAFIO
  // Charada que o jogador precisa responder
  final String _textoCharada =
      'Você chega com fome,\n'
      'escolhe sem pensar muito,\n'
      'e vai embora quando termina.\n\n'
      'Onde isso acontece?';

  // Opções de resposta
  final List<String> _alternativas = [
    'Sala de aula',
    'Praça de alimentação',
    'Laboratório',
  ];

  // A resposta correta é a segunda opção (índice 1)
  final int _respostaCorretaIndex = 1;


  // DIÁLOGOS DO FLUXO DE ACERTO 
  // Etapa 1: Guardião reconhece que o jogador compreendeu
  static final List<FalaConfig> _falasGuardiaoAcerto = [
    FalaConfig.guardiao('Agora sim…'),
    FalaConfig.guardiao('Você não apenas olhou.'),
    FalaConfig.guardiao('Você compreendeu.'),
    FalaConfig.guardiao('Pode seguir seu caminho.'),
  ];

  // Etapa 2: Personagem reage feliz ao acertar
  List<FalaConfig> get _falasPersonagemAcerto => [
        FalaConfig.personagem(
          '${generoJogador == "feminino" ? "[feliz]" : "[feliz]"} Então… era isso…',
        ),
        FalaConfig.personagem(
          '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} Tem algo aqui.',
        ),
      ];

  // Etapa 3: Personagem encontra o fragmento de chave
  List<FalaConfig> get _falasPersonagemPegaFragmento => [
        FalaConfig.personagem(
          '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} Uma... chave?',
        ),
        FalaConfig.personagem(
          '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} Talvez isso me ajude a sair daqui.',
        ),
        FalaConfig.personagem(
          '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} Preciso continuar explorando...',
        ),
      ];

  int? _respostaSelecionada; // Qual alternativa o jogador escolheu
  int _tentativas = 0; // Quantas vezes o jogador tentou


  // Verifica se a resposta do jogador está correta
  void _verificarResposta(int index) {
    setState(() {
      _respostaSelecionada = index; // Marca qual foi escolhida
      _tentativas++; // Aumenta o contador de tentativas

      // Qual a resposta correta
      if (index == _respostaCorretaIndex) {
        _fluxoAcerto(); // Acertou! Vai para o fluxo de vitória
      } else {
        _fluxoErro(); // Errou! Mostra mensagem de erro
      }
    });
  }

  // Fluxo quando o jogador acerta a charada
  void _fluxoAcerto() {
    // Espera meio segundo antes de avançar (para mostrar feedback visual)
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NarradorScreen(
            tituloAppBar: "Resposta Correta!",
            imagemFundo: "assets/biblioteca.png",
            corpoNarracao:
                'Um brilho suave emana das páginas.\n\n'
                'As letras douradas brilham com mais intensidade.\n\n'
                'A figura parece diferente agora…\n\n',
            dica: 'Toque em Continuar.',
            exibirNarracaoEmCaixa: true,
            proximaTela: _etapaAcerto1_GuardiaoFala(), // Vai para o guardião
          ),
        ),
      );
    });
  }

  // Fluxo quando o jogador erra a charada
  void _fluxoErro() {
    showDialog(
      context: context,
      barrierDismissible: false, // Não fecha clicando fora
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        // Título do alerta de erro
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
        // Mensagem de erro
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Text(
              'O livro se fecha com força.\n\n'
              'A guardiã permanece imóvel.\n\n'
              'Ela parece decepcionada…',
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
        // Botão para tentar novamente
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Fecha o alerta
              if (mounted) {
                setState(() {
                  _respostaSelecionada = null; // Limpa a seleção
                });
              }
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

  // ETAPAS DO FLUXO DE ACERTO 
  // Etapa 1: Guardião aparece e parabeniza o jogador
  Widget _etapaAcerto1_GuardiaoFala() {
    return DialogoComGuardiao(
      imagemGuardiao: _imagemGuardiao,
      personagemScreen: PersonagemScreen(
        imagemFundo: "assets/biblioteca.png",
        falasConfig: _falasGuardiaoAcerto,
        exibirReacoes: false,
        instrucaoToque: 'Toque para continuar',
        substituirAoAvancarFinal: false,
        proximaTela: _etapaAcerto2_GuardiaoDesaparece(),
      ),
    );
  }

  // Etapa 2: Guardião desaparece
  Widget _etapaAcerto2_GuardiaoDesaparece() {
    return NarradorScreen(
      tituloAppBar: "O Guardião",
      imagemFundo: "assets/biblioteca.png",
      corpoNarracao:
          'A guardiã começa a desaparecer…\n\n'
          'Sua forma se torna translúcida, como névoa '
          'Se dissipando na escuridão.\n\n'
          'Pela primeira vez, o ambiente parece '
          'menos opressivo.',
      dica: 'Toque em Continuar.',
      exibirNarracaoEmCaixa: true,
      proximaTela: _etapaAcerto3_PersonagemReage(),
    );
  }

  // Etapa 3: Personagem reage ao guardião desaparecer
  Widget _etapaAcerto3_PersonagemReage() {
    return PersonagemScreen(
      imagemFundo: "assets/biblioteca.png",
      falasConfig: _falasPersonagemAcerto,
      exibirReacoes: true,
      instrucaoToque: 'Toque para continuar',
      substituirAoAvancarFinal: false,
      proximaTela: _etapaAcerto4_EncontraItem(),
    );
  }

  // Etapa 4: Fragmento de chave aparece no livro
  Widget _etapaAcerto4_EncontraItem() {
    return NarradorScreen(
      tituloAppBar: "Item Encontrado!",
      imagemFundo: "assets/biblioteca.png",
      corpoNarracao:
          'Dentro do livro, onde antes só havia texto,\n'
          'Agora repousa um objeto pequeno e brilhante.\n\n'
          'Ele pulsa com uma luz suave, como se '
          'Estivesse vivo.\n\n'
          'Você encontrou: Fragmento de Chave!',
      dica: 'Toque em Continuar para pegar o fragmento.',
      exibirNarracaoEmCaixa: true,
      proximaTela: _etapaAcerto5_PersonagemPegaFragmento(),
    );
  }

  // Etapa 5: Personagem pega o fragmento e comenta
  Widget _etapaAcerto5_PersonagemPegaFragmento() {
    return PersonagemScreen(
      imagemFundo: "assets/biblioteca.png",
      falasConfig: _falasPersonagemPegaFragmento,
      exibirReacoes: true,
      instrucaoToque: 'Toque para continuar',
      substituirAoAvancarFinal: false,
      proximaTela: const _RecompensaScreen(
        nomeSala: 'Biblioteca',
        imagemFundo: 'assets/biblioteca.png',
      ),
    );
  }

  // BUILD PRINCIPAL (TELA DO DESAFIO)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior com título e botão de voltar
      appBar: AppBar(
        title: const Text("O Desafio do Guardião"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Fundo da biblioteca
      body: Background(
        imagem: "assets/biblioteca.png",
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Ícone do livro misterioso
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.4),
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

                // Caixa com o texto da charada
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
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

                // Alternativas da charada (botões clicáveis)
                ..._alternativas.asMap().entries.map((entry) {
                  final index = entry.key;
                  final alternativa = entry.value;
                  final selecionada = _respostaSelecionada == index;

                  return GestureDetector(
                    onTap: _respostaSelecionada == null
                        ? () => _verificarResposta(index)
                        : null, // Desabilita depois de escolher
                    // Em cada botão de alternativa
                    child: Container(
                      width: 280,
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        // Muda a cor se foi selecionada
                        color: selecionada
                            ? (index == _respostaCorretaIndex
                                    ? Colors.green // Verde se acertou
                                    : Colors.redAccent) // Vermelho se errou
                                .withOpacity(0.2)
                            : Colors.white.withOpacity(0.08),
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
                          // Letra da alternativa (A, B, C)
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
                          // Texto da alternativa
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
                          // Ícone de check ou X se foi selecionada
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

                // Mostra o número de tentativas
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

// TELA DE RECOMPENSA
// Tela exibida após o jogador completar o desafio com sucesso
class _RecompensaScreen extends StatefulWidget {
  final String nomeSala; // Guarda o nome da sala
  final String imagemFundo;

  // Construtor de classe
  const _RecompensaScreen({
    required this.nomeSala, // Obrigatório informar
    required this.imagemFundo,
  });

  @override
  State<_RecompensaScreen> createState() => _RecompensaScreenState();
}

// O motor que controla a tela
class _RecompensaScreenState extends State<_RecompensaScreen> {
  final ProgressService _progress = ProgressService();

  // Salva o progresso do jogador e volta para a tela de exploração
  void _salvarProgressoEVoltarExploration() async {
    // Marca a sala como concluída e adiciona novas chaves
    try {
      await _progress.marcarSalaConcluida(
        raJogador,
        widget.nomeSala,
        // Chaves que libera
        novasChaves: ['Manacás', 'Mescla', 'Praça', 'Arena'],
      );
      print('Progresso salvo com sucesso!');
    } catch (e) {
      print('Erro ao salvar progresso: $e');
    }

    //Se a tela foi fechada, mount é falso e para por aqui
    if (!mounted) return;

    // Volta para a tela de exploração
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ExplorationScreen()),
      (route) => false, // Remove as telas anteriores da pilha
    );
  }

/////////////////////////////// ANIMAÇÃO FRAGMENTO DE CHAVE ////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior
      appBar: AppBar(
        title: const Text("Fragmento de Chave"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
      ),
      // Fundo com a imagem do local
      body: Background(
        imagem: widget.imagemFundo,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // Animação do fragmento de chave (aumenta de tamanho)
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
                  "PARABÉNS!",
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
                      Text("🗝️", style: TextStyle(fontSize: 40)),
                      SizedBox(height: 10),
                      Text(
                        "Você conseguiu um",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'PressStart2P',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "FRAGMENTO DE CHAVE",
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
                        "Este fragmento é parte de algo maior.\n"
                        "Continue explorando para encontrar\n"
                        "Os outros fragmentos e descobrir\n"
                        "Os segredos deste lugar.",
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
                  onTap: _salvarProgressoEVoltarExploration,
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
                        Icon(Icons.arrow_forward,
                            color: Colors.amber, size: 24),
                        SizedBox(width: 10),
                        Text(
                          "CONTINUAR JORNADA",
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
}