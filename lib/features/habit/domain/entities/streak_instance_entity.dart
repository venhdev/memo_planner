import 'package:equatable/equatable.dart';

class StreakInstanceEntity extends Equatable {
  const StreakInstanceEntity({
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
