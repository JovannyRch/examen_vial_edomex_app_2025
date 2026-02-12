import 'package:audioplayers/audioplayers.dart';

/// Service to manage sound effects throughout the app.
/// Sounds are played when available, but the app won't crash if they're missing.
class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _soundsEnabled = true;

  // Sound file paths
  static const String _tapSound = 'sounds/tap.wav';
  static const String _correctSound = 'sounds/correct.wav';
  static const String _incorrectSound = 'sounds/incorrect.wav';
  static const String _successSound = 'sounds/success.wav';
  static const String _failSound = 'sounds/fail.wav';

  /// Initialize the audio player
  Future<void> initialize() async {
    await _player.setReleaseMode(ReleaseMode.stop);
    await _player.setVolume(1.0);
  }

  /// Toggle sounds on/off
  void toggleSounds(bool enabled) {
    _soundsEnabled = enabled;
  }

  /// Play tap/button press sound
  Future<void> playTap() async {
    if (!_soundsEnabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(_tapSound), volume: 0.3);
    } catch (e) {
      // Sound file not found, fail silently
    }
  }

  /// Play correct answer sound
  Future<void> playCorrect() async {
    if (!_soundsEnabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(_correctSound), volume: 0.6);
    } catch (e) {
      // Sound file not found, fail silently
    }
  }

  /// Play incorrect answer sound
  Future<void> playIncorrect() async {
    if (!_soundsEnabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(_incorrectSound), volume: 0.5);
    } catch (e) {
      // Sound file not found, fail silently
    }
  }

  /// Play success/passed exam sound
  Future<void> playSuccess() async {
    if (!_soundsEnabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(_successSound), volume: 0.7);
    } catch (e) {
      // Sound file not found, fail silently
    }
  }

  /// Play fail/not passed sound
  Future<void> playFail() async {
    if (!_soundsEnabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(_failSound), volume: 0.5);
    } catch (e) {
      // Sound file not found, fail silently
    }
  }

  /// Dispose audio player
  void dispose() {
    _player.dispose();
  }
}
