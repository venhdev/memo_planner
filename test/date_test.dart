import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memo_planner/core/utils/helpers.dart';

void main() {
  test('description', () {
    // DateTime now = DateTime.now();
    // final DateTime today = DateTime(now.year, now.month, now.day);
    // debugPrint(now.millisecondsSinceEpoch.toString());
    // debugPrint(now.toString());
    // debugPrint(today.toString());

    TimeOfDay time1 = const TimeOfDay(hour: 10, minute: 0);
    TimeOfDay time2 = const TimeOfDay(hour: 11, minute: 0);

    String time1String = time1.hour.toString();
    String time2String = time2.hour.toString();

    debugPrint(time1String);
    debugPrint(time2String);

    debugPrint(compareTimeOfDay(time1, time2).toString());
  });
}
