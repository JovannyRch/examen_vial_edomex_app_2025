import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage sound effects and haptic feedback throughout the app.
/// Sounds are played when available, but the app won't crash if they're missing.
class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  bool get soundsEnabled => _soundsEnabled;
  bool get hapticsEnabled => _hapticsEnabled;

  static const String _soundsKey = 'sounds_enabled';
  static const String _hapticsKey = 'haptics_enabled';

  final AudioPlayer _player = AudioPlayer();
  bool _soundsEnabled = true;
  bool _hapticsEnabled = true;

  // Sound file paths
  static const String _tapSound = 'sounds/tap.wav';
  static const String _correctSound = 'sounds/correct.wav';
  static const String _incorrectSound = 'sounds/incorrect.wav';
  static const String _successSound = 'sounds/success.wav';
  static const String _failSound = 'sounds/fail.wav';

  /// Initialize the audio player and load settings
  Future<void> initialize() async {
    await _player.setReleaseMode(ReleaseMode.stop);
    await _player.setVolume(1.0);
    final prefs = await SharedPreferences.getInstance();
    _soundsEnabled = prefs.getBool(_soundsKey) ?? true;
    _hapticsEnabled = prefs.getBool(_hapticsKey) ?? true;
  }

  /// Toggle sounds on/off
  Future<void> toggleSounds(bool enabled) async {
    _soundsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundsKey, enabled);
  }

  /// Toggle haptics on/off
  Future<void> toggleHaptics(bool enabled) async {
    _hapticsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticsKey, enabled);
  }

  /// Play tap/button press sound
  Future<void> playTap() async {
    await _triggerHaptic(HapticFeedbackType.light);
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
    await _triggerHaptic(HapticFeedbackType.medium);
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
    await _triggerHaptic(HapticFeedbackType.heavy);
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
    await _triggerHaptic(HapticFeedbackType.success);
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
    await _triggerHaptic(HapticFeedbackType.error);
    if (!_soundsEnabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(_failSound), volume: 0.5);
    } catch (e) {
      // Sound file not found, fail silently
    }
  }

  Future<void> _triggerHaptic(HapticFeedbackType type) async {
    if (!_hapticsEnabled) return;
    try {
      switch (type) {
        case HapticFeedbackType.light:
          HapticFeedback.lightImpact();
        case HapticFeedbackType.medium:
          HapticFeedback.mediumImpact();
        case HapticFeedbackType.heavy:
          HapticFeedback.heavyImpact();
        case HapticFeedbackType.success:
          HapticFeedback.mediumImpact();
          await Future.delayed(const Duration(milliseconds: 100));
          HapticFeedback.lightImpact();
        case HapticFeedbackType.error:
          HapticFeedback.heavyImpact();
          await Future.delayed(const Duration(milliseconds: 100));
          HapticFeedback.heavyImpact();
      }
    } catch (e) {
      // Haptics not available, fail silently
    }
  }

  /// Dispose audio player
  void dispose() {
    _player.dispose();
  }
}

enum HapticFeedbackType {
  light,
  medium,
  heavy,
  success,
  error,
}
