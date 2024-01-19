import 'package:flutter/material.dart';
import '../../core/service/shared_preferences_service.dart';

import 'app_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider(
    this._pref, [
    ThemeMode? themeMode,
    Color? colorSchemeSeed,
  ])  : _themeMode = themeMode ?? _pref.themeMode,
        _colorSchemeSeed = colorSchemeSeed ?? _pref.colorScheme;

  Color _colorSchemeSeed;
  ThemeMode _themeMode;
  final SharedPreferencesService _pref;

  ThemeData get light => AppTheme.withColorScheme(_colorSchemeSeed).light;
  ThemeData get dark => AppTheme.withColorScheme(_colorSchemeSeed).dark;

  Color get colorSchemeSeed => _colorSchemeSeed;
  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    try {
      switch (themeMode) {
        case ThemeMode.light:
          _pref.setDarkMode(false);
          debugPrint('light mode saved successfully');
          break;
        case ThemeMode.dark:
          _pref.setDarkMode(true);
          debugPrint('dark mode saved successfully');
          break;
        default:
          _pref.resetThemeMode();
          debugPrint('system mode saved successfully');
          break;
      }
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
    notifyListeners();
  }

  void setColorSchemeSeed(Color color) {
    _colorSchemeSeed = color;
    try {
      _pref.setColorScheme(color.value);
      debugPrint('Color scheme saved successfully with value: ${color.value}');
    } catch (e) {
      debugPrint('Error saving color scheme: $e');
    }
    notifyListeners();
  }
}
