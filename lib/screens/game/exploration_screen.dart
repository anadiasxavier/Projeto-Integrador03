import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import 'arena_screen.dart';
import 'biblioteca_screen.dart';
import 'manacas_screen.dart';
import 'mescla_screen.dart';
import 'praca_screen.dart';
import 'narrador_screen.dart';
import 'personagem_screen.dart';
import '../../services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class ExplorationScreen extends StatefulWidget {
  const ExplorationScreen({super.key});

  @override
  State<ExplorationScreen> createState() => _ExplorationScreenState();
}

class _ExplorationScreenState extends State<ExplorationScreen> {

  String localizacaoTexto = "Carregando localização...";

  // COORDENADAS REAIS (PUC)
  static const Map<String, Map<String, double>> locais = {
    "Biblioteca": {"lat": -22.8338, "lng": -47.051930},
    "Manacás": {"lat": -22.8323, "lng": -47.05144},
    "Mescla": {"lat": -22.83416204909936, "lng": -47.05235984253339},
    //"Mescla": {"lat": -22.833947164313, "lng": -47.051908251893266},
    "Praça": {"lat": -22.8341, "lng": -47.0523566},
    "Arena": {"lat": -22.834067861489412, "lng": -47.052351861193955},
  };

  // VALIDA DISTÂNCIA
  Future<bool> estaPerto(String lugar) async {
    Position pos = await LocationService.getCurrentLocation();

    double lat = locais[lugar]!["lat"]!;
    double lng = locais[lugar]!["lng"]!;

    double distancia = Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      lat,
      lng,
    );

    return distancia <= 10; 
  }

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
    'Que silêncio...',
    'Algo não parece certo...',
    'Preciso explorar com cuidado...',
  ];

  @override
  void initState() {
    super.initState();
    carregarLocalizacao();
  }

  void carregarLocalizacao() async {
    try {
      Position pos = await LocationService.getCurrentLocation();

      setState(() {
        localizacaoTexto =
            "Lat: ${pos.latitude}, Long: ${pos.longitude}";
      });

    } catch (e) {
      setState(() {
        localizacaoTexto = "Erro: $e";
      });
    }
  }

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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [

                const Icon(Icons.explore, size: 80, color: Colors.white),

                const SizedBox(height: 20),

                const Text(
                  "Explorando o Campus...",
                  style: TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 10),

                Text(
                  localizacaoTexto,
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 30),

              
                ambienteComValidacao(
                  context,
                  "Biblioteca",
                  Icons.menu_book,
                  const BibliotecaScreen(),
                  "assets/biblioteca.png",
                  falas: _falasEntradaBiblioteca,
                ),

              
                ambienteComValidacao(
                  context,
                  "Manacás",
                  Icons.coffee,
                  const ManacasScreen(),
                  "assets/manacas.png",
                ),

              
                buildAmbiente(
                  context,
                  "Mescla",
                  "Laboratório de tecnologia",
                  Icons.laptop,
                  const MesclaScreen(),
                  "assets/mescla.png",
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

                ambienteComValidacao(
                  context,
                  "Praça",
                  Icons.restaurant,
                  const PracaAlimentacaoScreen(),
                  "assets/praca.png",
                ),

               
                ambienteComValidacao(
                  context,
                  "Arena",
                  Icons.sports_esports,
                  const ArenaScreen(),
                  "assets/arena.png",
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //  FUNÇÃO PADRÃO COM VALIDAÇÃO
  Widget ambienteComValidacao(
    BuildContext context,
    String nome,
    IconData icone,
    Widget tela,
    String imagem, {
    List<String>? falas,
  }) {
    return GestureDetector(
      onTap: () async {
        bool podeEntrar = await estaPerto(nome);

        if (!mounted) return;

        if (!podeEntrar) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Você precisa estar em $nome para entrar!"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // ignore: use_build_context_synchronously
        Navigator.push(
          context, // ignore: use_build_context_synchronously
          MaterialPageRoute(
            builder: (context) => NarradorScreen(
              imagemFundo: imagem,
              proximaTela: PersonagemScreen(
                imagemFundo: imagem,
                proximaTela: tela,
                falasCustom: falas,
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
          children: [
            Icon(icone, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              nome,
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

  Widget buildAmbiente(
    BuildContext context,
    String titulo,
    String descricao,
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
          children: [
            Icon(icone, color: Colors.white),
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
}
