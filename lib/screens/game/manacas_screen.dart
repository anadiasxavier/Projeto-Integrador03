import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import 'narrador_screen.dart';
import 'personagem_screen.dart';
import '../challenge_screen/desafio_manacas.dart';

class ManacasScreen extends StatelessWidget {
  const ManacasScreen({super.key});

  // TODAS as falas organizadas por etapas

  static const List<String> _falasInicio = [
    'Você não deveria estar aqui.',
    'Me desculpa, eu acabei dormindo na aula e não estou conseguindo ir embora… você pode me ajudar?',
    'Você é engraçada… AQUI ninguém vai embora tão fácil.',
    'O que você quer dizer com isso?',
    'Este lugar mudou… E agora ele escolhe quem pode sair.',
    'Isso não faz sentido… eu só quero ir pra casa!',
    'Então prove.',
  ];

  static const List<String> _falasExplicacao = [
    'Cada lugar deste campus guarda um fragmento…',
    'Memórias esquecidas… erros e decisões.',
    'Se quiser sair… você precisa enfrentar o que está escondido aqui.',
  ];

  static const List<String> _falasDesafio = [
    'Ganhe de mim… e eu te darei a chave para a próxima sala.',
    'Isso só pode ser brincadeira…',
    'Você acha que é apenas um jogo.',
    'Todo jogo aqui cobra um preço.',
    'Tá… é só um jogo… eu consigo fazer isso.',
    'Não se trata de vencer… Se trata de entender.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manacás"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
      ),
      body: Background(
        imagem: "assets/manacas.png",
        child: Center(
          child: GestureDetector(
            onTap: () => _iniciarFluxo(context),
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green),
              ),
              child: const Text(
                "EXPLORAR MANACÁS",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontFamily: 'PressStart2P',
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _iniciarFluxo(BuildContext context) {
    // ETAPA 1
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NarradorScreen(
          imagemFundo: "assets/manacas.png",
          corpoNarracao:
              'Você entra no Manacás.\n\nO ambiente está silencioso demais.\n\nAlgo observa você nas sombras.',
          dica: 'Toque para continuar.',
          exibirNarracaoEmCaixa: true,
          proximaTela: PersonagemScreen(
            imagemFundo: "assets/manacas.png",
            falasCustom: _falasInicio,
            substituirAoAvancarFinal: false,
            proximaTela: _etapaExplicacao(),
          ),
        ),
      ),
    );
  }

  // ETAPA 2
  Widget _etapaExplicacao() {
    return NarradorScreen(
      imagemFundo: "assets/manacas.png",
      corpoNarracao:
          'O guardião se aproxima lentamente.\n\n'
          'Sua presença faz o ar ficar pesado.\n\n'
          'Ele aponta para uma mesa no centro do ambiente...',
      dica: 'Toque para continuar.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/manacas.png",
        falasCustom: _falasExplicacao,
        substituirAoAvancarFinal: false,
        proximaTela: _etapaDesafio(),
      ),
    );
  }

  // ETAPA 3
  Widget _etapaDesafio() {
    return NarradorScreen(
      imagemFundo: "assets/manacas.png",
      corpoNarracao:
          'Sobre a mesa, um tabuleiro começa a se formar sozinho.\n\n'
          'As peças se movem lentamente...\n\n'
          'Um jogo da velha aparece diante de você.',
      dica: 'Toque para começar o desafio.',
      exibirNarracaoEmCaixa: true,
      proximaTela: PersonagemScreen(
        imagemFundo: "assets/manacas.png",
        falasCustom: _falasDesafio,
        substituirAoAvancarFinal: false,
        proximaTela: const DesafioManacasScreen(),
      ),
    );
  }
}