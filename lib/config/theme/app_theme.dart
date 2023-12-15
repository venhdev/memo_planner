import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightMode = ThemeData(
    buttonTheme: const ButtonThemeData(
      highlightColor: Colors.black,
    ),
    primarySwatch: Colors.lightGreen,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
  );

  static final ThemeData darkMode = ThemeData(
    buttonTheme: const ButtonThemeData(
      highlightColor: Colors.lightGreen,
    ),
    primarySwatch: Colors.lightGreen,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
  );

  static final ThemeData defaultTheme = ThemeData(
    buttonTheme: const ButtonThemeData(
      highlightColor: Colors.lightGreen,
    ),
    primarySwatch: Colors.blue,
    textTheme: GoogleFonts.robotoTextTheme(
      ThemeData.light().textTheme,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    
    useMaterial3: true,
  );
}
