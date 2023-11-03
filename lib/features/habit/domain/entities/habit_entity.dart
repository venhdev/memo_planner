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
    required this.created,
    required this.updated,
    required this.creator,
    required this.completions,
  });
  final String? hid;
  final String? summary; // the title
  final String? description;

  final DateTime? start; // start time
  final DateTime? end; // end time

  final DateTime? created; //Creation time of the event
  final DateTime? updated; //Last modification time of the event

  final UserEntity? creator; //The creator of the event. Read-only.

  final List<HabitCompletion>? completions;
  // copyWith
  HabitEntity copyWith({
    String? hid,
    String? summary,
    String? description,
    DateTime? start,
    DateTime? end,
    DateTime? created,
    DateTime? updated,
    UserEntity? creator,
    List<HabitCompletion>? completions,
  }) {
    return HabitEntity(
      hid: hid ?? this.hid,
      summary: summary ?? this.summary,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      creator: creator ?? this.creator,
      completions: completions ?? this.completions,
    );
  }

  @override
  List<Object?> get props => [
        hid,
        summary,
        description,
        start,
        end,
        created,
        updated,
        creator,
        completions,
      ];
}

class HabitCompletion {
  HabitCompletion({
    required this.hid,
    required this.completedAt,
  });
  final String hid;
  final DateTime completedAt;
}

// https://developers.google.com/calendar/api/v3/reference/events#resource
