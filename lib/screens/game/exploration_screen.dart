import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../main.dart';
import '../../services/firestore_service.dart';
import '../../services/location_service.dart';
import '../../services/progress_service.dart';
import '../../widgets/background.dart';

import 'arena_screen.dart';
import 'biblioteca_screen.dart';
import 'manacas_screen.dart';
import 'narrador_screen.dart';
import 'praca_screen.dart';
import 'mescla_screen.dart';
import 'final_screen.dart';

/// Tela principal de exploração do campus
class ExplorationScreen extends StatefulWidget {
  static const String routeName = '/exploration';

  const ExplorationScreen({super.key});

  @override
  State<ExplorationScreen> createState() => _ExplorationScreenState();
}

class _ExplorationScreenState extends State<ExplorationScreen> {

  // VARIÁVEIS DE ESTADO
  String localizacaoTexto = "Carregando localização...";
  List<String> chaves = [];
  List<String> salasConcluidas = [];
  static const double _raioAcessoMetros = 30;
  final FirestoreService firestore = FirestoreService();
  final ProgressService _progress = ProgressService();

  
  // COORDENADAS DOS LOCAIS
  static const Map<String, Map<String, double>> locais = {
    "Biblioteca": {"lat": -23.021627474078784, "lng": -46.82875430902276},
    "Manacas": {"lat": -23.021627474078784, "lng": -46.82875430902276},
    "Mescla": {"lat": -23.021627474078784, "lng": -46.82875430902276},
    "Praça": {"lat": -23.021627474078784, "lng": -46.82875430902276},
    "Arena": {"lat": -23.021627474078784, "lng": -46.82875430902276},
  };

  // COORDENADAS REAIS (PUC)
  //"Biblioteca": {"lat": -22.8338, "lng": -47.051930},
  //"Manacás": {"lat": -22.8323, "lng": -47.05144},
  //"Mescla": {"lat": -22.83416204909936, "lng": -47.05235984253339},
  //"Mescla": {"lat": -22.833947164313, "lng": -47.051908251893266}-> correta
  // "Praça": {"lat": -22.8341, "lng": -47.0523566},
  // "Praça": {"lat": -22.94804, "lng": -47.05876294},
  // "Praça": {"lat": -22.833181245096416, "lng": -47.05207601711004},->correta
  //"Arena": {"lat": -22.834067861489412, "lng": -47.052351861193955},


  // CICLO DE VIDA
  @override
  void initState() {
    super.initState();
    carregarLocalizacao();
    carregarProgresso();
  }

  // CARREGAMENTO DE DADOS
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
    // 1. Carrega do cache local imediatamente (sem esperar rede)
    final local = await _progress.carregarLocal(raJogador);
    if (mounted) {
      setState(() {
        chaves = local['chaves']!;
        salasConcluidas = local['salasConcluidas']!;
      });
    }

    // 2. Sincroniza com Firestore em background
    final remoto = await _progress.sincronizarFirestore(raJogador);
    if (remoto != null && mounted) {
      setState(() {
        chaves = remoto['chaves']!;
        salasConcluidas = remoto['salasConcluidas']!;
      });
    }

