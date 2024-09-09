import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class ThemeProvider extends ChangeNotifier {
//   ThemeMode _themeMode = ThemeMode.light;
//
//   ThemeMode get curThemeMode => _themeMode;
//
//   ThemeProvider() {
//     _loadThemeMode(); //Dùng để load theme mode khi khởi động.
//   }
//
//   void toggleTheme(bool isDarkMode) async {
//     _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setBool('isDarkMode', isDarkMode);
//   }
//
//   void _loadThemeMode() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isDarkMode = prefs.getBool('isDarkMode') ?? false;
//     _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();
//   }
// }
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get curThemeMode => _themeMode;

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', mode.toString());
  }

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeString = prefs.getString('themeMode') ?? ThemeMode.system.toString();
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
