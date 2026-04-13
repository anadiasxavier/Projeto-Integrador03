import 'package:flutter/material.dart';
import 'exploration_screen.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Icon(Icons.auto_stories,
                  size: 100,
                  color: Colors.amber),

              SizedBox(height: 20),

              Text(
                "RPG Campus PUC",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 40),

              ElevatedButton(
                child: Text("Iniciar Exploração"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExplorationScreen(),
                    ),
                  );
                },
              ),

              SizedBox(height: 10),

              ElevatedButton(
                child: Text("Continuar Jogo"),
                onPressed: () {},
              ),

            ],
          ),
        ),
      ),
    );
  }
}