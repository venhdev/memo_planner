part of 'helpers.dart';

String getIid(String hid, DateTime date) {
  return '${hid}_${convertDateTimeToyyyyMMdd(date)}';
}

/// use to Convert Timestamp From FireStore to DateTime
// DateTime? convertTimestampToDateTime(Timestamp? timestamp) {
//   return timestamp != null ? DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch) : null;

//   // return DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
// }

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
  DateTime? date, {
  String pattern = 'dd-MM-yyyy',
  String defaultValue = '',
  bool useTextValue = true,
}) {
  if (date == null) {
    return defaultValue;
  }

  DateTime today = getToday();
  DateTime tomorrow = today.add(const Duration(days: 1));
  DateTime yesterday = today.subtract(const Duration(days: 1));

  if (useTextValue) {
    if (date == today) {
      return 'Today';
    } else if (date == tomorrow) {
      return 'Tomorrow';
    } else if (date == yesterday) {
      return 'Yesterday';
    }
  }

  return DateFormat(pattern).format(date);
}

/// Convert DateTime to int --hour (HHmm) 24h format. Ex: 12:30 -> 1230
int convertDateTimeToInt(DateTime date, {String pattern = 'Hm'}) {
  return int.parse(DateFormat(pattern).format(date).replaceAll(':', ''));
}

/// Convert int to DateTime
/// Ex: 1230 -> 12:30
DateTime convertIntToDateTime(int time) {
  return DateFormat('Hm').parse(time.toString().padLeft(4, '0'));
}
