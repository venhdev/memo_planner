import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memo_planner/core/utils/convertors.dart';
import 'package:memo_planner/features/habit/domain/entities/rrule.dart';

void main() {
  test('description', () {
   final tRule =  RRULE(
      freq: FREQ.DAILY,
      interval: 1,
      until: convertDateTimeToyyyyMMdd(DateTime.now()),
    );

    debugPrint(tRule.toString());
    debugPrint(convertyyyyMMddToDateTime(tRule.until!).toString());
    debugPrint(convertyyyyMMddToDateTime(tRule.until!).runtimeType.toString());
  });
}
