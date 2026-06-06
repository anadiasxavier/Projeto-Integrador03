// lib/screens/mescla/mescla_screen.dart
import 'package:flutter/material.dart';
import 'package:rpg_campus_puc/main.dart';
import '../../widgets/background.dart';
import '../../models/entidade_dialogo.dart';
import 'personagem_screen.dart';
import '../challenge_screen/desafio_mescla_screen.dart';

class MesclaScreen extends StatelessWidget {
  const MesclaScreen({super.key});

  // Falas do personagem explorando o Mescla
  static final List<FalaConfig> _falasMescla = [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} O Mescla não deveria estar vazio, mas pelo menos está funcionando',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Essas telas não param... códigos passando, gráficos mudando',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} E mesmo assim, parece que tudo está prestes a sair do controle...',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} Essa máquina ligou sozinha e parou do nada!',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} As luzes estão piscando estranho igual aos outros lugares',
    ),
    // 'Isso não parece normal',
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Esse ambiente inteiro está instável',
    ),

    // GUARDIÃO DO MESCLA
    FalaConfig.guardiao('Parece que conseguiu chegar até aqui...'),
    FalaConfig.guardiao('Mas não se engane, isso é apenas o começo do caminho'),
    FalaConfig.guardiao('O verdadeiro desafio ainda está por vir!'),

    // PERSONAGEM
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} Encontrei o guardião do Mescla!',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Preciso prestar atenção no que ele vai me dizer se eu quiser sair daqui logo...',
    ),

    // GUARDIÃO
    FalaConfig.guardiao(
      'Neste lugar existem regras... lógica... padrões que mantêm tudo em equilíbrio',
    ),
    FalaConfig.guardiao(
      'Mas até mesmo sistemas guiados pela razão podem falhar sem aviso',
    ),
    FalaConfig.guardiao(
      'Descubra minha essência e impeça que os erros se espalhem pelo caminho',
    ),

    // PERSONAGEM
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[confusa]" : "[confuso]"} Esse enigma parece difícil...',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[inquieta]" : "[inquieto]"} Mas preciso concluir o desafio antes que tudo piore!',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mescla"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Background(
        imagem: "assets/mescla.png",
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // TÍTULO
                const Text(
                  "MESCLA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PressStart2P',
                  ),
                ),

                const SizedBox(height: 15),

                // DESCRIÇÃO
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Text(
                    "Os computadores estão ligados.\n"
                    "Telas mostram códigos estranhos.\n"
                    "O sistema parece fora de controle...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontFamily: 'PressStart2P',
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // BOTÃO EXPLORAR
                GestureDetector(
                  onTap: () => _iniciarFluxo(context),
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.cyan.withOpacity(0.4)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.computer, color: Colors.cyan, size: 28),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "EXPLORAR MESCLA",
                              style: TextStyle(
                                color: Colors.cyan,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PressStart2P',
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Investigar os computadores",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _iniciarFluxo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonagemScreen(
          imagemFundo: "assets/mescla.png",
          imagemGuardiao: 'assets/guardiao_mescla.png',
          falasConfig: _falasMescla, // 👈 Mudou para falasConfig
          exibirReacoes: true,
          instrucaoToque: 'Toque para continuar',
          substituirAoAvancarFinal: false,
          proximaTela: const MesclaPuzzleScreen(),
        ),
      ),
    );
  }
}
