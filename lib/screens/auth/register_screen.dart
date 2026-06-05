import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/firestore_service.dart';
import 'register_success_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  // identifica o formulário pra poder validar ele
  final _formKey = GlobalKey<FormState>();
  // O serviço que conversa com o Firebase
  final _firestoreService = FirestoreService();

// controla se está carregando ou não
  bool _isLoading = false;

  String _nome = '';
  String _ra = '';
  String _senha = '';
  String _confirmarSenha = '';

  void _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

     // onSaved -> Pega o que o usuário digitou e copia para a variável
    _formKey.currentState!.save(); // dispara os onSaved de cada campo

    setState(() {
      _isLoading = true;
    });

    try {

      // Verificação de senha
      if (_senha != _confirmarSenha) {
        throw StateError('As senhas não coincidem');
      }

      // Verifica se o RA já existe no Firebase
      var existingPlayer = await _firestoreService.getPlayerByRA(_ra);

      if (existingPlayer != null) {
        throw StateError('RA já cadastrado');
      }

      // Salva o jogador no Firebase
      await _firestoreService.savePlayerData(_ra, {
        'nome': _nome,
        'ra': _ra,
        'senha': _senha,
        'genero': '',
        'nivel': 1,
        'experiencia': 0,

        'localAtual': 'Biblioteca',

        'chaves': [],

        'salasConcluidas': [],
      });
      
      if (!mounted) return;

      // Navega para tela de sucesso
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterSuccessScreen(
            nomePersonagem: _nome,
            ra: _ra,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      final String message = error is StateError
          ? error.message
          : error.toString();

      // Mostra uma mensagem de erro na parte de baixo da tela
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/puc.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(179, 0, 0, 0),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),

              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth > 500
                      ? 500.0
                      : constraints.maxWidth;

                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxWidth,
                    ),

                    child: Form(
                      key: _formKey,
                      autovalidateMode:
                          AutovalidateMode.onUserInteraction,

                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [
                          const Text(
                            'CADASTRO',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'PressStart2P',
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
                            decoration: const InputDecoration(
                              labelText:
                                  'Nome do Personagem',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder:
                                  OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder:
                                  OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(
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

                            // Verifica se o valor está completo

                            validator: (value) =>
                                value!.isEmpty
                                    ? 'Campo obrigatório'
                                    : null,

                            // Guarda o valor na variável
                            onSaved: (value) =>
                                _nome = value!,
                          ),

                          const SizedBox(height: 10),

                          TextFormField(
                            decoration: const InputDecoration(
                              labelText:
                                  'RA (até 8 dígitos)',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder:
                                  OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder:
                                  OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(
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

                            keyboardType:
                                TextInputType.number,

                            //Formatar — o campo de RA só aceita 8 números
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly,
                              LengthLimitingTextInputFormatter(
                                8,
                              ),
                            ],

                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Campo obrigatório';
                              }

                              if (!RegExp(
                                r'^[0-9]{8}$',
                              ).hasMatch(value.trim())) {
                                return 'RA inválido';
                              }

                              return null;
                            },

                            onSaved: (value) =>
                                _ra = value!.trim(),
                          ),

                          const SizedBox(height: 10),

                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Senha',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder:
                                  OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder:
                                  OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(
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
                                value!.length < 6
                                    ? 'Senha deve ter pelo menos 6 caracteres'
                                    : null,

                            onSaved: (value) =>
                                _senha = value!,
                          ),

                          const SizedBox(height: 10),

                          TextFormField(
                            decoration: const InputDecoration(
                              labelText:
                                  'Confirmar Senha',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder:
                                  OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder:
                                  OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(
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
                                _confirmarSenha = value!,
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,

                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : _register,

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
                                    const Size.fromHeight(50),
                              ),

                              // Enquanto está salvando no Firebase, o botão vira um ícone de carregando
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child:
                                          CircularProgressIndicator(
                                        color:
                                            Colors.black,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Cadastrar',
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