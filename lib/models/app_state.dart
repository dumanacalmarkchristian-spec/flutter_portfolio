import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _profileName = 'Student';

  ThemeMode get themeMode => _themeMode;
  String get profileName => _profileName;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void updateProfileName(String name) {
    if (name.trim().isEmpty) return;
    _profileName = name.trim();
    notifyListeners();
  }
}
