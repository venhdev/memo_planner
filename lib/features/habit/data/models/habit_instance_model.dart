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
    DateTime? created,
    DateTime? updated,
    UserEntity? creator,
    bool? status,
  }) : super(
          iid: iid,
          hid: hid,
          summary: summary,
          created: created,
          updated: updated,
          creator: creator,
          status: status,
        );

  //fromEntity
  factory HabitInstanceModel.fromEntity(HabitInstanceEntity entity) {
    return HabitInstanceModel(
      iid: entity.iid,
      hid: entity.hid,
      created: entity.created,
      updated: entity.updated,
      creator: entity.creator,
      status: entity.status,
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
      created: convertTimestampToDateTime(data['created'] as Timestamp),
      updated: convertTimestampToDateTime(data['updated'] as Timestamp),
      creator: UserModel.fromMap(data['creator']),
      status: data['status'],
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
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (creator != null) 'creator': UserModel.fromEntity(creator!).toMap(),
      if (status != null) 'status': status,
    };
  }
}
