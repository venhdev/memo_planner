import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/features/habit/domain/entities/streak_entity.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/convertors.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_instance_entity.dart';
import '../models/habit_instance_model.dart';

abstract class HabitInstanceDataSource {
  Stream<QuerySnapshot<Map<String, dynamic>>> getHabitInstanceStream(
      HabitEntity habit, DateTime focusDate);
  Future<void> addHabitInstance(
    HabitEntity habit,
    DateTime date,
  );
  Future<void> changeHabitInstanceStatus(
    HabitInstanceEntity instance,
    bool completed,
  );

  Future<List<StreakEntity>> getTopStreakOfHabit(HabitEntity habit);
}

@Singleton(as: HabitInstanceDataSource)
class HabitInstanceDataSourceImpl extends HabitInstanceDataSource {
  HabitInstanceDataSourceImpl(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<void> addHabitInstance(HabitEntity habit, DateTime date) async {
    try {
      final habitICollRef = _firestore
          .collection(pathToUsers)
          .doc(habit.creator!.email)
          .collection(pathToHabits)
          .doc(habit.hid)
          .collection(pathToHabitInstances);

      final iid = '${habit.hid}_${convertDateTimeToyyyyMMdd(date)}';

      if (date.microsecond != 0) {
        // remove the time part * because the first run app will have time part
        date = DateTime(date.year, date.month, date.day);
      }
      HabitInstanceModel habitInstanceModel = HabitInstanceModel(
        iid: iid,
        hid: habit.hid,
        summary: habit.summary,
        date: date,
        updated: DateTime.now(),
        creator: habit.creator,
        completed: true,
      );

      habitICollRef.doc(iid).set(habitInstanceModel.toDocument());
    } on FirebaseException catch (e) {
      debugPrint(
          'HabitDataSourceImpl:addHabitInstance --type of e: ${e.runtimeType}');
      debugPrint(e.toString());
      throw ServerException(code: e.code, message: e.toString());
    } catch (e) {
      debugPrint(
          'HabitDataSourceImpl:addHabitInstance --type of e: ${e.runtimeType}');
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getHabitInstanceStream(
      HabitEntity habit, DateTime focusDate) {
    final habitICollRef = _firestore
        .collection(pathToUsers)
        .doc(habit.creator!.email)
        .collection(pathToHabits)
        .doc(habit.hid)
        .collection(pathToHabitInstances);

    final iid = getIid(habit.hid!, focusDate);
    return habitICollRef.where('iid', isEqualTo: iid).snapshots();
  }

  @override
  Future<void> changeHabitInstanceStatus(
      HabitInstanceEntity instance, bool completed) async {
    final habitIDocRef = _firestore
        .collection(pathToUsers)
        .doc(instance.creator!.email)
        .collection(pathToHabits)
        .doc(instance.hid)
        .collection(pathToHabitInstances)
        .doc(instance.iid);

    habitIDocRef.update({
      'completed': completed,
      'updated': DateTime.now(), // update the updated field
    });
  }

  // scenarios:
  // 1. the first day of the list is completed [1,0...]
  // 2. the middle day of the list is completed [...0,1,0...]
  // 3. the last day of the list is completed [...0,1]
  @override
  Future<List<StreakEntity>> getTopStreakOfHabit(HabitEntity habit) async {
    final habitICollRef = _firestore
        .collection(pathToUsers)
        .doc(habit.creator!.email)
        .collection(pathToHabits)
        .doc(habit.hid)
        .collection(pathToHabitInstances);
    final habitIDocRef = await habitICollRef.orderBy('date').get();

    List<HabitInstanceModel> instances = [];

    if (habitIDocRef.docs.isNotEmpty) {
      instances = habitIDocRef.docs
          .map((doc) => HabitInstanceModel.fromDocument(doc.data()))
          .toList();
    } else {
      return [];
    }

    List<StreakEntity> result = [];
    int currentStreakLength = 0;
    DateTime currentStreakStart = instances.first.date!;

    for (int i = 0; i < instances.length; i++) {
      final HabitInstanceModel instance = instances[i];
      final DateTime currentStreakDate = instance.date!;
      final bool isLastInstance = (i == instances.length - 1);
      final bool isStreakCompleted = instance.completed!;

      if (isStreakCompleted) {
        currentStreakLength++;
        // check if the next day has init instance or not
        final isCreated = await isCreatedInstance(
          iid: getIid(
              habit.hid!, currentStreakDate.add(const Duration(days: 1))),
          collectionReference: habitICollRef,
        );

        // if the next day doesn't have init instance, then...
        if (!isCreated) {
          final StreakEntity streak = StreakEntity(
            start: currentStreakStart,
            end: currentStreakDate,
            length: currentStreakLength,
          );
          result.add(streak);
          currentStreakLength = 0;
          if (!isLastInstance) currentStreakStart = instances[i + 1].date!;
        }
      } else {
        // the streak is broken
        if (currentStreakLength > 0) {
          final StreakEntity streak = StreakEntity(
            start: currentStreakStart,
            end: instances[i - 1].date!,
            length: currentStreakLength,
          );
          result.add(streak);
          currentStreakLength = 0;
        }
      }

      if (isLastInstance && currentStreakLength > 0) {
        final StreakEntity streak = StreakEntity(
          start: currentStreakStart,
          end: currentStreakDate,
          length: currentStreakLength,
        );
        result.add(streak);
      }

      if (!isStreakCompleted && !isLastInstance) {
        currentStreakStart = instances[i + 1].date!;
      }
    }
    result.sort((prev, next) => next.length.compareTo(prev.length));
    if (result.length > 3) {
      result = result.sublist(0, 3);
    }
    result.reversed;
    return result;
  }
}

Future<bool> isCreatedInstance({
  required String iid,
  required CollectionReference<Map<String, dynamic>> collectionReference,
}) async {
  return await collectionReference.doc(iid).get().then((value) => value.exists);
}
