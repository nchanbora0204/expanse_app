import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get curThemeMode => _themeMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', mode.toString());
  }

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeString =
        prefs.getString('themeMode') ?? ThemeMode.system.toString();
    _themeMode = _getThemeModeFromString(modeString);
    notifyListeners();
  }

  ThemeMode _getThemeModeFromString(String modeString) {
    switch (modeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
      default:
        return ThemeMode.system;
    }
  }
}
