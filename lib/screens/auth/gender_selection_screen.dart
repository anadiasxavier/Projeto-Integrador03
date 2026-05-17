import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../game/exploration_screen.dart';
import '../../main.dart' as main_app;
import '../game/intro_screen.dart';

class GenderSelectionScreen extends StatefulWidget {
  final String ra;

  const GenderSelectionScreen({
    super.key,
    required this.ra,
  });

  @override
  _GenderSelectionScreenState createState() =>
      _GenderSelectionScreenState();
}

class _GenderSelectionScreenState
    extends State<GenderSelectionScreen> {

  final _firestoreService =
      FirestoreService();

  String _genero = 'masculino';
  String _nome = '';

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  void _loadPlayerData() async {
    var data =
        await _firestoreService.getPlayerByRA(
      widget.ra,
    );

    if (data != null) {
      setState(() {
        _nome = data['nome'];
      });
    }
  }

  void _saveGender() async {
    await _firestoreService.updatePlayerData(
      widget.ra,
      {
        'genero': _genero,
      },
    );

    main_app.generoJogador = _genero;
    main_app.nomeJogador = _nome;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const IntroScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/puc.png",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color:
                  Colors.black.withOpacity(0.7),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [
                Text(
                  "Bem-vindo, $_nome!",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.bold,
                    fontFamily:
                        'PressStart2P',
                    color: Color.fromARGB(
                      255,
                      255,
                      213,
                      0,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Escolha o sexo do seu personagem:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _genero =
                              'masculino';
                        });
                      },

                      child: Container(
                        padding:
                            const EdgeInsets.all(
                          16,
                        ),

                        decoration:
                            BoxDecoration(
                          color: _genero ==
                                  'masculino'
                              ? Colors.blue
                              : Colors.white
                                  .withOpacity(
                                  0.1,
                                ),

                          borderRadius:
                              BorderRadius
                                  .circular(16),
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
                              style: TextStyle(
                                color:
                                    Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _genero =
                              'feminino';
                        });
                      },

                      child: Container(
                        padding:
                            const EdgeInsets.all(
                          16,
                        ),

                        decoration:
                            BoxDecoration(
                          color: _genero ==
                                  'feminino'
                              ? Colors.pink
                              : Colors.white
                                  .withOpacity(
                                  0.1,
                                ),

                          borderRadius:
                              BorderRadius
                                  .circular(16),
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
                              style: TextStyle(
                                color:
                                    Colors.white,
                              ),
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

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(
                      255,
                      255,
                      213,
                      0,
                    ),
                  ),

                  child: const Text(
                    'Começar Aventura',
                    style: TextStyle(
                      color: Colors.black,
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