import 'package:memo_planner/features/goal/domain/entities/target_entity.dart';

import '../../../authentication/data/models/user_model.dart';
import '../../../authentication/domain/entities/user_entity.dart';

class TargetModel extends TargetEntity {
  const TargetModel({
    required String? targetId,
    required String? summary,
    required String? description,
    required int? target,
    required int? progress,
    required String? unit,
    required UserEntity? creator,
    String kind = 'goal#target',
  }) : super(
          targetId: targetId,
          summary: summary,
          description: description,
          target: target,
          progress: progress,
          unit: unit,
          creator: creator,
          kind: kind,
        );

  factory TargetModel.fromEntity(TargetEntity entity) {
    return TargetModel(
      targetId: entity.targetId,
      summary: entity.summary,
      description: entity.description,
      target: entity.target,
      progress: entity.progress,
      unit: entity.unit,
      creator: entity.creator,
    );
  }

  factory TargetModel.fromDocument(Map<String, dynamic> data) {
    return TargetModel.fromMap(data);
  }

  factory TargetModel.fromMap(Map<String, dynamic> data) {
    return TargetModel(
      targetId: data['targetId'],
      summary: data['summary'],
      description: data['description'],
      target: data['target'],
      progress: data['progress'],
      unit: data['unit'],
      creator: UserModel.fromDocument(data['creator']),
    );
  }

  Map<String, dynamic> toDocument() {
    return toMap();
  }

  Map<String, dynamic> toMap() {
    return {
      if (targetId != null) 'targetId': targetId,
      if (summary != null) 'summary': summary,
      if (description != null) 'description': description,
      if (target != null) 'target': target,
      if (progress != null) 'progress': progress,
      if (unit != null) 'unit': unit,
      if (creator != null) 'creator': UserModel.fromEntity(creator!).toDocument(),
      'kind': kind,
    };
  }
}