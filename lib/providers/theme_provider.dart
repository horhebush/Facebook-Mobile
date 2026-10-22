import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

// Holds the dark/light preference and keeps it on the device.
class ThemeProvider with ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  // Reads the saved preference, before the first frame.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? false;
  }

  // ENHANCEMENT 2: switches the theme and saves the choice.
  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', _isDark);
  }

  // Filled buttons are brand orange on both themes.
  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: FB_PRIMARY,
      foregroundColor: Colors.white,
    ),
  );

  ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: FB_PRIMARY,
      brightness: Brightness.light,
      surface: FB_TEXT_COLOR_WHITE,
    ),
    scaffoldBackgroundColor: FB_TEXT_COLOR_WHITE,
    elevatedButtonTheme: _elevatedButtonTheme,
    fontFamily: 'Frutiger',
    useMaterial3: true,
  );

  ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: FB_PRIMARY,
      brightness: Brightness.dark,
    ),
    elevatedButtonTheme: _elevatedButtonTheme,
    fontFamily: 'Frutiger',
    useMaterial3: true,
  );
}
