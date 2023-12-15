import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/constants/typedef.dart';
import 'package:memo_planner/features/task/data/models/task_model.dart';

import '../../../../core/constants/constants.dart';
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

  Future<void> addTask(TaskEntity task);
  Future<void> editTask(TaskEntity updatedTask);
  Future<void> deleteTask(String tid);
}

@Singleton(as: FireStoreTaskDataSource)
class FireStoreTaskDataSourceImpl implements FireStoreTaskDataSource {
  FireStoreTaskDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  SQuerySnapshot getAllTaskListStreamOfUser(String email) {
    return _firestore
        .collection(pathToTaskLists)
        .where(Filter.or(
          Filter('creator.email', isEqualTo: email),
          Filter('assignedMembers', arrayContains: email),
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

    //remove all tasks in: /task-lists/ {lid} /tasks/ {tid}
    final tasks = await docRef.collection(pathToTasks).get();
    for (final task in tasks.docs) {
      // TODO: remove notification -> call deleteTask(tid)
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

    return collRef.doc(tid).set(TaskModel.fromEntity(task).toMap());
  }

  @override
  Future<void> deleteTask(String tid) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<void> editTask(TaskEntity updatedTask) {
    // TODO: implement editTask
    throw UnimplementedError();
  }
}
