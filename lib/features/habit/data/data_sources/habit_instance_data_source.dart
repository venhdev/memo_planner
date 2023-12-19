import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/features/authentication/data/models/user_model.dart';
import '../../../../core/utils/helpers.dart';
import '../../../authentication/data/data_sources/authentication_data_source.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/constants/typedef.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_instance_entity.dart';
import '../models/habit_instance_model.dart';

abstract class HabitInstanceDataSource {
  SQuerySnapshot getHabitInstanceStream(HabitEntity habit, DateTime focusDate);

  Future<HabitInstanceEntity?> findHabitInstanceById(String iid);

  Future<HabitInstanceEntity> initNewHabitInstance(
    HabitEntity habit,
    DateTime date,
    bool completed,
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
  Future<HabitInstanceEntity> initNewHabitInstance(
    HabitEntity habit,
    DateTime date,
    bool completed,
  ) async {
    // date is the focusDate pass from ui
    try {
      final currentUser = _authenticationDataSource.currentUser!;
      final habitICollRef = _firestore
          // .collection(pathToUsers)
          // .doc(habit.creator!.email)
          .collection(pathToHabits)
          .doc(habit.hid)
          .collection(currentUser.email!);

      // create instance id with format: hid_yyyyMMdd
      final iid = '${habit.hid}_${convertDateTimeToyyyyMMdd(date)}';

      // * already handle in ui
      // // remove the time part * because the first run app will have time part
      // // if (date.microsecond != 0) {
      // //   date = DateTime(date.year, date.month, date.day);
      // // }

      // the [habit] like parent of the [habit instance]
      // habit.start/end : hold the start/end time (hour, minute) of the habit
      // -> change the day, month, year of the habit.start/end to focusDate

      HabitInstanceModel habitInstanceModel = HabitInstanceModel(
        iid: iid,
        hid: habit.hid,
        summary: habit.summary,
        description: habit.description,
        start: habit.start!.copyWith(day: date.day, month: date.month, year: date.year), // same at focusDate
        end: habit.end!.copyWith(day: date.day, month: date.month, year: date.year), // same at focusDate
        date: date,
        updated: DateTime.now(),
        creator: UserModel.fromUserCredential(currentUser),
        completed: completed,
        edited: false, // because this is new habit instance -- not edited yet
      );

      await habitICollRef.doc(iid).set(habitInstanceModel.toDocument());

      return habitInstanceModel;
    } on FirebaseException catch (e) {
      throw ServerException(code: e.code, message: e.toString());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  SQuerySnapshot getHabitInstanceStream(HabitEntity habit, DateTime focusDate) {
    final currentUser = _authenticationDataSource.currentUser!;
    final habitICollRef = _firestore
        // .collection(pathToUsers)
        // .doc(habit.creator!.email)
        .collection(pathToHabits)
        .doc(habit.hid)
        .collection(currentUser.email!);

    final iid = getIid(habit.hid!, focusDate);
    return habitICollRef.where('iid', isEqualTo: iid).snapshots();
  }

  @override
  Future<void> changeHabitInstanceStatus(HabitInstanceEntity instance, bool completed) async {
    final habitIDocRef = _firestore
        // .collection(pathToUsers)
        // .doc(instance.creator!.email)
        .collection(pathToHabits)
        .doc(instance.hid)
        .collection(instance.creator!.email!)
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
          // .collection(pathToUsers)
          // .doc(user.email)
          .collection(pathToHabits)
          .doc(iid.split('_').first)
          .collection(user.email!)
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
        // .collection(pathToUsers)
        // .doc(instance.creator!.email)
        .collection(pathToHabits)
        .doc(instance.hid)
        .collection(instance.creator!.email!)
        .doc(instance.iid);

    habitIDocRef.update({
      'summary': instance.summary,
      'description': instance.description,
      'start': instance.start,
      'end': instance.end,
      'edited': instance.edited, // update the edited field
      'updated': DateTime.now(), // update the updated field
    });
  }
}
