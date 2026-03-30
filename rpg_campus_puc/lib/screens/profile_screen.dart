import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Perfil do Jogador"),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(

          children: [

            CircleAvatar(
              radius: 40,
              child: Icon(Icons.person),
            ),

            SizedBox(height: 20),

            Text("Jogador: Lara"),

            Text("Nível: 3"),

            SizedBox(height: 20),

            LinearProgressIndicator(
              value: 0.6,
            ),

            SizedBox(height: 10),

            Text("Experiência: 60%"),
          ],
        ),
      ),
    );
  }
}