// lib/widgets/dialogo_com_guardiao.dart
import 'package:flutter/material.dart';

class DialogoComGuardiao extends StatelessWidget {
  final Widget personagemScreen;
  final String?
  imagemGuardiao; // CORREÇÃO 4: tipo alterado de String para String?
  final double opacidade;
  final double alturaPercentual;
  final Alignment alinhamento;

  const DialogoComGuardiao({
    super.key,
    required this.personagemScreen,
    // CORREÇÃO 4: default removido — cada ambiente deve passar sua própria imagem
    // explicitamente, evitando que o guardião da biblioteca apareça em outros ambientes
    this.imagemGuardiao,
    this.opacidade = 0.6,
    this.alturaPercentual = 0.7,
    this.alinhamento = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        personagemScreen,

        // Só exibe o guardião se uma imagem foi fornecida
        if (imagemGuardiao != null)
          Positioned(
            bottom: 95,
            right: -70,
            child: Transform.rotate(
              angle: 0.04,
              child: Container(
                width: 450,
                height: 450,
                padding: const EdgeInsets.all(10),
                child: Opacity(
                  opacity: opacidade,
                  child: Image.asset(
                    imagemGuardiao!,
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
