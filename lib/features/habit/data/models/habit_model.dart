import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/notification/reminder.dart';
import '../../../../core/utils/helpers.dart';
import '../../../authentication/data/models/user_model.dart';
import '../../domain/entities/habit_entity.dart';

class HabitModel extends HabitEntity {
  const HabitModel({
    super.hid,
    super.summary,
    super.description,
    super.start,
    super.end,
    super.reminders,
    super.recurrence,
    super.created,
    super.updated,
    super.creator,
    super.members,
  });

  // fromEntity
  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      hid: entity.hid,
      summary: entity.summary,
      description: entity.description,
      start: entity.start,
      end: entity.end,
      reminders: entity.reminders,
      recurrence: entity.recurrence,
      created: entity.created,
      updated: entity.updated,
      creator: entity.creator,
      members: entity.members,
    );
  }

  // from DocumentSnapshot
  factory HabitModel.fromDocument(Map<String, dynamic> data) {
    return HabitModel.fromMap(data);
  }

  //! fromMap
  factory HabitModel.fromMap(Map<String, dynamic> data) {
    return HabitModel(
      hid: data['hid'],
      summary: data['summary'],
      description: data['description'],
      start: convertTimestampToDateTime(data['start'] as Timestamp),
      end: convertTimestampToDateTime(data['end'] as Timestamp),
      reminders: data['reminders'] != null
          ? Reminder.fromMap(data['reminders'] as Map<String, dynamic>)
          : null,
      recurrence: data['recurrence'],
      created: convertTimestampToDateTime(data['created'] as Timestamp),
      updated: convertTimestampToDateTime(data['updated'] as Timestamp),
      creator: UserModel.fromDocument(data['creator']),
      // members: data['members'] != null
      //     ? (data['members'] as List<dynamic>).map((member) => UserModel.fromDocument(member)).toList()
      //     : null,
      // this this List<String> members
      members : data['members'] != null ? (data['members'] as List<dynamic>).map((member) => member.toString()).toList() : null,
    
    
    );
  }
  

  // to DocumentSnapshot to be saved to Firestore
  Map<String, dynamic> toDocument() {
    return toMap();
  }

  //! toMap
  Map<String, dynamic> toMap() {
    return {
      if (hid != null) 'hid': hid,
      if (summary != null) 'summary': summary,
      if (description != null) 'description': description,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (reminders != null) 'reminders': reminders!.toMap(),
      if (recurrence != null) 'recurrence': recurrence,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (creator != null) 'creator': UserModel.fromEntity(creator!).toDocument(),
      if (members != null) 'members': members,
      'kind': kind
    };
  }
}
