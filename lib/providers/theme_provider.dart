import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'dark_mode';

  bool _isDarkMode = false;

  ThemeProvider({bool initialDarkMode = false}) {
    _isDarkMode = initialDarkMode;
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedValue = prefs.getBool(_themeKey);
      if (savedValue != null && savedValue != _isDarkMode) {
        _isDarkMode = savedValue;
        notifyListeners();
      }
    } catch (_) {
      // Retain default if reading storage fails
    }
  }

  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;

    _isDarkMode = value;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, value);
    } catch (_) {
      // Memory state is already updated even if storage write fails
    }
  }
}
