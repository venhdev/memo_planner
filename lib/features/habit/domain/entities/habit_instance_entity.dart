import 'package:equatable/equatable.dart';
import 'package:memo_planner/features/authentication/domain/entities/user_entity.dart';

/// This object will be automatically created when a user tick in checkbox of a habit
class HabitInstanceEntity extends Equatable {
  const HabitInstanceEntity({
    this.iid,
    this.hid,
    this.summary,
    this.date,
    this.updated,
    this.creator,
    this.completed,
  });

  final String? hid; // Recurring Habit ID
  final String? iid; // Habit Instance ID = hid_date (yyyyMMdd)

  final String? summary;

  final DateTime? date; // Date of this habit instance (= iid)
  final DateTime? updated; // Date of last update

  final UserEntity? creator; // User who created this habit instance

  final bool? completed; // Whether the habit is completed or not

  final String kind = 'habit#instance';

  @override
  List<Object?> get props => [
        hid,
        iid,
        summary,
        date,
        updated,
        creator,
        completed,
        kind,
      ];
}
