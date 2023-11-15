import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String getIid(String hid, DateTime date) {
  return '${hid}_${convertDateTimeToyyyyMMdd(date)}';
}

/// use to Convert Timestamp From FireStore to DateTime
DateTime convertTimestampToDateTime(Timestamp timestamp) {
  return DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
}

/// use to Convert DateTime to format yyyyMMdd
String convertDateTimeToyyyyMMdd(DateTime dateTime) {
  return dateTime.toIso8601String().substring(0, 10).replaceAll('-', '');
}
DateTime convertyyyyMMddToDateTime(String date) {
  return DateTime.parse(date);
}

/// use to Convert DateTime to format yyyy-MM-dd
// String convertDateTimeToddMMyyyy(DateTime dateTime) {
//   return dateTime.toIso8601String().substring(0, 10);
// }

String ddMMyyyyString(DateTime date) {
  return DateFormat('dd-MM-yyyy').format(date);
}

String convertDateTimeToString(
  DateTime date, {
  String formatPattern = 'dd-MM-yyyy',
}) {
  return DateFormat(formatPattern).format(date);
}

DateFormat getDateFormat(String format) {
  return DateFormat(format);
}

DateTime getDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

// ----------------------------------------------------------------
// String convertDateTimeToyyyyMMdd(DateTime dateTime) {
//   return dateTime.year.toString() +
//       dateTime.month.toString().padLeft(2, '0') +
//       dateTime.day.toString().padLeft(2, '0');
// } //bad performance