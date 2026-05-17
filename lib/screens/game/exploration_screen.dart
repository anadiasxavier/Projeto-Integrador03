import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../main.dart';
import '../../services/firestore_service.dart';
import '../../services/location_service.dart';
import '../../widgets/background.dart';

import 'arena_screen.dart';
import 'biblioteca_screen.dart';
import 'manacas_screen.dart';
import 'narrador_screen.dart';
import 'personagem_screen.dart';
import 'praca_screen.dart';
import 'mescla_screen.dart';

class ExplorationScreen extends StatefulWidget {
  static const String routeName = '/exploration';

  const ExplorationScreen({super.key});

  @override
  State<ExplorationScreen> createState() => _ExplorationScreenState();
}

class _ExplorationScreenState extends State<ExplorationScreen> {
  String localizacaoTexto = "Carregando localização...";
  List<String> chaves = [];
  List<String> salasConcluidas = [];
  final FirestoreService firestore = FirestoreService();

  static const Map<String, Map<String, double>> locais = {
    "Biblioteca": {"lat": -23.024319, "lng": -46.850454},
    "Manacas": {"lat": -23.024319, "lng": -46.850454},
    "Mescla": {"lat": -23.024319, "lng": -46.850454},
    "Praça": {"lat": -23.024319, "lng": -46.850454},
    "Arena": {"lat": -23.024319, "lng": -46.850454},
  };

  @override
  void initState() {
    super.initState();
    carregarLocalizacao();
    carregarProgresso();
  }

  void carregarLocalizacao() async {
    try {
      Position pos = await LocationService.getCurrentLocation();
      setState(() {
        localizacaoTexto = "Lat: ${pos.latitude}, Long: ${pos.longitude}";
      });
    } catch (e) {
      setState(() {
        localizacaoTexto = "Erro: $e";
      });
    }
  }

  void carregarProgresso() async {
    final dados = await firestore.getPlayerData(raJogador);
    if (dados != null) {
      setState(() {
        chaves = List<String>.from(dados['chaves'] ?? []);
        salasConcluidas = List<String>.from(dados['salasConcluidas'] ?? []);
      });
    }
  }

  // ⭐ REMOVIDA A VERIFICAÇÃO DE CHAVE - APENAS VERIFICA SE JÁ CONCLUIU
  bool salaEstaConcluida(String sala) {
    return salasConcluidas.contains(sala);
  }

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

  List<String> get _falasMesclaRelatorio => [
    '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} '
        'O Mescla não deveria estar vazio assim.',
    '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} '
        'As telas continuam funcionando.',
    '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} '
        'Nada parece sob controle.',
  ];

  static const List<String> _falasEntradaBiblioteca = [
    'Que silêncio...',
    'Algo não parece certo...',
    'Preciso explorar com cuidado...',
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(
                  Icons.explore,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Dirija-se até o local "
                  "para iniciar sua aventura.",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  localizacaoTexto,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // BIBLIOTECA
                _buildBotaoBiblioteca(context),

                // MANACÁS
                _buildBotaoManacas(context),

                // MESCLA
                _buildBotaoMescla(context),

                // PRAÇA
                _buildBotaoPraca(context),

                // ARENA
                _buildBotaoArena(context),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ⭐ BOTÃO DA BIBLIOTECA
  Widget _buildBotaoBiblioteca(BuildContext context) {
    bool concluida = salasConcluidas.contains("Biblioteca");

    return GestureDetector(
      onTap: () async {
        if (concluida) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Esta área já foi concluída."),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        bool perto = await estaPerto("Biblioteca");
        if (!mounted) return;

        if (!perto) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Você precisa estar em Biblioteca para entrar!"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NarradorScreen(
              imagemFundo: "assets/biblioteca.png",
              proximaTela: PersonagemScreen(
                imagemFundo: "assets/biblioteca.png",
                proximaTela: const BibliotecaScreen(),
                falasCustom: _falasEntradaBiblioteca,
              ),
            ),
          ),
        );
      },
      child: Opacity(
        opacity: concluida ? 0.4 : 1,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              const Icon(Icons.menu_book, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                concluida ? "Biblioteca\n(CONCLUÍDO)" : "Biblioteca",
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
      ),
    );
  }

  // ⭐ BOTÃO DO MANACÁS
  Widget _buildBotaoManacas(BuildContext context) {
    bool concluida = salasConcluidas.contains("Manacas");

    return GestureDetector(
      onTap: () async {
        if (concluida) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Esta área já foi concluída."),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        bool perto = await estaPerto("Manacas");
        if (!mounted) return;

        if (!perto) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Você precisa estar em Manacas para entrar!"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ManacasScreen(),
          ),
        );
      },
      child: Opacity(
        opacity: concluida ? 0.4 : 1,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              const Icon(Icons.coffee, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                concluida ? "Manacas\n(CONCLUÍDO)" : "Manacas",
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
      ),
    );
  }

  // ⭐ BOTÃO DA MESCLA
  Widget _buildBotaoMescla(BuildContext context) {
    bool concluida = salasConcluidas.contains("Mescla");

    return GestureDetector(
      onTap: () async {
        if (concluida) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Esta área já foi concluída."),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        bool perto = await estaPerto("Mescla");
        if (!mounted) return;

        if (!perto) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Você precisa estar em Mescla para entrar!"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MesclaScreen(),
          ),
        );
      },
      child: Opacity(
        opacity: concluida ? 0.4 : 1,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              const Icon(Icons.laptop, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                concluida ? "Mescla\n(CONCLUÍDO)" : "Mescla",
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
      ),
    );
  }

  // ⭐ BOTÃO DA PRAÇA
  Widget _buildBotaoPraca(BuildContext context) {
    bool concluida = salasConcluidas.contains("Praça");

    return GestureDetector(
      onTap: () async {
        if (concluida) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Esta área já foi concluída."),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        bool perto = await estaPerto("Praça");
        if (!mounted) return;

        if (!perto) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Você precisa estar em Praça para entrar!"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NarradorScreen(
              imagemFundo: "assets/praca.png",
              proximaTela: const PracaAlimentacaoScreen(),
            ),
          ),
        );
      },
      child: Opacity(
        opacity: concluida ? 0.4 : 1,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              const Icon(Icons.restaurant, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                concluida ? "Praça\n(CONCLUÍDO)" : "Praça",
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
      ),
    );
  }

  // ⭐ BOTÃO DA ARENA
  Widget _buildBotaoArena(BuildContext context) {
    bool concluida = salasConcluidas.contains("Arena");

    return GestureDetector(
      onTap: () async {
        if (concluida) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Esta área já foi concluída."),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        bool perto = await estaPerto("Arena");
        if (!mounted) return;

        if (!perto) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Você precisa estar em Arena para entrar!"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NarradorScreen(
              imagemFundo: "assets/arena.png",
              proximaTela: const ArenaScreen(),
            ),
          ),
        );
      },
      child: Opacity(
        opacity: concluida ? 0.4 : 1,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              const Icon(Icons.sports_esports, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                concluida ? "Arena\n(CONCLUÍDO)" : "Arena",
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
      ),
    );
  }
}