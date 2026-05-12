import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../game/exploration_screen.dart';
import '../../main.dart' as main_app;

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  String _genero = 'masculino';
  String _nome = '';

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  void _loadPlayerData() async {
    var user = _authService.currentUser;
    if (user != null) {
      var data = await _firestoreService.getPlayerData(user.uid);
      if (data != null) {
        setState(() {
          _nome = data['nome'];
        });
      }
    }
  }

  void _saveGender() async {
    var user = _authService.currentUser;
    if (user != null) {
      await _firestoreService.updatePlayerData(user.uid, {'genero': _genero});
      // Atualizar variáveis globais
      main_app.generoJogador = _genero;
      main_app.nomeJogador = _nome;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ExplorationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/puc.png", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bem-vindo, $_nome!",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PressStart2P',
                    color: Color.fromARGB(255, 255, 213, 0),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Escolha o sexo do seu personagem:",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _genero = 'masculino'),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _genero == 'masculino'
                              ? Colors.blue
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/personagem.png",
                              width: 100,
                              height: 100,
                            ),
                            const Text(
                              "Masculino",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => setState(() => _genero = 'feminino'),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _genero == 'feminino'
                              ? Colors.pink
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/personagemfeminina.png",
                              width: 100,
                              height: 100,
                            ),
                            const Text(
                              "Feminino",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveGender,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 213, 0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Começar Aventura',
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
