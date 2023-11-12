import 'package:equatable/equatable.dart';

import '../../../authentication/domain/entities/user_entity.dart';

/// This object will be automatically created when a user tick in checkbox of a habit
class HabitInstanceEntity extends Equatable {
  const HabitInstanceEntity({
    this.iid,
    this.hid,
    this.summary,
    this.description,
    this.date,
    this.updated,
    this.creator,
    this.completed,
  });

  final String? hid; // Recurring Habit ID
  final String? iid; // Habit Instance ID = hid_date (yyyyMMdd)

  final String? summary;
  final String? description;


  final DateTime? date; // Date of this habit instance (= iid)
  final DateTime? updated; // Date of last update

  final UserEntity? creator; // User who created this habit instance

  final bool? completed; // Whether the habit is completed or not

  final String kind = 'habit#instance';

  // copyWith
  HabitInstanceEntity copyWith({
    String? hid,
    String? iid,
    String? summary,
    String? description,
    DateTime? date,
    DateTime? updated,
    UserEntity? creator,
    bool? completed,
  }) {
    return HabitInstanceEntity(
      hid: hid ?? this.hid,
      iid: iid ?? this.iid,
      summary: summary ?? this.summary,
      description: description ?? this.description,
      date: date ?? this.date,
      updated: updated ?? this.updated,
      creator: creator ?? this.creator,
      completed: completed ?? this.completed,
    );
  }


  @override
  List<Object?> get props => [
        hid,
        iid,
        summary,
        description,
        date,
        updated,
        creator,
        completed,
        kind,
      ];
}
