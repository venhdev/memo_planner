import 'package:flutter/material.dart';

final List<Color> topStreakColors = [
  Colors.green.shade400,
  Colors.green.shade300,
  Colors.green.shade200,
];

class AppColors {
  static const kDefaultTextColor = Colors.black;

  static const kRemainingTextColor = Colors.green;
  static const kOverdueTextColor = Colors.red;

  static const kActiveTextColor = Colors.green;
  static const kDeactivateTextColor = Color(0xFFC4C4C4);

  // static const kLevel3Color = Colors.red; // Do It Now - Important & Urgent
  // static const kLevel2Color = Colors.green; // Schedule It - Important & Not Urgent
  // static const kLevel1Color = Colors.amber; // Delegate It - Urgent & Not Important
  // static const kLevel0Color = Colors.grey; // Eliminate It - Not Important & Not Urgent

  static Color getColorByPriority(int priority, bool isDarkMode) {
    switch (priority) {
      case 0:
        return isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
      case 1:
        return isDarkMode ? Colors.amber.shade700 : Colors.amber.shade300;
      case 2:
        return isDarkMode ? Colors.green.shade700 : Colors.green.shade300;
      case 3:
        return isDarkMode ? Colors.red.shade700 : Colors.red.shade300;
      default:
        return isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
    }
  }

  static Color getBrightnessColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white;
  }

  static Color? dueDateColor(DateTime? sourceDateTime, {DateTime? targetDateTime, Color? colorWhenDateTimeNull = kDefaultTextColor}) {
    if (sourceDateTime != null) {
      Duration duration = sourceDateTime.difference(targetDateTime ?? DateTime.now());
      if (duration >= Duration.zero) {
        return kRemainingTextColor; // green
      } else {
        return kOverdueTextColor;
      }
    } else {
      return colorWhenDateTimeNull;
    }
  }

  // static Color? priorityColor(int priority) {
  //   switch (priority) {
  //     case 0:
  //       return kLevel0Color;
  //     case 1:
  //       return kLevel1Color;
  //     case 2:
  //       return kLevel2Color;
  //     case 3:
  //       return kLevel3Color;
  //     default:
  //       return kLevel0Color;
  //   }
  // }
}
