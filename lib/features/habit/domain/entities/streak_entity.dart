import 'package:equatable/equatable.dart';

class StreakEntity extends Equatable {
  const StreakEntity({
    required this.start,
    required this.end,
    required this.length,
  });
  final DateTime start;
  final DateTime end;
  final int length;

  @override
  List<Object?> get props => [start, end, length];
}
