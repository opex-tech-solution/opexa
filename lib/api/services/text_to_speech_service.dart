import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Small wrapper around the device's native text-to-speech engine.
///
/// The device must have a speech engine and a voice installed for the
/// selected language. The service deliberately keeps the device's default
/// language/voice so it works with the voices available on each device.
class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();
  Future<void>? _initialization;
  bool _isDisposed = false;

  Future<void> initialize({
    required VoidCallback onStart,
    required VoidCallback onComplete,
    required ValueChanged<String> onError,
  }) {
    if (_isDisposed) return Future<void>.error(StateError('TTS service disposed'));
    return _initialization ??= _configure(
      onStart: onStart,
      onComplete: onComplete,
      onError: onError,
    );
  }

  Future<void> _configure({
    required VoidCallback onStart,
    required VoidCallback onComplete,
    required ValueChanged<String> onError,
  }) async {
    _flutterTts.setStartHandler(onStart);
    _flutterTts.setCompletionHandler(onComplete);
    _flutterTts.setCancelHandler(onComplete);
    _flutterTts.setErrorHandler((message) => onError(message));

    // Make speak() complete only when the current utterance has finished.
    await _flutterTts.awaitSpeakCompletion(true);

    // A slightly slower pace is easier to follow during a teaching lesson.
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    if (_isDisposed) return;
    final cleanedText = text.trim();
    if (cleanedText.isEmpty) return;

    if (_initialization == null) {
      throw StateError('Call initialize() before speak().');
    }
    await _initialization;
    await _flutterTts.stop();
    await _flutterTts.speak(cleanedText);
  }

  Future<void> stop() async {
    if (_isDisposed) return;
    await _flutterTts.stop();
  }

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    await _flutterTts.stop();
  }
}
