import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../authentication/data/data_sources/authentication_data_source.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/entities/habit_entity.dart';
import '../models/habit_model.dart';

abstract class HabitDataSource {
  Stream<QuerySnapshot> getHabitStream(UserEntity user);
  Future<void> addHabit(HabitEntity habit);
  Future<void> updateHabit(HabitEntity habit);
  Future<void> deleteHabit(HabitEntity habit);

  Future<HabitEntity?> getHabitByHid(String hid);
}

@Singleton(as: HabitDataSource)
class HabitDataSourceImpl extends HabitDataSource {
  HabitDataSourceImpl(this._firestore, this._authenticationDataSource);

  final FirebaseFirestore _firestore;
  final AuthenticationDataSource _authenticationDataSource;

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
    final habitCollRef = _firestore
        .collection(pathToUsers)
        .doc(user.email)
        .collection(pathToHabits);
    return habitCollRef.snapshots();
  }

  @override
  Future<HabitEntity?> getHabitByHid(String hid) async {
    final user = _authenticationDataSource.currentUser;
    if (user != null) {
      final habitDocRef = _firestore
          .collection(pathToUsers)
          .doc(user.email)
          .collection(pathToHabits)
          .doc(hid);
      final habitDoc = await habitDocRef.get();

      if (habitDoc.exists) {
        return HabitModel.fromDocument(habitDoc.data()!);
      } else {
        throw ServerException(message: 'Habit not found');
      }
    }
    return null;
  }
}
