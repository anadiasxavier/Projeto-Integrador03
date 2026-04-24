import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import 'arena_screen.dart';
import 'biblioteca_screen.dart';
import 'manacas_screen.dart';
import 'mescla_screen.dart';
import 'praca_screen.dart';
import 'narrador_screen.dart';
import 'personagem_screen.dart';

class ExplorationScreen extends StatelessWidget {
  const ExplorationScreen({super.key});

  static const List<String> _falasMesclaRelatorio = [
    'O Mescla não deveria estar vazio, mas ainda está funcionando.',
    'Essas telas não param, códigos passando, gráficos mudando.',
    'E mesmo assim nada parece sob controle.',
    'Essa máquina ligou sozinha e parou do nada.',
    'As luzes estão piscando estranho.',
    'Isso não parece normal.',
    'Esse lugar não tá estável.',
    'Preciso descobrir o que aconteceu...',
  ];

  static const List<String> _falasEntradaBiblioteca = [
    'Que silêncio... não tem ninguém aqui.',
    'Tá tudo tão organizado, mas algo não parece certo.',
    'Esse silêncio incomoda... não é normal.',
    'Sinto como se tivesse alguém me observando.',
    'Preciso tomar cuidado e explorar com atenção.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exploração do Campus"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
      ),
      body: Background(
        imagem: "assets/puc.png",
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.explore, size: 80, color: Colors.white),
                    const SizedBox(height: 20),
                    const Text(
                      "Explorando o Campus...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PressStart2P',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Defina sua localização atual e comece sua jornada!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 30),

                    // 🔹 BIBLIOTECA
                    buildAmbiente(
                      context,
                      "Biblioteca",
                      Icons.menu_book,
                      const BibliotecaScreen(),
                      "assets/biblioteca.png",
                      corpoNarrador:
                          'Você chega à entrada da biblioteca.\n\n'
                          'O prédio está escuro, mas a porta está entreaberta. '
                          'Um ar frio escapa por ela, trazendo um cheiro de '
                          'papel velho e poeira.\n\n'
                          'O silêncio que vem de dentro é diferente - não é '
                          'apenas ausência de som, é algo mais denso, mais pesado.\n\n'
                          'Você sente um arrepio na espinha, mas algo lhe diz '
                          'que precisa entrar.',
                      dicaNarrador:
                          'Toque em Continuar para entrar na biblioteca.\n\n'
                          'Use a seta para voltar uma etapa na barra superior.\n\n'
                          'Na caixa de diálogo, toque para avançar cada fala.',
                      hintDialogoPersonagem:
                          'Toque nesta caixa para a próxima fala.',
                      falasPersonagem: _falasEntradaBiblioteca,
                      manterEtapaAnteriorNoFinalDasFalas: true,
                      exibirNarracaoEmCaixa: true,
                    ),

                    // 🔹 MANACÁS
                    buildAmbiente(
                      context,
                      "Manacás",
                      Icons.coffee,
                      const ManacasScreen(),
                      "assets/manacas.png",
                    ),

                    // 🔹 MESCLA
                    buildAmbiente(
                      context,
                      "Mescla",
                      Icons.laptop,
                      const MesclaScreen(),
                      "assets/puc.png",
                      corpoNarrador:
                          'Durante a noite, o Mescla deixa de parecer um espaço de colaboração. '
                          'Telas e equipamentos continuam ligados, com códigos e gráficos mudando sozinhos. '
                          'A iluminação fria pisca de forma irregular. '
                          'Máquinas ligam e desligam sem aviso. '
                          'O ambiente parece executar processos fora de controle.',
                      dicaNarrador:
                          'Toque em Continuar para as falas do personagem.\n\n'
                          'Use a seta para voltar uma etapa na barra superior.\n\n'
                          'Na caixa de diálogo, toque para avançar cada fala.',
                      hintDialogoPersonagem:
                          'Toque nesta caixa para a próxima fala.',
                      falasPersonagem: _falasMesclaRelatorio,
                      manterEtapaAnteriorNoFinalDasFalas: true,
                      exibirNarracaoEmCaixa: true,
                    ),

                    // 🔹 PRAÇA DE ALIMENTAÇÃO
                    buildAmbiente(
                      context,
                      "Praça de Alimentação",
                      Icons.restaurant,
                      const PracaScreen(),
                      "assets/praca.png",
                    ),

                    // 🔹 ARENA GAMER
                    buildAmbiente(
                      context,
                      "Arena Gamer",
                      Icons.sports_esports,
                      const ArenaScreen(),
                      "assets/arena.png",
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Versão simplificada do buildAmbiente (sem o parâmetro 'descricao' que não era usado)
Widget buildAmbiente(
  BuildContext context,
  String titulo,
  IconData icone,
  Widget tela,
  String imagemFundo, {
  String? corpoNarrador,
  String? dicaNarrador,
  String? hintDialogoPersonagem,
  List<String>? falasPersonagem,
  bool manterEtapaAnteriorNoFinalDasFalas = false,
  bool exibirNarracaoEmCaixa = false,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NarradorScreen(
            imagemFundo: imagemFundo,
            corpoNarracao: corpoNarrador,
            dica: dicaNarrador,
            exibirNarracaoEmCaixa: exibirNarracaoEmCaixa,
            proximaTela: PersonagemScreen(
              imagemFundo: imagemFundo,
              proximaTela: tela,
              falasCustom: falasPersonagem,
              instrucaoToque: hintDialogoPersonagem,
              substituirAoAvancarFinal: !manterEtapaAnteriorNoFinalDasFalas,
            ),
          ),
        ),
      );
    },
    child: Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icone, color: Colors.white, size: 20),
          const SizedBox(height: 10),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontFamily: 'PressStart2P',
            ),
          ),
        ],
      ),
    ),
  );
}