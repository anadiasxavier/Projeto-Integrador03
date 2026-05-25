import 'package:flutter/material.dart';
import 'login_screen.dart';

class RegisterSuccessScreen extends StatelessWidget {
  final String nomePersonagem;
  final String ra;

  const RegisterSuccessScreen({
    super.key,
    required this.nomePersonagem,
    required this.ra,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/puc.png',
              fit: BoxFit.cover,
            ),
          ),

          // Overlay escuro
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(179, 0, 0, 0),
            ),
          ),

          // Conteúdo
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ícone de sucesso
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withOpacity(0.2),
                      border: Border.all(
                        color: Colors.green,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Título de sucesso
                  const Text(
                    'SUCESSO!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PressStart2P',
                      color: Colors.green,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Mensagem de boas-vindas
                  Text(
                    'Bem-vindo(a), $nomePersonagem!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Detalhes do cadastro
                  SizedBox(
                    width: 320, 
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    child: Column(
                      children: [
                        const Text(
                          'Seu cadastro foi realizado com sucesso!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontFamily: 'PressStart2P',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.cyan,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              nomePersonagem,
                              style: const TextStyle(
                                color: Colors.cyan,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.badge,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'RA: $ra',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 40),

                  // Botão para fazer login
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 213, 0),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color.fromARGB(
                              255,
                              255,
                              213,
                              0,
                            ).withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.login,
                              color: Colors.black,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'FAZER LOGIN',
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Mensagem de instrução
                  const Text(
                    'Use suas credenciais para entrar\nno jogo e começar a aventura!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontFamily: 'PressStart2P',
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
