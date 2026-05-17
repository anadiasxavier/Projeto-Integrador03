import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'exploration_screen.dart';
import '../../main.dart';
import '../../services/firestore_service.dart';

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

  @override
  void initState() {
    super.initState();
    _verificarProgresso();
  }

  // ⭐ VERIFICA SE O JOGADOR JÁ TEM PROGRESSO
  Future<void> _verificarProgresso() async {
    try {
      final dados = await firestore.getPlayerData(raJogador);
      
      if (dados != null) {
        final salasConcluidas = List<String>.from(dados['salasConcluidas'] ?? []);
        final chaves = List<String>.from(dados['chaves'] ?? []);
        
        // Se tem alguma sala concluída ou alguma chave, já jogou antes
        if (salasConcluidas.isNotEmpty || chaves.isNotEmpty) {
          print('Jogador já tem progresso: ${salasConcluidas.length} salas concluídas');
          
          // ⭐ PULA O VÍDEO E VAI DIRETO PARA EXPLORATION
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
      
      // ⭐ JOGADOR NOVO - MOSTRA O VÍDEO
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

  void _iniciarVideo() {
    _controller = VideoPlayerController.asset(
      'assets/bibli.mp4',
    )
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play();
          _iniciarTextos();
        }
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          ExplorationScreen.routeName,
          (route) => false,
        );
      }
    });
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
            color: Colors.white,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ⭐ MOSTRA LOADING ENQUANTO VERIFICA O PROGRESSO
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.amber,
          ),
        ),
      );
    }

    // ⭐ JOGADOR NOVO - MOSTRA O VÍDEO
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
                  left: 0,
                  right: 0,
                  child: textoNarrador(
                    "Você acorda sozinho na biblioteca\n\n"
                    "Sua cabeça dói\n\n"
                    "Você sente uma atmosfera estranha...",
                    _texto1,
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}