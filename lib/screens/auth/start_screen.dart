// Tela de abertura do jogo
import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import '../../services/audio_service.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/puc.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final buttonWidth = constraints.maxWidth > 360
                      ? 340.0
                      : constraints.maxWidth * 0.92;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'UMA NOITE NO CAMPUS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PressStart2P',
                          color: Color.fromARGB(255, 255, 213, 0),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () async {
                          await AudioService.instance.playBackgroundMusic(
                            'audio/arena.mp3',
                          );
                          // Tela de Cadastro
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: buttonWidth,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Iniciar Novo Jogo',
                                        style: TextStyle(
                                          fontFamily: 'PressStart2P',
                                          color: Color.fromARGB(
                                            255,
                                            255,
                                            213,
                                            0,
                                          ),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Cadastrar e começar a aventura',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            255,
                                            249,
                                            208,
                                          ),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          await AudioService.instance.playBackgroundMusic(
                            'audio/arena.mp3',
                          );
                          // Tela de Login
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: buttonWidth,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.login,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Continuar Jogo',
                                        style: TextStyle(
                                          fontFamily: 'PressStart2P',
                                          color: Color.fromARGB(
                                            255,
                                            255,
                                            213,
                                            0,
                                          ),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Entrar com conta existente',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            255,
                                            249,
                                            208,
                                          ),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
