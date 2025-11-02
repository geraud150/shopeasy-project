import 'package:flutter/material.dart';

// The primary color inspired by the ShopEasy logo.
const Color shopeasyBlue = Color(0xFF3F51B5); // This is an example, we can adjust it.

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.indigo,
  brightness: Brightness.light,
  primaryColor: shopeasyBlue,
  appBarTheme: const AppBarTheme(
    backgroundColor: shopeasyBlue,
    foregroundColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: shopeasyBlue,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: shopeasyBlue,
      foregroundColor: Colors.white,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.indigo,
  brightness: Brightness.dark,
  primaryColor: shopeasyBlue,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black, // A darker AppBar for dark mode
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: shopeasyBlue,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: shopeasyBlue,
      foregroundColor: Colors.white,
    ),
  ),
);
