import 'package:equatable/equatable.dart';

import '../../../authentication/domain/entities/user_entity.dart';

// The entity design to sync with Google Calendar
class HabitEntity extends Equatable {
  const HabitEntity({
    required this.hid,
    required this.summary,
    required this.description,
    required this.start,
    required this.end,
    required this.recurrence,
    required this.created,
    required this.updated,
    required this.creator,
  });

  final String? hid;
  final String? summary; // the title
  final String? description;

  final DateTime? start; // start time
  final DateTime? end; // end time
  final String? recurrence; // recurrence rule

  final DateTime? created; //Creation time of the habit
  final DateTime? updated; //Last modification time of the habit

  final UserEntity? creator; //The creator of the habit. Read-only.


  final String kind = 'habit#summary';
  // copyWith
  HabitEntity copyWith({
    String? hid,
    String? summary,
    String? description,
    DateTime? start,
    DateTime? end,
    String? recurrence,
    DateTime? created,
    DateTime? updated,
    UserEntity? creator,
  }) {
    return HabitEntity(
      hid: hid ?? this.hid,
      summary: summary ?? this.summary,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      recurrence: recurrence ?? this.recurrence,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      creator: creator ?? this.creator,
    );
  }

  @override
  List<Object?> get props => [
        hid,
        summary,
        description,
        start,
        end,
        recurrence,
        created,
        updated,
        creator,
      ];
}

// https://developers.google.com/calendar/api/v3/reference/events#resource
