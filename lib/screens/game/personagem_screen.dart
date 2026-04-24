import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../../main.dart';

class PersonagemScreen extends StatefulWidget {
  final Widget? proximaTela;
  final String imagemFundo;
  final String? instrucaoToque;
  final List<String>? falasCustom;
  final bool substituirAoAvancarFinal;

  const PersonagemScreen({
    super.key,
    this.proximaTela,
    required this.imagemFundo,
    this.instrucaoToque,
    this.falasCustom,
    this.substituirAoAvancarFinal = true,
  });

  @override
  State<PersonagemScreen> createState() => _PersonagemScreenState();
}

class _PersonagemScreenState extends State<PersonagemScreen> {
  int indice = 0;

  static const List<String> _falasPadrao = [
    "Onde eu estou...?",
    "Isso é o campus?",
    "Está tudo muito estranho...",
    "Preciso descobrir o que aconteceu...",
  ];

  List<String> get _falas => widget.falasCustom ?? _falasPadrao;

  bool get _ultimaFala => indice >= _falas.length - 1;

  void proximaFala() {
    if (!_ultimaFala) {
      setState(() => indice++);
      return;
    }
    if (widget.proximaTela != null) {
      final rota = MaterialPageRoute(
        builder: (context) => widget.proximaTela!,
      );
      if (widget.substituirAoAvancarFinal) {
        Navigator.pushReplacement(context, rota);
      } else {
        Navigator.push(context, rota);
      }
    }
  }

  void _voltarUmaEtapa() {
    if (indice > 0) {
      setState(() => indice--);
    } else {
      Navigator.pop(context);
    }
  }

  String? _textoDicaToque() {
    if (widget.instrucaoToque == null) return null;
    if (widget.proximaTela == null && _ultimaFala) {
      return 'Fim desta parte. Use o botão Voltar acima para retornar à narração.';
    }
    return widget.instrucaoToque;
  }

  String _rotuloPersonagem() {
    final nome = nomeJogador.trim();
    if (nome.isNotEmpty) return nome;
    return generoJogador == "feminino" ? "Você (Ela)" : "Você (Ele)";
  }

  @override
  Widget build(BuildContext context) {
    String imagem = generoJogador == "feminino"
        ? "assets/personagemfeminina.png"
        : "assets/personagem.png";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.88),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back),
          ),
          tooltip: 'Voltar uma etapa',
          onPressed: _voltarUmaEtapa,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Background(
        imagem: widget.imagemFundo,
        child: Stack(
          children: [

            /// CAIXA DE DIÁLOGO
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: proximaFala,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white),
                  ),

                  child: Row(
                    children: [

                      /// PERSONAGEM
                      Image.asset(imagem, width: 70, height: 70),

                      const SizedBox(width: 10),

                      /// TEXTO
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _rotuloPersonagem(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontFamily: 'PressStart2P',
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              _falas[indice],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'PressStart2P',
                              ),
                            ),
                            if (_textoDicaToque() != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.touch_app,
                                    color: Colors.white54,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      _textoDicaToque()!,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
