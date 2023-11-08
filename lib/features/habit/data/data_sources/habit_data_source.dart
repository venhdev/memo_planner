import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/convertors.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_instance_entity.dart';
import '../models/habit_instance_model.dart';
import '../models/habit_model.dart';

abstract class HabitDataSource {
  Stream<QuerySnapshot> getHabitStream(UserEntity user);
  Future<void> addHabit(HabitEntity habit);
  Future<void> updateHabit(HabitEntity habit);
  Future<void> deleteHabit(HabitEntity habit);

  Stream<QuerySnapshot<Map<String, dynamic>>> getHabitInstanceStream(
      HabitEntity habit, DateTime focusDate);
  Future<void> addHabitInstance(
    HabitEntity habit,
    DateTime date,
  );
  Future<void> changeHabitInstanceStatus(
    HabitInstanceEntity instance,
    bool status,
  );
}

@Singleton(as: HabitDataSource)
class HabitDataSourceImpl extends HabitDataSource {
  HabitDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<void> addHabit(HabitEntity habit) async {
    try {
      // get the collection reference
      final habitCollectionRef = _firestore
          .collection(pathToUsers)
          .doc(habit.creator!.email)
          .collection(pathToHabits);

      // create a new document with a unique id
      final hid = habitCollectionRef.doc().id;

      habit = habit.copyWith(hid: hid);
      // convert to the type that firestore accepts
      final habitDocument = (HabitModel.fromEntity(habit)).toDocument();
      await habitCollectionRef.doc(hid).set(habitDocument);
    } on FirebaseException catch (e) {
      debugPrint(
          'HabitDataSourceImpl:addHabit:FirebaseException --type of e: ${e.runtimeType}');
      debugPrint(e.toString());
      throw ServerException(code: e.code, message: e.toString());
    } catch (e) {
      debugPrint(
          'HabitDataSourceImpl:addHabit:Exception --type of e: ${e.runtimeType}');
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteHabit(HabitEntity habit) async {
    try {
      final habitCollectionRef = _firestore
          .collection(pathToUsers)
          .doc(habit.creator!.email)
          .collection(pathToHabits);

      await habitCollectionRef.doc(habit.hid).delete();
    } on FirebaseException catch (e) {
      debugPrint(
          'HabitDataSourceImpl:deleteHabit --type of e: ${e.runtimeType}');
      debugPrint(e.toString());
      throw ServerException(code: e.code, message: e.toString());
    } catch (e) {
      debugPrint(
          'HabitDataSourceImpl:deleteHabit --type of e: ${e.runtimeType}');
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateHabit(HabitEntity habit) async {
    try {
      final habitCollectionRef = _firestore
          .collection(pathToUsers)
          .doc(habit.creator!.email)
          .collection(pathToHabits);

      final habitModel = HabitModel.fromEntity(habit);

      await habitCollectionRef.doc(habit.hid).update(habitModel.toDocument());
    } on FirebaseException catch (e) {
      debugPrint(
          'HabitDataSourceImpl:updateHabit --type of e: ${e.runtimeType}');
      debugPrint(e.toString());
      throw ServerException(code: e.code, message: e.toString());
    } catch (e) {
      debugPrint(
          'HabitDataSourceImpl:updateHabit --type of e: ${e.runtimeType}');
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Stream<QuerySnapshot> getHabitStream(UserEntity user) {
    final habitCollectionRef = _firestore
        .collection(pathToUsers)
        .doc(user.email)
        .collection(pathToHabits);
    return habitCollectionRef.snapshots();
  }

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
      debugPrint('iid: $iid');

      HabitInstanceModel habitInstanceModel = HabitInstanceModel(
        iid: iid,
        hid: habit.hid,
        summary: habit.summary,
        created: DateTime.now(),
        updated: DateTime.now(),
        creator: habit.creator,
        status: true,
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
      HabitInstanceEntity instance, bool status) async {
    final habitIDocRef = _firestore
        .collection(pathToUsers)
        .doc(instance.creator!.email)
        .collection(pathToHabits)
        .doc(instance.hid)
        .collection(pathToHabitInstances)
        .doc(instance.iid);

    habitIDocRef.update({'status': status});
  }
}