    _verificarFimDeJogo();
  }

  // VERIFICAÇÕES
  void _verificarFimDeJogo() {
    if (!mounted) return;

    if (salasConcluidas.length >= 5) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FinalScreen(chavesConquistadas: [...chaves, 'Liberdade']),
        ),
        (route) => false,
      );
    }
  }

  // Verifica se a biblioteca foi concluída (primeiro ambiente obrigatório)
  bool bibliotecaFoiConcluida() {
    return salasConcluidas.contains("Biblioteca");
  }

  // Verifica se o jogador já concluiu a sala
  bool salaEstaConcluida(String sala) {
    return salasConcluidas.contains(sala);
  }

  Future<double> distanciaAte(String lugar) async {
    Position pos = await LocationService.getCurrentLocation();
    double lat = locais[lugar]!["lat"]!;
    double lng = locais[lugar]!["lng"]!;
    return Geolocator.distanceBetween(pos.latitude, pos.longitude, lat, lng);
  }

  Future<bool> estaPerto(String lugar) async {
    final distancia = await distanciaAte(lugar);
    return distancia <= _raioAcessoMetros;
  }


  // BUILD PRINCIPAL
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exploração do Campus"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${salasConcluidas.length}/5 Salas",
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PressStart2P',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Background(
        imagem: "assets/puc.png",
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Icon(Icons.explore, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  "Dirija-se até o local "
                  "para iniciar sua aventura.",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  localizacaoTexto,
                  style: const TextStyle(color: Colors.white),
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

  // BOTÕES DOS LOCAIS
  // Botão da biblioteca
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

        // Vai direto para a tela de entrada da biblioteca (com as falas)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BibliotecaScreen.telaEntrada(),
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

  // Botão das Manacás
  Widget _buildBotaoManacas(BuildContext context) {
    bool concluida = salasConcluidas.contains("Manacas");
    bool bibliotecaOK = bibliotecaFoiConcluida();

    return GestureDetector(
      onTap: () async {
        if (!bibliotecaOK) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Complete a Biblioteca primeiro!"),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

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
          MaterialPageRoute(builder: (context) => const ManacasScreen()),
        );
      },
      child: Opacity(
        opacity: concluida ? 0.4 : (bibliotecaOK ? 1 : 0.4),
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
                concluida
                    ? "Manacas\n(CONCLUÍDO)"
                    : (bibliotecaOK ? "Manacas" : "Manacas\n🔒"),
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

  // Botão da Mescla
  Widget _buildBotaoMescla(BuildContext context) {
    bool concluida = salasConcluidas.contains("Mescla");
    bool bibliotecaOK = bibliotecaFoiConcluida();

    return GestureDetector(
      onTap: () async {
        if (!bibliotecaOK) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Complete a Biblioteca primeiro!"),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

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
          MaterialPageRoute(builder: (context) => const MesclaScreen()),
        );
      },
      child: Opacity(
        opacity: concluida ? 0.4 : (bibliotecaOK ? 1 : 0.4),
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
                concluida
                    ? "Mescla\n(CONCLUÍDO)"
                    : (bibliotecaOK ? "Mescla" : "Mescla\n🔒"),
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

  // Botão da Praça
  Widget _buildBotaoPraca(BuildContext context) {
    bool concluida = salasConcluidas.contains("Praça");
    bool bibliotecaOK = bibliotecaFoiConcluida();

    return GestureDetector(
      onTap: () async {
        if (!bibliotecaOK) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Complete a Biblioteca primeiro!"),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        if (concluida) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Esta área já foi concluída."),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        double distancia;
        try {
          distancia = await distanciaAte("Praça");
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erro ao ler localização: $e"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (!mounted) return;

        if (distancia > _raioAcessoMetros) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Você está a ${distancia.toStringAsFixed(0)}m da Praça. Raio atual: ${_raioAcessoMetros.toStringAsFixed(0)}m.",
              ),
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
        opacity: concluida ? 0.4 : (bibliotecaOK ? 1 : 0.4),
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
                concluida
                    ? "Praça\n(CONCLUÍDO)"
                    : (bibliotecaOK ? "Praça" : "Praça\n🔒"),
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

  // Botão da Arena
  Widget _buildBotaoArena(BuildContext context) {
    bool concluida = salasConcluidas.contains("Arena");
    bool bibliotecaOK = bibliotecaFoiConcluida();

    return GestureDetector(
      onTap: () async {
        if (!bibliotecaOK) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Complete a Biblioteca primeiro!"),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

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
        opacity: concluida ? 0.4 : (bibliotecaOK ? 1 : 0.4),
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
                concluida
                    ? "Arena\n(CONCLUÍDO)"
                    : (bibliotecaOK ? "Arena" : "Arena\n🔒"),
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