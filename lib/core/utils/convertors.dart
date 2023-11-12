import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// use to Convert Timestamp From FireStore to DateTime
DateTime convertTimestampToDateTime(Timestamp timestamp) {
  return DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
}

// use to Convert DateTime to format yyyyMMdd
String convertDateTimeToyyyyMMdd(DateTime dateTime) {
  return dateTime.toIso8601String().substring(0, 10).replaceAll('-', '');
}

// String convertDateTimeToyyyyMMdd(DateTime dateTime) {
//   return dateTime.year.toString() +
//       dateTime.month.toString().padLeft(2, '0') +
//       dateTime.day.toString().padLeft(2, '0');
// } //bad performance
String getIid(String hid, DateTime date) {
  return '${hid}_${convertDateTimeToyyyyMMdd(date)}';
}

DateTime yyyyMMddDateTime (String date) {
  return DateFormat('yyyyMMdd').parse(date);
}

String ddMMString (DateTime date) {
  return DateFormat('dd/MM').format(date);
}

DateFormat getDateFormat (String format) {
  return DateFormat(format);
}