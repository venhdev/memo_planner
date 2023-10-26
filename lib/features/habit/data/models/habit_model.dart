import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memo_planner/core/utils/convertors.dart';
import 'package:memo_planner/features/authentication/data/models/user_model.dart';

import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/entities/habit_entity.dart';

class HabitModel extends HabitEntity {
  const HabitModel({
    String? hid,
    String? summary,
    String? description,
    DateTime? start,
    DateTime? end,
    DateTime? created,
    DateTime? updated,
    UserEntity? creator,
    List<HabitCompletion>? completions,
  }) : super(
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

  // copyWith
  @override
  HabitModel copyWith({
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
    return HabitModel(
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
      creator: UserModel.fromDocument(data['creator']).toEntity(),
      completions: (data['completions']).map<HabitCompletion>((completion) {
        return HabitCompletion(
          hid: completion['hid'],
          completedAt: convertTimestampToDateTime(data['completedAt'] as Timestamp),
        );
      }).toList(),
    );
  }

  // to DocumentSnapshot
  Map<String, dynamic> toDocument() {
    return {
      'hid': hid,
      'summary': summary,
      'description': description,
      'start': start,
      'end': end,
      'created': created,
      'updated': updated,
      'creator': UserModel.fromEntity(creator!).toDocument(),
      'completions': completions,
    };
  }

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
