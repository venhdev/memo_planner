import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memo_planner/features/authentication/data/models/user_model.dart';

import '../../../../core/utils/convertors.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/entities/habit_instance_entity.dart';

class HabitInstanceModel extends HabitInstanceEntity {
  const HabitInstanceModel({
    String? iid,
    String? hid,
    String? summary,
    DateTime? date,
    DateTime? updated,
    UserEntity? creator,
    bool? completed,
  }) : super(
          iid: iid,
          hid: hid,
          summary: summary,
          date: date,
          updated: updated,
          creator: creator,
          completed: completed,
        );

  //fromEntity
  factory HabitInstanceModel.fromEntity(HabitInstanceEntity entity) {
    return HabitInstanceModel(
      iid: entity.iid,
      hid: entity.hid,
      summary: entity.summary,
      date: entity.date,
      updated: entity.updated,
      creator: entity.creator,
      completed: entity.completed,
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
      date: convertTimestampToDateTime(data['date'] as Timestamp),
      updated: convertTimestampToDateTime(data['updated'] as Timestamp),
      creator: UserModel.fromMap(data['creator']),
      completed: data['completed'],
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
      if (date != null) 'date': date,
      if (updated != null) 'updated': updated,
      if (creator != null) 'creator': UserModel.fromEntity(creator!).toMap(),
      if (completed != null) 'completed': completed,
    };
  }
}
