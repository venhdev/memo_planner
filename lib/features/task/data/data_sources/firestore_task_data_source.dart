import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/constants/typedef.dart';
import 'package:memo_planner/features/task/data/models/myday_model.dart';
import 'package:memo_planner/features/task/data/models/task_model.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/notification/local_notification_manager.dart';
import '../../domain/entities/myday_entity.dart';
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

  // other function
  Future<int> countTaskList(String lid);

  //! MyDay
  SDocumentSnapshot getOneMyDayStream(String email, String tid);
  Future<void> removeMismatchInMyDay(String email, DateTime date);
  SQuerySnapshot getAllMyDayStream(String email); // >> [getOneTaskStream]

  //! Task
  SQuerySnapshot getAllTaskStream(String lid);
  SDocumentSnapshot getOneTaskStream(String lid, String tid);

  Future<TaskEntity> getTask(String lid, String tid);
  Future<void> addTask(TaskEntity task);
  Future<void> editTask(TaskEntity updatedTask, TaskEntity oldTask);
  Future<void> deleteTask(TaskEntity task);
  Future<void> toggleTask(String tid, String lid, bool value);

  Future<void> assignTask(String lid, String tid, String email);
  Future<void> unassignTask(String lid, String tid, String email);

  Future<void> addToMyDay(String email, MyDayEntity myDay);
  Future<void> toggleKeepInMyDay(String email, String tid, bool isKeep);
  Future<void> removeFromMyDay(String email, MyDayEntity myDay);

  Future<MyDayEntity?> findOneMyDay(String email, String tid);
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
        .orderBy('listName')
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
    return _firestore.collection(pathToTaskLists).doc(lid).collection(pathToTasks).orderBy('taskName').snapshots();
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
  Future<void> deleteTask(TaskEntity task) async {
    if (task.reminders?.useDefault == true) {
      await _localNotification.I.cancel(task.reminders!.rid!);
    }
    await _firestore.collection(pathToTaskLists).doc(task.lid).collection(pathToTasks).doc(task.tid).delete();
  }

  @override
  Future<void> editTask(TaskEntity updatedTask, TaskEntity oldTask) async {
    final docRef =
        _firestore.collection(pathToTaskLists).doc(updatedTask.lid).collection(pathToTasks).doc(updatedTask.tid);

    await docRef.update(TaskModel.fromEntity(updatedTask).toMap()).then(
      (_) async {
        // -- new: have reminder, old?...
        if (updatedTask.reminders?.useDefault == true) {
          // > oldTask have the same reminder time with updatedTask >> ignore

          if (oldTask.reminders?.useDefault == true) {
            // -- old: have reminder, new: have reminder >> update schedule notification with same rid
            // > oldTask have the same reminder time with updatedTask >> ignore
            if (oldTask.reminders!.scheduledTime!.isAtSameMomentAs(updatedTask.reminders!.scheduledTime!)) return;
            // > update with same rid but different time
            await _localNotification.setScheduleNotification(
              id: updatedTask.reminders!.rid!,
              title: updatedTask.taskName,
              body: 'Remember to do this task',
              scheduledTime: updatedTask.reminders!.scheduledTime!,
            );
          } else {
            // new: have reminder, old: no reminder >> set new schedule notification
            await _localNotification.setScheduleNotification(
              id: updatedTask.reminders!.rid!,
              title: updatedTask.taskName,
              body: 'Remember to do this task',
              scheduledTime: updatedTask.reminders!.scheduledTime!,
            );
          }
        } else {
          // new: no reminder, old: have reminder >> cancel old schedule notification
          if (oldTask.reminders?.rid != null) await _localNotification.I.cancel(oldTask.reminders!.rid!);
        }
      },
    );
  }

  @override
  Future<TaskEntity> getTask(String lid, String tid) async {
    final docRef = _firestore.collection(pathToTaskLists).doc(lid).collection(pathToTasks).doc(tid);
    final doc = await docRef.get();
    return TaskModel.fromMap(doc.data()!);
  }

  @override
  Future<void> toggleTask(String tid, String lid, bool value) async {
    final docRef = _firestore.collection(pathToTaskLists).doc(lid).collection(pathToTasks).doc(tid);
    await docRef.update({'completed': value});
  }

  @override
  SDocumentSnapshot getOneTaskStream(String lid, String tid) {
    return _firestore.collection(pathToTaskLists).doc(lid).collection(pathToTasks).doc(tid).snapshots();
  }

  @override
  Future<void> assignTask(String lid, String tid, String email) async {
    final docRef = _firestore.collection(pathToTaskLists).doc(lid).collection(pathToTasks).doc(tid);
    return await docRef.update({
      'assignedMembers': FieldValue.arrayUnion([email])
    });
  }

  @override
  Future<void> unassignTask(String lid, String tid, String email) async {
    final docRef = _firestore.collection(pathToTaskLists).doc(lid).collection(pathToTasks).doc(tid);
    return await docRef.update({
      'assignedMembers': FieldValue.arrayRemove([email])
    });
  }

  @override
  Future<int> countTaskList(String lid) async {
    final result = await _firestore.collection(pathToTaskLists).doc(lid).collection(pathToTasks).count().get();
    return result.count;
  }

  @override
  Future<void> addToMyDay(String email, MyDayEntity myDay) async {
    final collRef = _firestore.collection(pathToUsers).doc(email).collection(pathToMyDay);
    await collRef.doc(myDay.tid).set(MyDayModel.fromEntity(myDay).toMap());
  }

  @override
  Future<void> removeFromMyDay(String email, MyDayEntity myDay) async {
    return await _firestore.collection(pathToUsers).doc(email).collection(pathToMyDay).doc(myDay.tid).delete();
  }

  @override
  SDocumentSnapshot getOneMyDayStream(String email, String tid) {
    return _firestore.collection(pathToUsers).doc(email).collection(pathToMyDay).doc(tid).snapshots();
  }

  @override
  Future<void> toggleKeepInMyDay(String email, String tid, bool isKeep) async {
    return await _firestore.collection(pathToUsers).doc(email).collection(pathToMyDay).doc(tid).update({
      'keep': isKeep,
    });
  }

  @override
  Future<MyDayEntity?> findOneMyDay(String email, String tid) async {
    return await _firestore.collection(pathToUsers).doc(email).collection(pathToMyDay).doc(tid).get().then(
      (value) {
        if (value.data() == null) return null;
        return MyDayModel.fromMap(value.data()!);
      },
    );
  }

  @override
  Future<void> removeMismatchInMyDay(String email, DateTime date) async {
    final collRef = _firestore.collection(pathToUsers).doc(email).collection(pathToMyDay);
    collRef.get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        final map = docSnapshot.data();
        if (map['keep'] == true || map['created'] == Timestamp.fromDate(date)) continue;
        docSnapshot.reference.delete();
      }
    }, onError: (e) => log('getAllMyDayStream Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}'));
  }

  @override
  SQuerySnapshot getAllMyDayStream(String email) {
    final collRef = _firestore.collection(pathToUsers).doc(email).collection(pathToMyDay);
    return collRef.snapshots();
  }
}
