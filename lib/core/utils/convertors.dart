import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// use to Convert Timestamp From FireStore to DateTime
DateTime convertTimestampToDateTime(Timestamp timestamp) {
  return DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
}

// use to Convert DateTime to format yyyyMMdd
String convertDateTimeToyyyyMMdd(DateTime dateTime) {
  return dateTime.toIso8601String().substring(0, 10).replaceAll('-', '');
} // use to Convert DateTime to format yyyyMMdd

String convertDateTimeToddMMyyyy(DateTime dateTime) {
  return dateTime.toIso8601String().substring(0, 10);
}

// String convertDateTimeToyyyyMMdd(DateTime dateTime) {
//   return dateTime.year.toString() +
//       dateTime.month.toString().padLeft(2, '0') +
//       dateTime.day.toString().padLeft(2, '0');
// } //bad performance
String getIid(String hid, DateTime date) {
  return '${hid}_${convertDateTimeToyyyyMMdd(date)}';
}

// DateTime yyyyMMddDateTime (String date) {
//   return DateTime.parse(date);
// }

String ddMMString(DateTime date) {
  return DateFormat('dd/MM').format(date);
}

String ddMMyyyyString(DateTime date) {
  return DateFormat('dd-MM-yyyy hh:mm').format(date);
}

DateFormat getDateFormat(String format) {
  return DateFormat(format);
}

DateTime getDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
