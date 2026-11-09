import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Small wrapper around the device's native text-to-speech engine.
///
/// The device must have a speech engine and a voice installed for the
/// selected language. This service uses the device's default language/voice.
class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void>? _initialization;
  bool _isDisposed = false;

  Future<void> initialize({
    required VoidCallback onStart,
    required VoidCallback onComplete,
    required ValueChanged<String> onError,
  }) {
    if (_isDisposed) {
      return Future<void>.error(StateError('TTS service has been disposed.'));
    }

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

    // Make speak() complete only after the current utterance finishes.
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    if (_isDisposed) {
      throw StateError(
        'Cannot speak because the TTS service has been disposed.',
      );
    }

    final cleanedText = text.trim();
    if (cleanedText.isEmpty) return;

    final initialization = _initialization;
    if (initialization == null) {
      throw StateError('Call initialize() before speak().');
    }

    await initialization;
    if (_isDisposed) return;

    // Do not stop here: the page explicitly stops playback when the student
    // taps Stop, changes lesson steps or leaves the lesson. This method only
    // starts the requested utterance.
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
