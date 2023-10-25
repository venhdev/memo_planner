import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/constants/constants.dart';
import 'package:memo_planner/core/error/exceptions.dart';

import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/entities/habit_entity.dart';
import '../models/habit_model.dart';

abstract class HabitDataSource {
  Future<Stream<List<HabitEntity>>> getHabits(UserEntity creator);
  Future<void> addHabit(HabitEntity habit);
  Future<void> updateHabit(HabitEntity habit);
  Future<void> deleteHabit(HabitEntity habit);
}

@Singleton(as: HabitDataSource)
class HabitDataSourceImpl extends HabitDataSource {
  HabitDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<void> addHabit(HabitEntity habit) async {
    try {
      debugPrint('1\n');
      final habitCollectionRef = _firestore
          .collection(pathUsers)
          .doc(habit.creator!.email)
          .collection(pathHabits);
      debugPrint('2\n');
      // final hid = habitCollectionRef.doc().id;
      // debugPrint('2.1\n');
      // habit.hid = hid;
      debugPrint('3\n');
      final habitDocument = (HabitModel.fromEntity(habit)).toDocument();
      debugPrint('4\n');
      // debugPrint(
      //     'HabitDataSourceImpl:addHabit:habitModel type: ${habitModel.runtimeType}');
      // debugPrint('HabitDataSourceImpl:addHabit:habitModel: $habitModel');
      debugPrint('HabitDataSourceImpl:addHabit:habitDocument: $habitDocument');
      debugPrint('5\n');
      await habitCollectionRef.add(habitDocument);
      debugPrint('6\n');

    } on FirebaseException catch (e) {
      debugPrint(
          'HabitDataSourceImpl:addHabit:FirebaseException --type of e: ${e.runtimeType}');
      debugPrint(e.toString());
      throw ServerException(code: e.code, message: e.toString());
    } catch (e) {
      debugPrint('HabitDataSourceImpl:addHabit --type of e: ${e.runtimeType}');
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteHabit(HabitEntity habit) async {
    try {
      final habitCollectionRef = _firestore
          .collection(pathUsers)
          .doc(habit.creator!.email)
          .collection(pathHabits);

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
          .collection(pathUsers)
          .doc(habit.creator!.email)
          .collection(pathHabits);

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
  Future<Stream<List<HabitEntity>>> getHabits(UserEntity creator) async {
    try {
      final habitCollectionRef = _firestore
          .collection('users')
          .doc(creator.email)
          .collection('habits');

      final habits = habitCollectionRef.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return HabitModel.fromDocument(doc.data());
        }).toList();
      });
      return habits;
    } on FirebaseException catch (e) {
      throw ServerException(code: e.code, message: e.message!);
    }
  }
}
