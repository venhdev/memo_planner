import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/convertors.dart';
import '../../../authentication/data/data_sources/authentication_data_source.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/streak_instance_entity.dart';
import '../models/habit_instance_model.dart';
import '../models/habit_model.dart';

abstract class HabitDataSource {
  Stream<QuerySnapshot> getHabitStream(UserEntity user);
  Future<void> addHabit(HabitEntity habit);
  Future<void> updateHabit(HabitEntity habit);
  Future<void> deleteHabit(HabitEntity habit);

  Future<HabitEntity?> getHabitByHid(String hid);
  Future<List<StreakInstanceEntity>> getTopStreakOfHabit(HabitEntity habit);
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

  // scenarios:
  // 1. the first day of the list is completed [1,0...]
  // 2. the middle day of the list is completed [...0,1,0...]
  // 3. the last day of the list is completed [...0,1]
  @override
  Future<List<StreakInstanceEntity>> getTopStreakOfHabit(HabitEntity habit) async {
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

    List<StreakInstanceEntity> result = [];
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
        // the streak is broken
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

      if (isLastInstance && currentStreakLength > 0) {
        final StreakInstanceEntity streak = StreakInstanceEntity(
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
