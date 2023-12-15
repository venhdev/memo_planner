import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/converter.dart';
import '../../../authentication/data/models/user_model.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/entities/habit_instance_entity.dart';

class HabitInstanceModel extends HabitInstanceEntity {
  const HabitInstanceModel({
    String? iid,
    String? hid,
    String? summary,
    String? description,
    DateTime? start,
    DateTime? end,
    DateTime? date,
    DateTime? updated,
    UserEntity? creator,
    bool? completed,
    bool? edited,
  }) : super(
          iid: iid,
          hid: hid,
          summary: summary,
          description: description,
          start: start,
          end: end,
          date: date,
          updated: updated,
          creator: creator,
          completed: completed,
          edited: edited,
        );

  //fromEntity
  factory HabitInstanceModel.fromEntity(HabitInstanceEntity entity) {
    return HabitInstanceModel(
      iid: entity.iid,
      hid: entity.hid,
      summary: entity.summary,
      description: entity.description,
      start: entity.start,
      end: entity.end,
      date: entity.date,
      updated: entity.updated,
      creator: entity.creator,
      completed: entity.completed,
      edited: entity.edited,
    );
  }

  // fromDocument
  factory HabitInstanceModel.fromDocument(Map<String, dynamic> data) {
    return HabitInstanceModel.fromMap(data);
  }

  // fromMap
  factory HabitInstanceModel.fromMap(Map<String, dynamic> data) {
    return HabitInstanceModel(
      iid: data['iid'],
      hid: data['hid'],
      summary: data['summary'],
      description: data['description'],
      start: convertTimestampToDateTime(data['start'] as Timestamp),
      end: convertTimestampToDateTime(data['end'] as Timestamp),
      date: convertTimestampToDateTime(data['date'] as Timestamp),
      updated: convertTimestampToDateTime(data['updated'] as Timestamp),
      creator: UserModel.fromMap(data['creator']),
      completed: data['completed'],
      edited: data['edited'],
    );
  }

  // to Document
  Map<String, dynamic> toDocument() {
    return toMap();
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      if (iid != null) 'iid': iid,
      if (hid != null) 'hid': hid,
      if (summary != null) 'summary': summary,
      if (description != null) 'description': description,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (date != null) 'date': date,
      if (updated != null) 'updated': updated,
      if (creator != null) 'creator': UserModel.fromEntity(creator!).toMap(),
      if (completed != null) 'completed': completed,
      if (edited != null) 'edited': edited,
    };
  }
}
