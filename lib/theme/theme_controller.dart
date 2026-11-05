import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the user's Phone / Light / Dark choice and saves it on the device, so
/// it is still there the next time the app opens.
///
///   ThemeMode.system -> "Phone": follow the phone's light/dark setting
///   ThemeMode.light  -> "Light"
///   ThemeMode.dark   -> "Dark"
///
/// Call [init] once in main() BEFORE runApp so the saved choice is loaded
/// before the first frame (no flash of the wrong theme).
class ThemeController extends ChangeNotifier {
  ThemeController._(this._prefs, this._mode);

  static const String storageKey = 'theme_mode';

  static ThemeController? _instance;

  static ThemeController get instance => _instance!;

  static ThemeController? get maybeInstance => _instance;

  /// Loads the saved choice. First launch (or an unreadable value) = Phone.
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _instance = ThemeController._(prefs, _decode(prefs.get(storageKey)));
  }

  final SharedPreferences _prefs;
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  /// Applies the theme immediately (listeners rebuild), then saves it.
  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
    try {
      await _prefs.setString(storageKey, mode.name);
    } catch (_) {
      // Saving failed: the theme still applies for this session.
    }
  }

  static ThemeMode _decode(Object? value) {
    if (value is int && value >= 0 && value < ThemeMode.values.length) {
      return ThemeMode.values[value];
    }

    if (value is! String) return ThemeMode.system;
    for (final m in ThemeMode.values) {
      if (m.name == value) return m;
    }
    return ThemeMode.system;
  }
}
