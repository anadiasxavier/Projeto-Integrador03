import 'package:flutter/material.dart';

class DialogoComGuardiao extends StatelessWidget {
  final Widget personagemScreen;
  final String imagemGuardiao;
  final double opacidade;
  final double alturaPercentual;
  final Alignment alinhamento;

  const DialogoComGuardiao({
    super.key,
    required this.personagemScreen,
    this.imagemGuardiao = 'assets/guardia_biblioteca.png',
    this.opacidade = 0.7,
    this.alturaPercentual = 0.5,
    this.alinhamento = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // A tela de diálogo original
        personagemScreen,
        
        // Imagem do guardião no fundo
        Positioned.fill(
          child: Align(
            alignment: alinhamento,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 20),
              child: Opacity(
                opacity: opacidade,
                child: Image.asset(
                  imagemGuardiao,
                  height: MediaQuery.of(context).size.height * alturaPercentual,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback caso a imagem não exista
                    return Container(
                      width: 200,
                      height: 300,
                      color: Colors.transparent,
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white24,
                          size: 100,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}