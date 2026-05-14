import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../game/exploration_screen.dart';
import 'gender_selection_screen.dart';
import '../../main.dart' as main_app;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService =
      FirestoreService();

  String _ra = '';
  String _senha = '';

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var playerData =
          await _firestoreService.getPlayerByRA(
        _ra,
      );

      if (playerData != null &&
          playerData['senha'] == _senha) {
        main_app.nomeJogador =
            playerData['nome'];

        main_app.generoJogador =
            playerData['genero'] ??
                'masculino';

        String genero =
            playerData['genero'] ?? '';

        if (genero.isEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  GenderSelectionScreen(ra: _ra),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const ExplorationScreen(),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content:
                Text('RA ou senha inválidos'),
          ),
        );
      }
    }
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
            child: Padding(
              padding:
                  const EdgeInsets.all(16.0),

              child: Form(
                key: _formKey,

                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    const Text(
                      "CONTINUAR JOGO",
                      style: TextStyle(
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

                    TextFormField(
                      decoration:
                          const InputDecoration(
                        labelText: 'RA',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder:
                            OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                Colors.white,
                          ),
                        ),
                        focusedBorder:
                            OutlineInputBorder(
                          borderSide:
                              BorderSide(
                            color:
                                Color.fromARGB(
                              255,
                              255,
                              213,
                              0,
                            ),
                          ),
                        ),
                      ),

                      style: const TextStyle(
                        color: Colors.white,
                      ),

                      validator: (value) =>
                          value!.isEmpty
                              ? 'Campo obrigatório'
                              : null,

                      onSaved: (value) =>
                          _ra = value!,
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      decoration:
                          const InputDecoration(
                        labelText: 'Senha',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder:
                            OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                Colors.white,
                          ),
                        ),
                        focusedBorder:
                            OutlineInputBorder(
                          borderSide:
                              BorderSide(
                            color:
                                Color.fromARGB(
                              255,
                              255,
                              213,
                              0,
                            ),
                          ),
                        ),
                      ),

                      style: const TextStyle(
                        color: Colors.white,
                      ),

                      obscureText: true,

                      validator: (value) =>
                          value!.isEmpty
                              ? 'Campo obrigatório'
                              : null,

                      onSaved: (value) =>
                          _senha = value!,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: _login,

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(
                            255,
                            255,
                            213,
                            0,
                          ),
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          minimumSize:
                              const Size.fromHeight(
                            50,
                          ),
                        ),

                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            fontFamily:
                                'PressStart2P',
                            color:
                                Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
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