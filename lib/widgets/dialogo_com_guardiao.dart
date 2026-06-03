// lib/widgets/dialogo_com_guardiao.dart
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
    this.opacidade = 0.6,
    this.alturaPercentual = 0.7,
    this.alinhamento = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        personagemScreen,


        Positioned(
          bottom: 95,
          right: -70, // espelhado do personagem
          child: Transform.rotate(
            angle: 0.04, // espelhado do personagem
            child: Container(
              width: 450,
              height: 450,
              padding: const EdgeInsets.all(10),
              child: Opacity(
                opacity: opacidade,
                child: Image.asset(
                  imagemGuardiao,
                  width: 210,
                  height: 210,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox();
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