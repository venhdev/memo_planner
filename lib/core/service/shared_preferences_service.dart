import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import '../constants/typedef.dart';
import '../error/failures.dart';

const String _keyTheme = 'theme';
const String _keyColorScheme = 'schemeColor';

abstract class SharedPreferencesService {
  // Theme
  ThemeMode get themeMode;
  ResultVoid setDarkMode(bool value);
  ResultVoid resetThemeMode();
  // Color Scheme
  Color get colorScheme;
  ResultVoid setColorScheme(int value);
  ResultVoid resetColorScheme();
}

@Singleton(as: SharedPreferencesService)
class SharedPreferencesServiceImpl implements SharedPreferencesService {
  SharedPreferencesServiceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Color get colorScheme {
    //> NO key => using default color scheme
    if (!_prefs.containsKey(_keyColorScheme)) return defaultColorSchemeSeed;

    //> key exists => using saved color scheme
    return Color(_prefs.getInt(_keyColorScheme)!);
  }

  @override
  ThemeMode get themeMode {
    //> NO key => using system mode
    if (!_prefs.containsKey(_keyTheme)) return ThemeMode.system;

    //> key exists => using saved mode
    final bool isDarkMode = _prefs.getBool(_keyTheme)!;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  ResultVoid setColorScheme(int value) async {
    if (await _prefs.setInt(_keyColorScheme, value)) {
      return const Right(null);
    } else {
      return const Left(Failure(message: 'Failed to save color scheme!'));
    }
  }

  @override
  ResultVoid setDarkMode(bool value) async {
    if (await _prefs.setBool(_keyTheme, value)) {
      return const Right(null);
    } else {
      return const Left(Failure(message: 'Failed to save theme!'));
    }
  }
  
  @override
  ResultVoid resetColorScheme() async {
    if (await _prefs.remove(_keyColorScheme)) {
      return const Right(null);
    } else {
      return const Left(Failure(message: 'Failed to reset color scheme!'));
    }
  }
  
  @override
  ResultVoid resetThemeMode() async{
    if (await _prefs.remove(_keyTheme)) {
      return const Right(null);
    } else {
      return const Left(Failure(message: 'Failed to reset theme!'));
    }
  }
}
