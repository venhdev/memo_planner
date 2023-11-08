import 'package:cloud_firestore/cloud_firestore.dart';

// use to Convert Timestamp From FireStore to DateTime
DateTime convertTimestampToDateTime(Timestamp timestamp) {
  return DateTime.fromMicrosecondsSinceEpoch(timestamp.seconds);
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
