import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('description', () {
    DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    debugPrint(now.millisecondsSinceEpoch.toString());
    debugPrint(now.toString());
    debugPrint(today.toString());
  });
}