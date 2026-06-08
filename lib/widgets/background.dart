import 'package:flutter/material.dart';

// Recebe uma imagem e um child
// Cria um Stack com a imagem cobrindo o fundo com um
// overlay preto com 60% de opacidade por cima (para deixar texto legível)
//e o conteúdo da tela em cima de tudo

class Background extends StatelessWidget {
  final Widget child;
  final String imagem;

  const Background({super.key, required this.child, required this.imagem});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(imagem, fit: BoxFit.cover)),
        Positioned.fill(child: Container(color: Color.fromRGBO(0, 0, 0, 0.6))),
        child,
      ],
    );
  }
}
