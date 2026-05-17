import 'package:flutter/material.dart';
import '../services/game_timer_service.dart';

class GameTimerWarningDialog extends StatelessWidget {
  const GameTimerWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 0, 19, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Colors.redAccent,
          width: 3,
        ),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.timer,
            color: Colors.redAccent,
            size: 32,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'TEMPO LIMITADO',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'PressStart2P',
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.redAccent,
                width: 2,
              ),
            ),
            child: const Column(
              children: [
                Text(
                  'Você tem',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: 'PressStart2P',
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '7 MINUTOS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PressStart2P',
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'para explorar o campus e concluir os desafios!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: 'PressStart2P',
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.amber,
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Observe o cronômetro no topo da tela',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 11,
                    fontFamily: 'PressStart2P',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'COMEÇAR',
            style: TextStyle(
              color: Colors.greenAccent,
              fontFamily: 'PressStart2P',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const GameTimerWarningDialog(),
    );
  }
}
