import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import '../../main.dart';
import '../../models/entidade_dialogo.dart';
import '../game/personagem_screen.dart';
import '../auth/register_screen.dart';

class FinalScreen extends StatelessWidget {
  final List<String> chavesConquistadas;

  const FinalScreen({super.key, required this.chavesConquistadas});

  List<FalaConfig> get _falasPersonagemFinal => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[feliz]" : "[feliz]"} '
      '${generoJogador == "feminino" ? "Consegui! Estou livre!" : "Consegui! Estou livre!"}',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("A Saida"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Background(
        imagem: "assets/puc.png",
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        const Color.fromARGB(255, 10, 20, 40).withOpacity(0.9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.8, end: 1.0),
                        duration: const Duration(milliseconds: 2000),
                        builder: (context, value, child) {
                          return Transform.scale(scale: value, child: child);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.amber.withOpacity(0.2),
                                Colors.transparent,
                              ],
                            ),
                            border: Border.all(
                              color: Colors.amber.withOpacity(0.6),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.3),
                                blurRadius: 25,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.vpn_key,
                            color: Colors.amber,
                            size: 70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        "${chavesConquistadas.length}",
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PressStart2P',
                          shadows: [
                            Shadow(color: Colors.amber, blurRadius: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "CHAVES CONQUISTADAS",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PressStart2P',
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: 100,
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.amber.withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Todas as salas foram completadas.\n"
                        "A saida esta proxima.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontFamily: 'PressStart2P',
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonagemScreen(
                          imagemFundo: "assets/puc.png",
                          falasConfig: _falasPersonagemFinal,
                          exibirReacoes: true,
                          instrucaoToque: 'Toque para continuar',
                          substituirAoAvancarFinal: false,
                          proximaTela: const _VitoriaScreen(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber.withOpacity(0.2),
                          Colors.amber.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.15),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_open, color: Colors.amber, size: 28),
                        SizedBox(width: 12),
                        Text(
                          "ABRIR A SAIDA",
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
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VitoriaScreen extends StatefulWidget {
  const _VitoriaScreen();

  @override
  State<_VitoriaScreen> createState() => _VitoriaScreenState();
}

class _VitoriaScreenState extends State<_VitoriaScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _voltarParaLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 19, 48),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color.fromARGB(255, 10, 30, 60),
              Color.fromARGB(255, 0, 19, 48),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 10),
                      Icon(Icons.star, color: Colors.amber, size: 30),
                      SizedBox(width: 10),
                      Icon(Icons.star, color: Colors.amber, size: 20),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(35),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.amber.withOpacity(0.2),
                          Colors.amber.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.6),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.4),
                          blurRadius: 40,
                          spreadRadius: 15,
                        ),
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.2),
                          blurRadius: 80,
                          spreadRadius: 30,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 90,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.amber, Colors.yellow, Colors.amber],
                    ).createShader(bounds),
                    child: const Text(
                      "VOCE VENCEU!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PressStart2P',
                        shadows: [Shadow(color: Colors.amber, blurRadius: 20)],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.03),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Text("🌅", style: TextStyle(fontSize: 50)),
                        SizedBox(height: 15),
                        Text(
                          "Voce escapou da PUC\n"
                          "antes do amanhecer.\n\n"
                          "A liberdade e sua.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'PressStart2P',
                            height: 1.8,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.circle, color: Colors.amber, size: 8),
                            SizedBox(width: 15),
                            Icon(Icons.circle, color: Colors.amber, size: 8),
                            SizedBox(width: 15),
                            Icon(Icons.circle, color: Colors.amber, size: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber.withOpacity(0.2)),
                    ),
                    child: const Text(
                      "FIM DE JOGO",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 12,
                        fontFamily: 'PressStart2P',
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: _voltarParaLogin,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 30,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.withOpacity(0.2),
                            Colors.amber.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.amber, size: 20),
                          SizedBox(width: 10),
                          Text(
                            "SAIR DO JOGO",
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
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
