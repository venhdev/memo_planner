import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memo_planner/core/utils/helpers.dart';
import 'package:memo_planner/features/habit/domain/entities/rrule.dart';

void main() {
  test('description', () {
    final tRule = RRule(
      freq: FREQ.DAILY,
      interval: 1,
      // until: convertDateTimeToyyyyMMdd(DateTime.now()),
      until: convertDateTimeToString(DateTime.now(), pattern: 'formatDatePattern'),
    );

    debugPrint(tRule.toString());
    // debugPrint(convertStringToDateTime(tRule.until!).toString());
    // debugPrint(convertStringToDateTime(tRule.until!).runtimeType.toString());

    //test get until
    debugPrint(tRule.until!);
  });
}
