import 'package:equatable/equatable.dart';

import '../../../authentication/domain/entities/user_entity.dart';

/// This object will be automatically created when a user tick in checkbox of a habit
class HabitInstanceEntity extends Equatable {
  const HabitInstanceEntity({
    this.iid,
    this.hid,
    this.summary,
    this.description,
    this.start,
    this.end,
    this.date,
    this.updated,
    this.creator,
    this.completed,
    this.edited,
  });

  final String? hid; // Recurring Habit ID
  final String? iid; // Habit Instance ID = hid_date (yyyyMMdd)

  final String? summary;
  final String? description;

  final DateTime? start; // Start date of this habit instance = [date]
  final DateTime? end; // End date of this habit instance = [date]

  final DateTime? date; // Date of this habit instance (= iid)
  final DateTime? updated; // Date of last update

  final UserEntity? creator; // User who created this habit instance

  final bool? completed; // Whether the habit is completed or not
  final bool? edited; // Default false, when user edit only the instance => true

  final String kind = 'habit#instance';

  // copyWith
  HabitInstanceEntity copyWith({
    String? hid,
    String? iid,
    String? summary,
    String? description,
    DateTime? start,
    DateTime? end,
    DateTime? date,
    DateTime? updated,
    UserEntity? creator,
    bool? completed,
    bool? edited,
  }) {
    return HabitInstanceEntity(
      hid: hid ?? this.hid,
      iid: iid ?? this.iid,
      summary: summary ?? this.summary,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      date: date ?? this.date,
      updated: updated ?? this.updated,
      creator: creator ?? this.creator,
      completed: completed ?? this.completed,
      edited: edited ?? this.edited,
    );
  }

  @override
  List<Object?> get props => [
        hid,
        iid,
        summary,
        description,
        start,
        end,
        date,
        updated,
        creator,
        completed,
        edited,
        kind,
      ];
}
