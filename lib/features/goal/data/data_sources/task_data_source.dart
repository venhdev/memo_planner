import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/constants/constants.dart';
import 'package:memo_planner/features/goal/data/models/task_model.dart';

import '../../../../core/constants/typedef.dart';
import '../../domain/entities/task_entity.dart';

abstract class TaskDataSource {
  Future<SQuerySnapshot> getTaskStream(String email);
  Future<void> addTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(TaskEntity task);
}

@Singleton(as: TaskDataSource)
class TaskDataSourceImpl extends TaskDataSource {
  TaskDataSourceImpl(
    this._firestore,
  );

  final FirebaseFirestore _firestore;

  @override
  Future<SQuerySnapshot> getTaskStream(String email) async {
    return _firestore.collection(pathToUsers).doc(email).collection(pathToTasks).snapshots();
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    var taskCollRef = _firestore.collection(pathToUsers).doc(task.creator!.email).collection(pathToTasks);
    var taskId = taskCollRef.doc().id;
    task = task.copyWith(taskId: taskId);
    await taskCollRef.doc(taskId).set(TaskModel.fromEntity(task).toDocument());
  }

  @override
  Future<void> deleteTask(TaskEntity task) async {
    var taskDocRef =
        _firestore.collection(pathToUsers).doc(task.creator!.email).collection(pathToTasks).doc(task.taskId);
    await taskDocRef.delete();
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    var taskDocRef =
        _firestore.collection(pathToUsers).doc(task.creator!.email).collection(pathToTasks).doc(task.taskId);
    await taskDocRef.update(TaskModel.fromEntity(task).toDocument());
  }
}
