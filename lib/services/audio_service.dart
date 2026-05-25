// lib/services/audio_service.dart
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  // Instância única do player
  final AudioPlayer _player = AudioPlayer();
  
  // Construtor privado para o padrão Singleton
  AudioService._internal();
  
  // A instância estática que será compartilhada pelo app todo
  static final AudioService _instance = AudioService._internal();
  
  // Getter para acessar a instância global
  static AudioService get instance => _instance;

  // Toca a música em loop
  Future<void> playBackgroundMusic(String assetPath) async {
    try {
      // Configura para tocar em loop
      await _player.setReleaseMode(ReleaseMode.loop);
      // Inicia a música a partir do arquivo na pasta assets
      await _player.play(AssetSource(assetPath));
      // Ajusta o volume (0.0 a 1.0) - recomendado iniciar com 0.5 para não ofuscar o jogo
      await _player.setVolume(0.5);
      print('Música de fundo iniciada');
    } catch (e) {
      print('Erro ao reproduzir música de fundo: $e');
    }
  }

  // Pausa a música de fundo
  Future<void> pauseBackgroundMusic() async {
    try {
      await _player.pause();
      print('Música de fundo pausada');
    } catch (e) {
      print('Erro ao pausar música de fundo: $e');
    }
  }

  // Retoma a música de fundo
  Future<void> resumeBackgroundMusic() async {
    try {
      await _player.resume();
      print('Música de fundo retomada');
    } catch (e) {
      print('Erro ao retomar música de fundo: $e');
    }
  }

  // Para completamente a música de fundo
  Future<void> stopBackgroundMusic() async {
    try {
      await _player.stop();
      // Opcional: descarta o player completamente, mas em um singleton talvez não seja necessário
      // await _player.dispose();
      print('Música de fundo parada');
    } catch (e) {
      print('Erro ao parar música de fundo: $e');
    }
  }
}
