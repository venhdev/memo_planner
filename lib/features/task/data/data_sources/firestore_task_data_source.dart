import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/constants/typedef.dart';
import 'package:memo_planner/features/task/data/models/task_model.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/notification/local_notification_manager.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_list_entity.dart';
import '../models/task_list_model.dart';

abstract class FireStoreTaskDataSource {
  //! TaskList
  SQuerySnapshot getAllTaskListStreamOfUser(String email);
  SDocumentSnapshot getOneTaskListStream(String lid);

  Future<void> addTaskList(TaskListEntity taskList);
  Future<void> editTaskList(TaskListEntity updatedTaskList);
  Future<void> deleteTaskList(String lid);

  Future<void> addMember(String lid, String email);
  Future<void> removeMember(String lid, String email);

  //! Task
  SQuerySnapshot getAllTaskStream(String lid);

  Future<TaskEntity> getTask(String lid, String tid);
  Future<void> addTask(TaskEntity task);
  Future<void> editTask(TaskEntity updatedTask);
  Future<void> deleteTask(String lid, String tid);
}

@Singleton(as: FireStoreTaskDataSource)
class FireStoreTaskDataSourceImpl implements FireStoreTaskDataSource {
  FireStoreTaskDataSourceImpl(this._firestore, this._localNotification);

  final FirebaseFirestore _firestore;
  final LocalNotificationManager _localNotification;

  @override
  SQuerySnapshot getAllTaskListStreamOfUser(String email) {
    return _firestore
        .collection(pathToTaskLists)
        .where(Filter.or(
          Filter('creator.email', isEqualTo: email),
          Filter('members', arrayContains: email),
        ))
        .snapshots();
  }

  @override
  Future<void> addTaskList(TaskListEntity taskList) async {
    final collRef = _firestore.collection(pathToTaskLists);
    final lid = collRef.doc().id;
    taskList = taskList.copyWith(lid: lid);

    await collRef.doc(lid).set(TaskListModel.fromEntity(taskList).toMap());
  }

  @override
  Future<void> editTaskList(TaskListEntity updatedTaskList) async {
    return _firestore
        .collection(pathToTaskLists)
        .doc(updatedTaskList.lid)
        .update(TaskListModel.fromEntity(updatedTaskList).toMap());
  }

  @override
  Future<void> deleteTaskList(String lid) async {
    // get taskListRef
    final docRef = _firestore.collection(pathToTaskLists).doc(lid);
    await docRef.delete();

    //? can call the deleteTask method but it will do some extra work
    //remove all tasks in: /task-lists/ {lid} /tasks/ {tid}
    final tasks = await docRef.collection(pathToTasks).get();
    for (final task in tasks.docs) {
      // cancel notification
      final model = TaskModel.fromMap(task.data());
      if (model.reminders?.useDefault == true) {
        await _localNotification.I.cancel(model.reminders!.rid!);
      }
      // delete task reference
      await task.reference.delete();
    }
  }

  @override
  Future<void> addMember(String lid, String email) async {
    _firestore.collection(pathToTaskLists).doc(lid).update({
      'members': FieldValue.arrayUnion([email])
    });
  }

  @override
  Future<void> removeMember(String lid, String email) async {
    _firestore.collection(pathToTaskLists).doc(lid).update({
      'members': FieldValue.arrayRemove([email])
    });

    // remove member from every task that assigned to him/her
    final tasks = await _firestore.collection(pathToTaskLists).doc(lid).collection(pathToTasks).get();
    for (final task in tasks.docs) {
      final model = TaskModel.fromMap(task.data());
      // if (model.assignedMembers == null ) continue;

      if (model.assignedMembers == null) continue;
      if (model.assignedMembers!.isEmpty) continue;

      if (model.assignedMembers!.contains(email)) {
        // remove member (string email) from assignedMembers
        model.assignedMembers!.remove(email);
        await task.reference.update(model.toMap());
      }
    }
  }

  @override
  SDocumentSnapshot getOneTaskListStream(String lid) {
    return _firestore.collection(pathToTaskLists).doc(lid).snapshots();
  }

  @override
  SQuerySnapshot getAllTaskStream(String lid) {
    return _firestore.collection(pathToTaskLists).doc(lid).collection(pathToTasks).snapshots();
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    final collRef = _firestore.collection(pathToTaskLists).doc(task.lid).collection(pathToTasks);
    final tid = collRef.doc().id;
    task = task.copyWith(tid: tid);

    await collRef.doc(tid).set(TaskModel.fromEntity(task).toMap()).then(
      (_) {
        // set schedule notification for task
        if (task.reminders?.useDefault == true) {
          _localNotification.setScheduleNotification(
            id: task.reminders!.rid!,
            title: task.taskName,
            scheduledTime: task.reminders!.scheduledTime!,
          );
        }
      },
    );
  }

  @override
  Future<void> deleteTask(String lid, String tid) async {
    final task = await getTask(lid, tid);
    if (task.reminders?.useDefault == true) {
      await _localNotification.I.cancel(task.reminders!.rid!);
    }
    await _firestore.collection(pathToTaskLists).doc(lid).collection(pathToTasks).doc(tid).delete();
  }

  @override
  Future<void> editTask(TaskEntity updatedTask) {
    // TODO: implement editTask
    throw UnimplementedError();
  }

  @override
  Future<TaskEntity> getTask(String lid, String tid) async {
    final docRef = _firestore.collection(pathToTaskLists).doc(lid).collection(pathToTasks).doc(tid);
    final doc = await docRef.get();
    return TaskModel.fromMap(doc.data()!);
  }
}
