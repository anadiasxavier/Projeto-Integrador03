import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {

  final String texto;

  ChoiceButton({required this.texto});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
        ),

        child: Text(texto),

        onPressed: () {
          print("Escolha: $texto");
        },
      ),
    );
  }
}