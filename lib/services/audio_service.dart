// lib/services/audio_service.dart
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  AudioService._internal();

  static final AudioService instance = AudioService._internal();

  Future<void> playBackgroundMusic(String assetPath) async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(0.5);
    await _player.play(AssetSource(assetPath));
  }
}
