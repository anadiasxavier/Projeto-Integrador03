// Serviço para gerenciar o cronômetro de 7 minutos do jogo
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class GameTimerService {
  static final GameTimerService _instance = GameTimerService._internal();
  factory GameTimerService() => _instance;
  GameTimerService._internal();

  static const int totalSeconds = 7 * 60; // 7 minutos
  int _remainingSeconds = totalSeconds;
  Timer? _timer;
  bool _isRunning = false;
  String? _activeRa;
  int? _endAtMilliseconds;

  // Stream para notificar atualizações do timer
  final StreamController<int> _timerStreamController =
      StreamController<int>.broadcast();
  Stream<int> get timerStream => _timerStreamController.stream;

  // Callback chamado quando o tempo acabar
  Function()? onTimeEnded;

  String _timerEndKey(String ra) => 'game_timer_end_$ra';

  int _calculateRemainingFromEnd(int endAtMs) {
    final diffMs = endAtMs - DateTime.now().millisecondsSinceEpoch;
    if (diffMs <= 0) return 0;
    return (diffMs / 1000).ceil();
  }

  void _emitRemaining() {
    _timerStreamController.add(_remainingSeconds);
  }

  void _startTicker() {
    _timer?.cancel();
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (_endAtMilliseconds == null) return;

      final nextRemaining = _calculateRemainingFromEnd(_endAtMilliseconds!);
      if (nextRemaining != _remainingSeconds) {
        _remainingSeconds = nextRemaining;
        _emitRemaining();
      }

      if (_remainingSeconds <= 0) {
        _timer?.cancel();
        _timer = null;
        _isRunning = false;

        final ra = _activeRa;
        if (ra != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(_timerEndKey(ra));
        }

        onTimeEnded?.call();
      }
    });
  }

  Future<void> _startNewTimer(String ra) async {
    final prefs = await SharedPreferences.getInstance();
    final endAtMs =
        DateTime.now().millisecondsSinceEpoch + totalSeconds * 1000;

    _activeRa = ra;
    _endAtMilliseconds = endAtMs;
    _remainingSeconds = totalSeconds;
    await prefs.setInt(_timerEndKey(ra), endAtMs);
    _emitRemaining();
    _startTicker();
  }

  // Garante que o timer do usuário está ativo sem reiniciar o tempo.
  Future<void> ensureTimerForPlayer(String ra) async {
    if (_activeRa == ra && _isRunning) {
      _remainingSeconds = getRemainingSeconds();
      _emitRemaining();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedEndAt = prefs.getInt(_timerEndKey(ra));
    _activeRa = ra;

    if (savedEndAt == null) {
      await _startNewTimer(ra);
      return;
    }

    _endAtMilliseconds = savedEndAt;
    _remainingSeconds = _calculateRemainingFromEnd(savedEndAt);
    _emitRemaining();

    if (_remainingSeconds <= 0) {
      _isRunning = false;
      await prefs.remove(_timerEndKey(ra));
      onTimeEnded?.call();
      return;
    }

    _startTicker();
  }

  // Inicia o cronômetro
  void startTimer() {
    if (_isRunning) return;

    _isRunning = true;
    _remainingSeconds = totalSeconds;
    _timerStreamController.add(_remainingSeconds);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      _timerStreamController.add(_remainingSeconds);

      if (_remainingSeconds <= 0) {
        stopTimer();
        onTimeEnded?.call();
      }
    });
  }

  // Para o cronômetro
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
  }

  // Retorna o tempo restante formatado (MM:SS)
  String getFormattedTime() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Retorna o tempo restante em segundos
  int getRemainingSeconds() {
    if (_endAtMilliseconds == null) return _remainingSeconds;
    return _calculateRemainingFromEnd(_endAtMilliseconds!);
  }

  // Verifica se o timer está rodando
  bool get isRunning => _isRunning;

  // Reseta o timer
  void resetTimer() {
    stopTimer();
    _remainingSeconds = totalSeconds;
    _timerStreamController.add(_remainingSeconds);
  }

  // Dispose do serviço
  void dispose() {
    _timer?.cancel();
    _timerStreamController.close();
  }
}
