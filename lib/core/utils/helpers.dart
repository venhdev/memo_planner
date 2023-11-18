import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memo_planner/core/constants/constants.dart';

String getIid(String hid, DateTime date) {
  return '${hid}_${convertDateTimeToyyyyMMdd(date)}';
}

/// use to Convert Timestamp From FireStore to DateTime
DateTime convertTimestampToDateTime(Timestamp timestamp) {
  return DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
}

/// use to Convert DateTime to format [kDateFormatPattern]
String convertDateTimeToyyyyMMdd(DateTime dateTime) {
  return dateTime.toIso8601String().substring(0, 10).replaceAll('-', '');
}

/// When specify [pattern], it must have separator like "dd-MM-yyyy"
DateTime convertStringToDateTime(
  String date, {
  DateFormat? pattern,
}) {
  if (pattern != null) {
    if (RegExp(r'\W').hasMatch(pattern.pattern!)) {
      return pattern.parse(date);
    } else if (pattern.pattern! == kDateFormatPattern) {
      DateTime.parse(date);
    } else {
      throw const FormatException(
        'pattern must have separator like "dd-MM-yyyy"',
      );
    }
  }
  return DateTime.parse(date);
}

/// Default convert DateTime to String 'dd-MM-yyyy'
///
/// Change [pattern] to change the format
String convertDateTimeToString(
  DateTime date, {
  String pattern = 'dd-MM-yyyy',
}) {
  return DateFormat(pattern).format(date);
}

/// use to Convert DateTime to format yyyy-MM-dd
// String convertDateTimeToddMMyyyy(DateTime dateTime) {
//   return dateTime.toIso8601String().substring(0, 10);
// }

/// use to get Date from DateTime
///
/// => yyyy-MM-dd : 00:00:00.000
DateTime getDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

// ----------------------------------------------------------------
// String convertDateTimeToyyyyMMdd(DateTime dateTime) {
//   return dateTime.year.toString() +
//       dateTime.month.toString().padLeft(2, '0') +
//       dateTime.day.toString().padLeft(2, '0');
// } //bad performance

/// Use to compare {day, month, year} of two DateTime
/// This function will return:
/// - 1: dateTime1 > dateTime2
/// - 0: dateTime1 == dateTime2
/// - -1: dateTime1 < dateTime2
int compareDateTimeByDay(DateTime dateTime1, DateTime dateTime2) {
  DateTime date1 = getDate(dateTime1);
  DateTime date2 = getDate(dateTime2);

  if (date1.isAfter(date2)) {
    return 1;
  } else if (date1.isBefore(date2)) {
    return -1;
  } else {
    return 0;
  }
}
/// Use to compare time {hour, minute} of two DateTime
/// This function will return:
/// - 1: dateTime1 > dateTime2
/// - 0: dateTime1 == dateTime2
/// - -1: dateTime1 < dateTime2
int compareDateTimeByTime(DateTime date1, DateTime date2) {
  TimeOfDay time1 = TimeOfDay.fromDateTime(date1);
  TimeOfDay time2 = TimeOfDay.fromDateTime(date2);
  return compareTimeOfDay(time1, time2);
}

/// This function will return:
/// - 1: time1 > time2
/// - 0: time1 == time2
/// - -1: time1 < time2
int compareTimeOfDay(TimeOfDay time1, TimeOfDay time2) {
  if (time1.hour > time2.hour) {
    return 1;
  } else if (time1.hour < time2.hour) {
    return -1;
  } else {
    if (time1.minute > time2.minute) {
      return 1;
    } else if (time1.minute < time2.minute) {
      return -1;
    } else {
      return 0;
    }
  }
}

