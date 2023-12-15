import 'dart:developer' as dev;
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/constants/typedef.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/notification/local_notification_manager.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/streak_instance_entity.dart';
import '../models/habit_instance_model.dart';
import '../models/habit_model.dart';

/// *deprecated: /users/ [user#email] / habits [habit#summary]
// final habitCollectionRef = _firestore.collection(pathToUsers).doc(habit.creator!.email).collection(pathToHabits);

abstract class HabitDataSource {
  SQuerySnapshot getHabitStream(UserEntity user);
  SDocumentSnapshot getOneHabitStream(String hid);
  Future<void> addHabit(HabitEntity habit);
  Future<void> updateHabit(HabitEntity habit);
  Future<void> deleteHabit(HabitEntity habit);

  Future<HabitEntity?> getHabitByHid(String hid);
  Future<List<StreakInstanceEntity>> getTopHabitStreakOfUser(String hid, String collectionEmailPath);

  Future<void> addMember(String hid, String email);
  Future<void> removeMember(String hid, String email);
}

@Singleton(as: HabitDataSource)
class HabitDataSourceImpl extends HabitDataSource {
  HabitDataSourceImpl(this._firestore, this._localNotificationManager);

  final FirebaseFirestore _firestore;
  final LocalNotificationManager _localNotificationManager;

