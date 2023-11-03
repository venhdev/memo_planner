import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/convertors.dart';
import '../../../authentication/data/models/user_model.dart';
import '../../domain/entities/habit_entity.dart';

class HabitModel extends HabitEntity {
  const HabitModel({
    super.hid,
    super.summary,
    super.description,
    super.start,
    super.end,
    super.created,
    super.updated,
    super.creator,
    super.completions,
  });
  // from Entity
  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      hid: entity.hid,
      summary: entity.summary,
      description: entity.description,
      start: entity.start,
      end: entity.end,
      created: entity.created,
      updated: entity.updated,
      creator: entity.creator,
      completions: entity.completions,
    );
  }

  // from DocumentSnapshot
  factory HabitModel.fromDocument(Map<String, dynamic> data) {
    return HabitModel(
      hid: data['hid'],
      summary: data['summary'],
      description: data['description'],
      start: convertTimestampToDateTime(data['start'] as Timestamp),
      end: convertTimestampToDateTime(data['end'] as Timestamp),
      created: convertTimestampToDateTime(data['created'] as Timestamp),
      updated: convertTimestampToDateTime(data['updated'] as Timestamp),
      creator: UserModel.fromDocument(data['creator']),
      completions: (data['completions']).map<HabitCompletion>((completion) {
        return HabitCompletion(
          hid: completion['hid'],
          completedAt:
              convertTimestampToDateTime(data['completedAt'] as Timestamp),
        );
      }).toList(),
    );
  }

  // to DocumentSnapshot to be saved to Firestore
  Map<String, dynamic> toDocument() {
    return {
      if (hid != null) 'hid': hid,
      if (summary != null) 'summary': summary,
      if (description != null) 'description': description,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (creator != null)
        'creator': UserModel.fromEntity(creator!).toDocument(),
      if (completions != null) 'completions': completions,
    };
  }

  // to Entity
  HabitEntity toEntity() {
    return HabitEntity(
      hid: hid,
      summary: summary,
      description: description,
      start: start,
      end: end,
      created: created,
      updated: updated,
      creator: creator,
      completions: completions,
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
