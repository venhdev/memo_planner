import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class Streak extends Equatable {
  const Streak(this.start, this.end, this.length);
  final DateTime start;
  final DateTime end;
  final int length;

  @override
  List<Object?> get props => [start, end, length];
}

void main() {
  test('description', () {
    final start = DateTime(2021, 6, 1);
    final start2 = DateTime.now();
    final end = DateTime(2021, 6, 2);
    final end2 = start2.add(const Duration(hours: 25));

    // get the length of 2 day

    final length = end.difference(start).inDays + 1;
    debugPrint('length: ${end.difference(start)}');
    debugPrint('length: ${length.toString()}');

    debugPrint('length2: ${end2.difference(start2)}');
    debugPrint('length2: ${end2.difference(start2).inDays}');
  });
}
