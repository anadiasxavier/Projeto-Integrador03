import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import '../../main.dart';
import '../../models/entidade_dialogo.dart';
import '../game/personagem_screen.dart';
import '../auth/register_screen.dart';

class FinalScreen extends StatelessWidget {
  final List<String> chavesConquistadas;

  const FinalScreen({super.key, required this.chavesConquistadas});

  // Falas do personagem ao final
  List<FalaConfig> get _falasPersonagemFinal => [
    FalaConfig.personagem('[feliz] Consegui! Estou livre!'),
  ];

  // Imagem única com todos os guardiões
  final String _imagemTodosGuardioes = 'assets/final.png';

  // Falas de todos os guardiões (uma única sequência)
  final String _falasTodosGuardioes =
      "Você enfrentou a escuridão, venceu seus medos "
      "e restaurou o que estava perdido. "
      "As chaves abriram mais do que portas... "
      "revelaram sua coragem. "
      "Seu caminho está livre. Siga em frente.";

  void _mostrarDialogoGuardioes(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Background(
            imagem: "assets/pucdia.png",
            child: Stack(
              children: [
                // Imagem com todos os guardiões - VERSÃO RESPONSIVA OTIMIZADA
                Positioned.fill(
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Image.asset(
                          _imagemTodosGuardioes,
                          width: constraints.maxWidth,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                ),
                // Caixa de diálogo com todas as falas
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.55,
                    ),
                    padding: const EdgeInsets.all(24),
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _falasTodosGuardioes,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'PressStart2P',
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // fecha este diálogo
                            _continuarParaPersonagem(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.amber),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "CONTINUAR",
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 12,
                                    fontFamily: 'PressStart2P',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // CONTINUAR PARA IR PARA TELA FINAL DE VITÓRIA
  void _continuarParaPersonagem(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PersonagemScreen(
          imagemFundo: "assets/pucdia.png",
          falasConfig: _falasPersonagemFinal,
          exibirReacoes: true,
          instrucaoToque: 'Toque para continuar',
          substituirAoAvancarFinal: true,
          proximaTela: const _VitoriaScreen(),
        ),
      ),
    );
  }

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
        imagem: "assets/pucdia.png",
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
                    _mostrarDialogoGuardioes(context);
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
      body: Stack(
        children: [
          // IMAGEM DE FUNDO
          Positioned.fill(
            child: Image.asset("assets/pucdia.png", fit: BoxFit.cover),
          ),
          // ESCURECE UM POUCO A IMAGEM PARA O TEXTO FICAR LEGÍVEL
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),
          // CONTEÚDO DA TELA
          Center(
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.vpn_key, color: Colors.amber, size: 50),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: _voltarParaLogin,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 30,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.amber.withOpacity(0.5),
                            width: 1.5,
                          ),
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
        ],
      ),
    );
  }
}
