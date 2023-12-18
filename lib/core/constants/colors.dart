import 'package:flutter/material.dart';

final List<Color> topStreakColors = [
  Colors.green.shade400,
  Colors.green.shade300,
  Colors.green.shade200,
];

class MyColors {
  static const kActiveTextColor = Color(0xFF40BB4D);
  static const kDeactivateTextColor = Color(0xFFC4C4C4);

  static const kLevel3Color = Colors.red; // Do It Now - Important & Urgent
  static const kLevel2Color = Colors.green; // Schedule It - Important & Not Urgent
  static const kLevel1Color = Colors.amber; // Delegate It - Urgent & Not Important
  static const kLevel0Color = Colors.grey; // Eliminate It - Not Important & Not Urgent

  static priorityColor(int priority) {
    switch (priority) {
      case 0:
        return kLevel0Color;
      case 1:
        return kLevel1Color;
      case 2:
        return kLevel2Color;
      case 3:
        return kLevel3Color;
      default:
        return kLevel0Color;
    }
  }

  static priorityLabel(int priority) {
    switch (priority) {
      case 0:
        return 'Eliminate';
      case 1:
        return 'Delegate';
      case 2:
        return 'Schedule';
      case 3:
        return 'Do It';
      default:
        return 'Unknown';
    }
  }
}
