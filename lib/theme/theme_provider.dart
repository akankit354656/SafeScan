import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  Color _accentColor = Colors.teal; // default accent color

  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;

  void setLightTheme() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  void setDarkTheme() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  void setAccentColor(Color color) {
    _accentColor = color;
    notifyListeners();
  }

  // In theme_provider.dart
  bool _vibrate = true;
  bool get vibrate => _vibrate;

  void setVibrate(bool value) {
    _vibrate = value;
    notifyListeners();
  }
}
