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
    "Mescla": {"lat": -22.833947164313, "lng": -47.051908251893266},
    "Praça": {"lat": -22.833181245096416, "lng": -47.05207601711004},
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
    'O Mescla não deveria estar vazio...',
    'Essas telas não param...',
    'Nada parece sob controle...',
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

             
                ambienteComValidacao(
                  context,
                  "Mescla",
                  Icons.laptop,
                  const MesclaScreen(),
                  "assets/puc.png",
                  falas: _falasMesclaRelatorio,
                ),

                ambienteComValidacao(
                  context,
                  "Praça",
                  Icons.restaurant,
                  const PracaScreen(),
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
        ),
        child: Column(
          children: [
            Icon(icone, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              nome,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}