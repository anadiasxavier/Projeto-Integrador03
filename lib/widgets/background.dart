import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// IMAGEM DE FUNDO
        Positioned.fill(
          child: Image.asset("assets/puc.png", fit: BoxFit.cover),
        ),

        /// CAMADA ESCURA
        Positioned.fill(child: Container(color: Color.fromRGBO(0, 0, 0, 0.6))),

        /// CONTEÚDO DA TELA
        child,
      ],
    );
  }
}
