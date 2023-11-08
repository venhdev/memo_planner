import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightMode = ThemeData(
    buttonTheme: const ButtonThemeData(
      highlightColor: Colors.deepPurple,
    ),
    primarySwatch: Colors.deepPurple,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
  );

  static final ThemeData darkMode = ThemeData(
    buttonTheme: const ButtonThemeData(
      highlightColor: Colors.deepPurple,
    ),
    primarySwatch: Colors.deepPurple,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
  );

  static final ThemeData defaultTheme = ThemeData(
    buttonTheme: const ButtonThemeData(
      highlightColor: Colors.deepPurple,
    ),
    primarySwatch: Colors.deepPurple,
    textTheme: GoogleFonts.robotoTextTheme(
      ThemeData.light().textTheme,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
  );
}
