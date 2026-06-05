//vídeo de início
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'exploration_screen.dart';
import '../../main.dart';
import '../../services/firestore_service.dart';
import '../../services/progress_service.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late VideoPlayerController _controller;
  bool _texto1 = false;
  bool _isLoading = true;
  final FirestoreService firestore = FirestoreService();
  final ProgressService _progress = ProgressService();
  bool _transicaoEmAndamento = false;

  @override
  void initState() {
    super.initState();
    _verificarProgresso();
  }

  // Verifica se o jogador tem progresso salvo (local ou Firestore) e decide se mostra o vídeo ou vai direto para a exploração
  Future<void> _verificarProgresso() async {
    try {
      // 1. Verifica cache local primeiro (instantâneo)
      final temLocal = await _progress.temProgressoLocal(raJogador);
      if (temLocal) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            ExplorationScreen.routeName,
            (route) => false,
          );
        }
        return;
      }

      // 2. Fallback: verifica no Firestore
      final dados = await firestore.getPlayerData(raJogador);

      if (dados != null) {
        final salasConcluidas = List<String>.from(
          dados['salasConcluidas'] ?? [],
        );
        final chaves = List<String>.from(dados['chaves'] ?? []);

        if (salasConcluidas.isNotEmpty || chaves.isNotEmpty) {
          // Salva localmente para próximas vezes
          await _progress.salvarLocal(raJogador, chaves, salasConcluidas);

          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              ExplorationScreen.routeName,
              (route) => false,
            );
          }
          return;
        }
      }

      // Se não tem progresso, mostra o vídeo
      if (mounted) {
        setState(() => _isLoading = false);
        _iniciarVideo();
      }
    } catch (e) {
      print('Erro ao verificar progresso: $e');
      // Em caso de erro, mostra o vídeo mesmo assim
      if (mounted) {
        setState(() => _isLoading = false);
        _iniciarVideo();
      }
    }
  }

  // Inicia o vídeo e os textos narrativos, além de configurar o listener para quando o vídeo terminar
  void _iniciarVideo() {
    _controller = VideoPlayerController.asset('assets/bibli.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play();
          _iniciarTextos();
        }
      });

    // Evita múltiplos disparos no fim do vídeo (especialmente no Android).
    _controller.addListener(_onVideoTick);
  }

  void _onVideoTick() {
    if (!mounted || _transicaoEmAndamento) return;
    if (!_controller.value.isInitialized) return;

    final valor = _controller.value;
    if (valor.duration > Duration.zero && valor.position >= valor.duration) {
      _controller.pause();
      _irParaExploration();
    }
  }

  // Quando o vídeo termina, navega diretamente para a tela de exploração
  Future<void> _irParaExploration() async {
    if (_transicaoEmAndamento) return;
    _transicaoEmAndamento = true;

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        ExplorationScreen.routeName,
        (route) => false,
      );
    }
  }

  void _iniciarTextos() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _texto1 = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoTick);
    _controller.dispose();
    super.dispose();
  }

  Widget textoNarrador(String texto, bool visivel) {
    return AnimatedOpacity(
      duration: const Duration(seconds: 1),
      opacity: visivel ? 1 : 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'PressStart2P',
            color: Colors.amber,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.amber)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.value.isInitialized
          ? Stack(
              children: [
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 20,
                  right: 20,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 19, 48).withOpacity(0.95),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber, width: 1),
                      ),
                      child: textoNarrador(
                        "Você acorda sozinho na biblioteca\n\n"
                        "Sua cabeça dói\n\n"
                        "Você sente uma atmosfera estranha...",
                        _texto1,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}