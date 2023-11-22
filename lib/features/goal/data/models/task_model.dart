import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/helpers.dart';
import '../../../authentication/data/models/user_model.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required String? taskId,
    required String? summary,
    required String? description,
    required UserEntity? creator,
    required DateTime? dueDate,
    required bool? completed,
    String kind = 'goal#task',
  }) : super(
          taskId: taskId,
          summary: summary,
          description: description,
          creator: creator,
          dueDate: dueDate,
          completed: completed,
          kind: kind,
        );

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      taskId: entity.taskId,
      summary: entity.summary,
      description: entity.description,
      creator: entity.creator,
      dueDate: entity.dueDate,
      completed: entity.completed,
    );
  }

  factory TaskModel.fromDocument(Map<String, dynamic> data) {
    return TaskModel.fromMap(data);
  }

  factory TaskModel.fromMap(Map<String, dynamic> data) {
    return TaskModel(
      taskId: data['taskId'],
      summary: data['summary'],
      description: data['description'],
      creator: UserModel.fromDocument(data['creator']),
      dueDate: convertTimestampToDateTime(data['dueDate'] as Timestamp?),
      completed: data['completed'],
    );
  }

  Map<String, dynamic> toDocument() {
    return toMap();
  }


  Map<String, dynamic> toMap() {
    return {
      if (taskId != null) 'taskId': taskId,
      if (summary != null) 'summary': summary,
      if (description != null) 'description': description,
      if (creator != null) 'creator': UserModel.fromEntity(creator!).toDocument(),
      if (dueDate != null) 'dueDate': dueDate,
      if (completed != null) 'completed': completed,
      'kind': kind,
    };
  }
}
