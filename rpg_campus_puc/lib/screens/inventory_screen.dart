import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {

  final itens = [
    "Livro antigo",
    "Chave misteriosa",
    "Mapa do campus"
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Inventário"),
      ),

      body: GridView.builder(

        padding: EdgeInsets.all(20),

        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),

        itemCount: itens.length,

        itemBuilder: (context, index) {

          return Card(
            child: Center(
              child: Text(itens[index]),
            ),
          );
        },
      ),
    );
  }
}