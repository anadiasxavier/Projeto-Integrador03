import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final String imagem;

  const Background({
    super.key,
    required this.child,
    required this.imagem,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(imagem, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(color: Color.fromRGBO(0, 0, 0, 0.6)),
        ),
        child,
      ],
    );
  }
}