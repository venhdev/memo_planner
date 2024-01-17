import 'package:flutter/material.dart';

import 'app_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider(
    this._colorSchemeSeed,
    this._themeMode,
  );

  Color _colorSchemeSeed;
  ThemeMode _themeMode;

  ThemeData get light => AppTheme.fromColorSchemeSeed(_colorSchemeSeed).light;
  ThemeData get dark => AppTheme.fromColorSchemeSeed(_colorSchemeSeed).dark;

  // ThemeData _lightTheme = defaultLightTheme;
  // ThemeData _darkTheme = defaultDarkTheme;

  Color get colorSchemeSeed => _colorSchemeSeed;
  ThemeMode get themeMode => _themeMode;
  // ThemeData get light => _lightTheme;
  // ThemeData get dark => _darkTheme;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  void setColorSchemeSeed(Color color) {
    _colorSchemeSeed = color;
    // _lightTheme = defaultLightTheme.copyWith();
    // _darkTheme = defaultDarkTheme.copyWith();
    notifyListeners();
  }
}
