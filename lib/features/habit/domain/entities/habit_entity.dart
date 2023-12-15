import 'package:equatable/equatable.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/converter.dart';
import '../../../../core/notification/reminder.dart';
import '../../../authentication/domain/entities/user_entity.dart';

// The entity design to sync with Google Calendar
class HabitEntity extends Equatable {
  const HabitEntity({
    required this.hid,
    required this.summary,
    required this.description,
    required this.start,
    required this.end,
    required this.reminders, // v1.1
    required this.recurrence,
    required this.created,
    this.updated,
    this.creator,
    this.members, //v1.1

  });

  final String? hid;
  final String? summary; // the title
  final String? description;

  final DateTime? start; // start time
  // end time of the event. For a recurring habit, this is the end time of the first instance.
  final DateTime? end;
  final String? recurrence; // recurrence rule
  final Reminder? reminders; // reminder

  final DateTime? created; //Creation time of the habit
  final DateTime? updated; //Last modification time of the habit

  final UserEntity? creator; //The creator of the habit. Read-only.
  final List<String>? members; //The members of the habit. //v1.1 --only contain email

  final String kind = kHabit; // The type of the resource. This is always 'habit#summary'.

  // ie. recurrence: 'RRULE:FREQ=DAILY;INTERVAL=1;UNTIL=20231130'
  DateTime? get until {
    if (recurrence != null) {
      final rrule = recurrence!.split(';');
      final until = rrule.where((element) => element.contains('UNTIL='));
      if (until.isNotEmpty) {
        return convertStringToDateTime(until.first.split('=')[1]);
      }
    }
    return null;
  }

  // copyWith
  HabitEntity copyWith({
    String? hid,
    String? summary,
    String? description,
    DateTime? start,
    DateTime? end,
    Reminder? reminders,
    String? recurrence,
    DateTime? created,
    DateTime? updated,
    UserEntity? creator,
    List<String>? members,
  }) {
    return HabitEntity(
      hid: hid ?? this.hid,
      summary: summary ?? this.summary,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      reminders: reminders ?? this.reminders,
      recurrence: recurrence ?? this.recurrence,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      creator: creator ?? this.creator,
      members: members ?? this.members,
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
        members,
      ];
}

// https://developers.google.com/calendar/api/v3/reference/events#resource
