import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  final BuildContext context; // Add context property

  ThemeProvider(this.context); // Constructor to initialize context

  ThemeMode _currentTheme = ThemeMode.system;

  ThemeMode get currentTheme => _currentTheme;

  bool get isDarkModeEnabled =>
      _currentTheme == ThemeMode.dark ||
      (_currentTheme == ThemeMode.system && isDarkModeSystem);

  bool get isDarkModeSystem =>
      MediaQuery.platformBrightnessOf(context) == Brightness.dark;

  void toggleDarkMode() {
    _currentTheme = isDarkModeEnabled
        ? ThemeMode.light
        : ThemeMode.dark; // Toggle between light and dark mode
    notifyListeners();
  }
}
