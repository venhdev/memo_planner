// // import 'package:flutter_test/flutter_test.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:memo_planner/features/authentication/domain/entities/user_entity.dart';
// import 'package:memo_planner/features/habit/data/data_sources/habit_data_source.dart';
// import 'package:memo_planner/features/habit/data/models/habit_model.dart';
// import 'package:memo_planner/features/habit/data/repository/habit_repository_impl.dart';
// import 'package:memo_planner/features/habit/domain/usecase/add_habit.dart';

// void main() {
//   // test('should  when ', () async {
//   //   debugPrint(DateTime.now().millisecondsSinceEpoch.toString());
//   // });

//   // test('should  when ', () async {
//   //   const ServerFailure serverFailure1 = ServerFailure();
//   //   const ServerFailure serverFailure2 = ServerFailure();

//   //   debugPrint(serverFailure1.toString());
//   //   debugPrint(serverFailure2.toString());

//   //   expect(serverFailure1, serverFailure2);
//   // });
//   late AddHabitUC addHabitUC;
//   late HabitRepositoryImpl habitRepositoryImpl;

//   setUp(() => {
//         habitRepositoryImpl = HabitRepositoryImpl(
//             HabitDataSourceImpl(FirebaseFirestore.instance)),
//         addHabitUC = AddHabitUC(habitRepositoryImpl),
//       });

//   test('should add new habit', () async {
//     UserEntity creator = const UserEntity(
//       uid: '4E4kMMY6mndL5myvb88N0tRz6oM2',
//       email: 'venh.ha2@gmail.com',
//       displayName: 'venh.ha2',
//       photoURL: null,
//       phoneNumber: null,
//     );

//     final habit = HabitModel(
//       hid: 'hid',
//       summary: 'summary',
//       description: 'description',
//       start: DateTime.now(),
//       end: DateTime.now(),
//       created: DateTime.now(),
//       updated: DateTime.now(),
//       creator: creator,
//       completions: const [],
//     );

//     // final habitRepository = HabitRepositoryImpl(
//     //     RemoteHabitDataSourceImpl(FirebaseFirestore.instance));

//     // final result = await habitRepository.addHabit(habit);
//     final result = await addHabitUC(habit);

//     expect(result, const Right(null));
//   });
// }
