import 'package:flutter/material.dart';
import '../services/game_timer_service.dart';

class GameTimerWidget extends StatefulWidget {
  const GameTimerWidget({super.key});

  @override
  State<GameTimerWidget> createState() => _GameTimerWidgetState();
}

class _GameTimerWidgetState extends State<GameTimerWidget> {
  final GameTimerService _timerService = GameTimerService();
  late Stream<int> _timerStream;

  @override
  void initState() {
    super.initState();
    _timerStream = _timerService.timerStream;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _timerStream,
      initialData: _timerService.getRemainingSeconds(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.timer, color: Colors.grey, size: 18),
                SizedBox(width: 8),
                Text(
                  '07:00',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PressStart2P',
                  ),
                ),
              ],
            ),
          );
        }

        final remainingSeconds = snapshot.data!;
        final minutes = remainingSeconds ~/ 60;
        final seconds = remainingSeconds % 60;
        final timeString =
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

        // Cores baseadas no tempo restante
        Color timerColor = Colors.greenAccent;
        if (remainingSeconds <= 60) {
          timerColor = Colors.redAccent; // Vermelho quando faltam 1 minuto
        } else if (remainingSeconds <= 180) {
          timerColor = Colors.orangeAccent; // Laranja quando faltam 3 minutos
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: timerColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: timerColor, width: 1.5),
          ),
          child: Row(
            children: [
              Icon(Icons.timer, color: timerColor, size: 18),
              const SizedBox(width: 8),
              Text(
                timeString,
                style: TextStyle(
                  color: timerColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PressStart2P',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
