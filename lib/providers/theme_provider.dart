import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeProvider with ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.system;
  static const String _themeKey = 'theme_mode';

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get currentTheme => _currentTheme;

  bool get isDarkModeEnabled => _currentTheme == ThemeMode.dark;

    // ✅ Charger le thème sauvegardé
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);
    if (savedTheme == 'dark') {
      _currentTheme = ThemeMode.dark;
    } else if (savedTheme == 'light') {
      _currentTheme = ThemeMode.light;
    } else {
      _currentTheme = ThemeMode.system;
    }
    notifyListeners();
  }

  void toggleDarkMode() async {
    _currentTheme =
        _currentTheme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_themeKey, _currentTheme == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }
}
