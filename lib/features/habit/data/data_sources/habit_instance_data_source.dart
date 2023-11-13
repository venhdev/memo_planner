import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/features/authentication/data/data_sources/authentication_data_source.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/constants/typedef.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/convertors.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_instance_entity.dart';
import '../models/habit_instance_model.dart';

abstract class HabitInstanceDataSource {
  SQuerySnapshot getHabitInstanceStream(
      HabitEntity habit, DateTime focusDate);

  Future<HabitInstanceEntity?> findHabitInstanceById(String iid);
  Future<void> addHabitInitInstance(
    HabitEntity habit,
    DateTime date,
  );

  Future<void> updateHabitInstance(HabitInstanceEntity instance);

  Future<void> changeHabitInstanceStatus(
    HabitInstanceEntity instance,
    bool completed,
  );
}

@Singleton(as: HabitInstanceDataSource)
class HabitInstanceDataSourceImpl extends HabitInstanceDataSource {
  HabitInstanceDataSourceImpl(this._firestore, this._authenticationDataSource);
  final FirebaseFirestore _firestore;
  final AuthenticationDataSource _authenticationDataSource;

  @override
  Future<void> addHabitInitInstance(HabitEntity habit, DateTime date) async {
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
        description: habit.description,
        date: date,
        updated: DateTime.now(),
        creator: habit.creator,
        completed: true,
        edited: false,
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
  SQuerySnapshot getHabitInstanceStream(
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

  @override
  Future<HabitInstanceEntity?> findHabitInstanceById(String iid) async {
    final user = _authenticationDataSource.currentUser;

    if (user != null) {
      final habitIDocRef = _firestore
          .collection(pathToUsers)
          .doc(user.email)
          .collection(pathToHabits)
          .doc(iid.split('_').first)
          .collection(pathToHabitInstances)
          .doc(iid);

      return habitIDocRef.get().then((value) {
        if (value.exists) {
          return HabitInstanceModel.fromDocument(value.data()!);
        } else {
          return null;
        }
      });
    } else {
      throw ServerException(message: 'User is not logged in');
    }
  }
  
  @override
  Future<void> updateHabitInstance(HabitInstanceEntity instance) async {
    final habitIDocRef = _firestore
        .collection(pathToUsers)
        .doc(instance.creator!.email)
        .collection(pathToHabits)
        .doc(instance.hid)
        .collection(pathToHabitInstances)
        .doc(instance.iid);

    habitIDocRef.update({
      'summary': instance.summary,
      'description': instance.description,
      'edited': true, // update the edited field
      'updated': DateTime.now(), // update the updated field
    });
  }
}
