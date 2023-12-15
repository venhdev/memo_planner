import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:memo_planner/core/utils/converter.dart';

void main() {
  test('description', () {
    final now = DateTime.now();
    // const String tDateString = '20231116';
    // const String tDateString2 = '31-12-2021';

    // debugPrint(convertDateTimeToString(now, formatPattern: '[formatDatePattern]').toString());
    // debugPrint(convertStringToDateTime(tDateString).toString());

    // debugPrint(
    //     convertDateTimeToString(now, formatPattern: 'ddMMyyyy').toString());
    // debugPrint(
    //     convertStringToDateTime(tDateString2, format: DateFormat('ddMMyyyy'))
    //         .toString());


    final String nowString = convertDateTimeToString(now, pattern: 'formatDatePattern');
    debugPrint('nowString: $nowString');


    final DateTime nowDateTime = convertStringToDateTime(nowString, pattern: DateFormat('formatDatePattern'));
    debugPrint('nowDateTime: $nowDateTime');

    // DateTime self = DateTime.parse(nowString);
    // debugPrint('self: $self');

    // final String myFunc = convertDateTimeToString(now);
    // debugPrint('myFunc: $myFunc');
  });
}
