import 'package:flutter/material.dart';

final List<Color> topStreakColors = [
  Colors.green.shade400,
  Colors.green.shade300,
  Colors.green.shade200,
];

class MyColors {
  static const kActiveTextColor = Color(0xFF40BB4D);
  static const kDeactivateTextColor = Color(0xFFC4C4C4);

  static const kLevel0Color = Colors.grey; // Eliminate It - Not Important & Not Urgent
  static const kLevel1Color = Colors.blue; // Delegate It - Urgent & Not Important
  static const kLevel2Color = Colors.green; // Schedule It - Important & Not Urgent
  static const kLevel3Color = Colors.red; // Do It Now - Urgent & Important
}