  @override
  Future<void> addHabit(HabitEntity habit) async {
    try {
      // get the collection reference

      // *new: /habits/ [habit#summary]
      final habitCollectionRef = _firestore.collection(pathToHabits);

      // create a new document with a unique id
      final hid = habitCollectionRef.doc().id;

      habit = habit.copyWith(hid: hid);
      // convert to the type that firestore accepts
      final habitDocument = (HabitModel.fromEntity(habit)).toDocument();
      await habitCollectionRef.doc(hid).set(habitDocument).then(
        (value) {
          // > Add notification for the habit
          // ? check if habit use default reminder or not
          if (habit.reminders!.useDefault) {
            // set the notification same as the start
            loadDailyNotification(habit, _localNotificationManager);
          }
          // < Add notification for the habit
        },
      );
    } on FirebaseException catch (e) {
      throw ServerException(code: e.code, message: e.toString());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteHabit(HabitEntity habit) async {
    // implement below just delete the document.
    final habitCollRef = _firestore.collection(pathToHabits);
    await habitCollRef.doc(habit.hid).delete();

    // > cancel the notification
    _localNotificationManager.I.cancel(habit.reminders!.rid!);

    // > delete all sub collection

    // <https://firebase.google.com/docs/firestore/manage-data/delete-data>
    // loop for all sub collection has id = email
    if (habit.members!.isNotEmpty) {
      for (var member in habit.members!) {
        final habitInstanceCollRef = habitCollRef.doc(habit.hid).collection(member);
        await habitInstanceCollRef.get().then((snapshot) {
          for (var ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
      }
    }
    // < delete all sub collection

    // await habitCollRef.doc(habit.hid).delete();
  }

  @override
  Future<void> updateHabit(HabitEntity habit) async {
    try {
      // final habitCollectionRef = _firestore.collection(pathToUsers).doc(habit.creator!.email).collection(pathToHabits);
      final habitCollectionRef = _firestore.collection(pathToHabits);

      final habitModel = HabitModel.fromEntity(habit);

      await habitCollectionRef.doc(habit.hid).update(habitModel.toDocument()).then((value) {
        // > Edit notification for the habit
        // ? check if habit use default reminder or not
        if (habit.reminders!.useDefault) {
          // set the notification same as the start
          loadDailyNotification(habit, _localNotificationManager);
        }
        // < Edit notification for the habit
      });

      // update for each habit instance that has edited filed is false (mean that instance name like parent habit)
      final habitInstanceCollectionRef =
          _firestore.collection(pathToHabits).doc(habit.hid).collection(habit.creator!.email!).where('edited', isEqualTo: false);
      await habitInstanceCollectionRef.get().then((snapshot) {
        for (var ds in snapshot.docs) {
          ds.reference.update({'summary': habit.summary});
        }
      });
    } on FirebaseException catch (e) {
      dev.log('rethrow --> Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  SQuerySnapshot getHabitStream(UserEntity user) {
    // final habitCollRef = _firestore.collection(pathToUsers).doc(user.email).collection(pathToHabits).orderBy('summary');
    dev.log('getHabitStream params user: $user');
    // get all habits that user is owner & member
    final habitCollRef = _firestore
        .collection(pathToHabits)
        // .where('creator.email', isEqualTo: user.email)
        .where(Filter.or(
          Filter('creator.email', isEqualTo: user.email),
          // Filter('members', arrayContains: UserModel.fromEntity(user).toDocument()),
          Filter('members', arrayContains: user.email),
        ))
        .orderBy('summary');

    // > retrieve notification for each habit to set the local notification
    habitCollRef.get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        _localNotificationManager.I.cancelAll();
        return habitCollRef.snapshots();
      }
      
      for (var doc in snapshot.docs) {
        final HabitModel habit = HabitModel.fromDocument(doc.data());
        // ? check if habit use default reminder or not
        if (habit.reminders!.useDefault) {
          // set the notification same as the start
          loadDailyNotification(habit, _localNotificationManager);
        }
      }
    });
    return habitCollRef.snapshots();
  }

  @override
  Future<HabitEntity?> getHabitByHid(String hid) async {
    // final habitDocRef = _firestore.collection(pathToUsers).doc(user.email).collection(pathToHabits).doc(hid);
    final habitDocRef = _firestore.collection(pathToHabits).doc(hid);
    final habitDoc = await habitDocRef.get();

    if (habitDoc.exists) {
      return HabitModel.fromDocument(habitDoc.data()!);
    } else {
      // throw ServerException(message: 'Habit not found');
      return null;
    }
  }

  // scenarios:
  // 1. the first day of the list is completed [1,0...]
  // 2. the middle day of the list is completed [...0,1,0...]
  // 3. the last day of the list is completed [...0,1]

  //? the main params is path to habit instances collection [hid, email] -- /habits/ [hid] / [email]
  @override
  Future<List<StreakInstanceEntity>> getTopHabitStreakOfUser(String hid, String collectionEmailPath) async {
    // final habitICollRef =
    //     _firestore.collection(pathToUsers).doc(habit.creator!.email).collection(pathToHabits).doc(habit.hid).collection(pathToHabitInstances);
    final habitICollRef = _firestore.collection(pathToHabits).doc(hid).collection(collectionEmailPath);
    final habitIDocRef = await habitICollRef.orderBy('date').get();

    List<HabitInstanceModel> instances = [];

    if (habitIDocRef.docs.isNotEmpty) {
      instances = habitIDocRef.docs.map((doc) => HabitInstanceModel.fromDocument(doc.data())).toList();
    } else {
      return [];
    }

    List<StreakInstanceEntity> result = []; // each StreakInstanceEntity contain [start, end, length]
    int currentStreakLength = 0; // the length of current streak in loop
    DateTime currentStreakStart = instances.first.date!; // the start date of current streak in loop
    //? cannot move [currentStreakStart] into the loop because it will be override by the next day

    // loop through all instances to find the top streaks
    for (int i = 0; i < instances.length; i++) {
      final HabitInstanceModel instance = instances[i]; // current instance
      final DateTime currentStreakDate = instance.date!;
      final bool isLastInstance = (i == instances.length - 1); // check if the current instance is the last one <-- length - 1
      final bool isInstanceCompleted = instance.completed!; // current instance is completed or not

      if (isInstanceCompleted) {
        currentStreakLength++;
        // the next day has init instance or not
        final isCreated = await isCreatedInstance(
          iid: getIid(hid, currentStreakDate.add(const Duration(days: 1))),
          collectionReference: habitICollRef,
        );

        // if the next day doesn't have init instance, means that the streak is broken -> add the streak to result
        if (!isCreated) {
          final StreakInstanceEntity streak = StreakInstanceEntity(
            start: currentStreakStart,
            end: currentStreakDate,
            length: currentStreakLength,
          );
          result.add(streak);
          currentStreakLength = 0;
          if (!isLastInstance) currentStreakStart = instances[i + 1].date!;
        }
      } else {
        // the current instance is not completed

        // if the current streak length > 0, means that before this instance, there is some completed instances
        // -> add the streak to result
        if (currentStreakLength > 0) {
          final StreakInstanceEntity streak = StreakInstanceEntity(
            start: currentStreakStart,
            end: instances[i - 1].date!,
            length: currentStreakLength,
          );
          result.add(streak);
          currentStreakLength = 0;
        }
      }

      // if the current instance is the last one and the current streak length > 0
      // -- the last streak is not added to result yet
      // -> add the streak to result
      if (isLastInstance && currentStreakLength > 0) {
        final StreakInstanceEntity streak = StreakInstanceEntity(
          start: currentStreakStart,
          end: currentStreakDate,
          length: currentStreakLength,
        );
        result.add(streak);
      }

      // if the current instance is not completed && not the last one
      if (!isInstanceCompleted && !isLastInstance) {
        currentStreakStart = instances[i + 1].date!; // move to the next day
      }
    }

    // sort the result by length
    result.sort((prev, next) => next.length.compareTo(prev.length));
    if (result.length > 3) {
      result = result.sublist(0, 3);
    }
    result.reversed;
    return result;
  }

  @override
  SDocumentSnapshot getOneHabitStream(String hid) {
    final habitCollRef = _firestore
        .collection(pathToHabits)
        // .where('creator.email', isEqualTo: user.email)
        .doc(hid);
    return habitCollRef.snapshots();
  }

  @override
  Future<void> addMember(String hid, String email) async {
    try {
      _firestore.collection(pathToHabits).doc(hid).update({
        'members': FieldValue.arrayUnion([email])
      }).then((value) => log('Add Member Success'));
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
    }
  }

  @override
  Future<void> removeMember(String hid, String email) async {
    try {
      await _firestore.collection(pathToHabits).doc(hid).update({
        'members': FieldValue.arrayRemove([email])
      }).then((value) => log('Remove Member Success'));
      // NOTE >? should delete all habit instances of the member ?

      return;
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
    }
  }
}

Future<bool> isCreatedInstance({
  required String iid,
  required CollectionReference<Map<String, dynamic>> collectionReference,
}) async {
  return await collectionReference.doc(iid).get().then((value) => value.exists);
}

Future<void> loadDailyNotification(HabitEntity habit, LocalNotificationManager localNotificationManager) async {
  // ? check if habit use default reminder or not
  if (habit.reminders!.useDefault) {
    // set the notification same as the start
    localNotificationManager.setDailyScheduleNotification(
      id: habit.reminders!.rid!,
      title: 'Time to ${habit.summary}',
      body: habit.description,
      scheduledDate: habit.start!,
      payload: habit.hid,
    );
  }
}
