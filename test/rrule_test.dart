import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memo_planner/features/habit/domain/entities/rrule.dart';

void main() {
  // test('description', () {
  // final tRule = RRule(
  //   freq: FREQ.daily,
  //   interval: 1,
  //   // until: convertDateTimeToyyyyMMdd(DateTime.now()),
  //   until: convertDateTimeToString(DateTime.now(), pattern: 'formatDatePattern'),
  // );

  // debugPrint(tRule.toString());
  // // debugPrint(convertStringToDateTime(tRule.until!).toString());
  // // debugPrint(convertStringToDateTime(tRule.until!).runtimeType.toString());

  // //test get until
  // debugPrint(tRule.until!);

  // Every two weeks on Tuesday and Thursday, but only in December.
  // });
  test('description', () {
    String rruleString = 'RRULE:FREQ=WEEKLY;BYDAY=;BYDAY=MO,TU,WE,TH,FR,SA';

    final rule = RRule.fromString(rruleString);

    debugPrint('rule.freq: ${rule.freq}');
    debugPrint('rule.interval: ${rule.interval}');
    debugPrint('rule.until: ${rule.until}');
    debugPrint('rule.byDay: ${rule.byDay}');

    debugPrint(rule.toString());
    // DateTime someDate = DateTime.now();
    // DateTime mon = DateTime(2023, 11, 13);

    // debugPrint(someDate.weekday.toString());

    // debugPrint(mon.weekday.toString());
  });
}
