// import 'dart:developer' as dev;
import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants.dart';

part 'converter.dart';

Future<void> tryLaunchUrl(String url) async {
  if (!url.startsWith('http') && !url.startsWith('https')) {
    url = 'https://$url';
  }
  final Uri uri = Uri.parse(url);

  try {
    if (!await launchUrl(uri)) {
      // throw Exception('Could not launch $uri');
      dev.log('Could not launch $uri');
      Fluttertoast.showToast(msg: 'Could not launch $uri');
    } else {
      dev.log('launch $uri');
    }
  } catch (e) {
    dev.log('Could not launch $uri || error: $e');
    Fluttertoast.showToast(msg: 'Could not launch $uri');
  }
}

bool isDark(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

DateTime getToday() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
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

// get remaining time from now to [dateTime]
/// {defaultText} will return if [dateTime] is null
String getRemainingTime(
  DateTime? dateTime, {
  String defaultText = '',
  String prefixRemaining = 'Remaining: ',
  String prefixOverdue = 'Overdue: ',
  bool showOverdue = false,
  String defaultOverdueText = 'Set new time',
}) {
  if (dateTime != null) {
    Duration duration = dateTime.difference(DateTime.now());
    if (duration > Duration.zero) {
      if (duration.inSeconds < 60) {
        return '$prefixRemaining${duration.inSeconds}s';
      } else if (duration.inMinutes < 60) {
        return '$prefixRemaining${duration.inMinutes}m';
      } else if (duration.inHours < 24) {
        return '$prefixRemaining${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
      } else if (duration.inDays < 30) {
        return '$prefixRemaining${duration.inDays}d ${duration.inHours.remainder(24)}h';
      } else if (duration.inDays < 365) {
        return '$prefixRemaining${duration.inDays ~/ 30}month ${duration.inDays.remainder(30)}d';
      } else {
        return '$prefixRemaining${duration.inDays ~/ 365}y'; // so far =))
      }
    } else {
      if (!showOverdue) {
        return defaultOverdueText;
      }
      duration = DateTime.now().difference(dateTime); // get negative duration
      if (duration.inSeconds < 60) {
        return '$prefixOverdue${duration.inSeconds}s';
      } else if (duration.inMinutes < 60) {
        return '$prefixOverdue${duration.inMinutes}m';
      } else if (duration.inHours < 24) {
        return '$prefixOverdue${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
      } else if (duration.inDays < 30) {
        return '$prefixOverdue${duration.inDays}d ${duration.inHours.remainder(24)}h';
      } else if (duration.inDays < 365) {
        return '$prefixOverdue${duration.inDays ~/ 30}month ${duration.inDays.remainder(30)}d';
      } else {
        return '$prefixOverdue${duration.inDays ~/ 365}y'; // so far =))
      }
    }
  } else {
    return defaultText;
  }
}

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

int generateNotificationId(DateTime date) {
  final id = convertDateTimeToInt(date); // convert time to int. 12:34 -> 1234
  final random = Random().nextInt(998) + 1; // from 1 to 999
  final result = random * 10000 + id; // 1 * 10000 + 1234 = 11234
  // get the first 4 digits
  // final first4Digits = result ~/ 10000;
  // l.log('object get first4Digits: ${first4Digits}');
  return result;
}

// get the last 4 digits
// int getTimeByNotificationId(int id) {
//   final last4Digits = id % 10000;
//   dev.log('object getNotificationId: $last4Digits');
//   return last4Digits;
// }
