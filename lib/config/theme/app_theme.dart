import 'package:flutter/material.dart';


class AppTheme {
  AppTheme._(this.colorSchemeSeed);

  factory AppTheme.fromColorSchemeSeed(Color colorSchemeSeed) {
    return AppTheme._(colorSchemeSeed);
  }

  ThemeData get light => ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: colorSchemeSeed,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.black),
        ),
      );

  ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: colorSchemeSeed,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.white),
        ),
      );

  final Color colorSchemeSeed;
}
