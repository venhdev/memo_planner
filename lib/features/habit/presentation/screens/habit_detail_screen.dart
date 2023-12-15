// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:memo_planner/features/habit/data/models/habit_model.dart';
// import 'package:memo_planner/features/habit/domain/entities/habit_entity.dart';
// import 'package:memo_planner/features/habit/domain/repository/habit_repository.dart';

// import '../../../../config/dependency_injection.dart';
// import '../../../../core/widgets/widgets.dart';
// import '../../domain/entities/streak_entity.dart';
// import '../../domain/usecase/get_top_streak.dart';
// import '../components/detail/detail_screen_components.dart';

// class HabitDetailScreen extends StatefulWidget {
//   const HabitDetailScreen({
//     super.key,
//     required this.hid,
//   });

//   final String hid;

//   @override
//   State<HabitDetailScreen> createState() => _HabitDetailScreenState();
// }

// class _HabitDetailScreenState extends State<HabitDetailScreen> {
//   final _emailController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     debugPrint('HabitDetailScreen: build');
//     return FutureBuilder(
//       future: di<GetTopStreakUC>()(widget.hid),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasData) {
//             return snapshot.data!.fold(
//               (failure) => MessageScreen(message: failure.message),
//               (streak) => _build(streak),
//             );
//           } else if (snapshot.hasError) {
//             return MessageScreen(message: snapshot.error.toString());
//           } else {
//             return const MessageScreen(message: 'Some thing went wrong [e03]');
//           }
//         } else {
//           return const LoadingScreen();
//         }
//       },
//     );
//   }

//   Widget _build(StreakEntity streak) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           // add member button
//           IconButton(
//               onPressed: () async {
//                 await openMemberModal(context, streak.habit);
//               },
//               icon: const Icon(Icons.person_add)),

//           IconButton(
//             icon: const Icon(Icons.refresh),
//             tooltip: 'Refresh',
//             onPressed: () {
//               setState(() {});
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   '${streak.habit.summary}',
//                   style: const TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Roboto',
//                   ),
//                 ),
//                 IconButton(onPressed: () => context.go('/habit/edit-habit/${streak.habit.hid}'), icon: const Icon(Icons.edit)),
//               ],
//             ),
//             const SizedBox(height: 24),
//             _buildTopStreak(streak),
//           ],
//         ),
//       ),
//     );
//   }

//   Builder _buildTopStreak(StreakEntity streak) {
//     return Builder(builder: (context) {
//       if (streak.streaks.isNotEmpty) {
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CalendarStreak(dateRange: streak.getDateRange),
//             const SizedBox(height: 24),
//             const Text(
//               'Top Streak',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Roboto',
//               ),
//             ),
//             BestStreak(streaks: streak.streaks),
//           ],
//         );
//       } else {
//         return const MessageScreen(message: 'No Data');
//       }
//     });
//   }

//   Future<void> openMemberModal(BuildContext context, HabitEntity h) {
//     return showModalBottomSheet<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return StreamBuilder(
//             stream: di<HabitRepository>().getOneHabitStream(h),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.active) {
//                 if (snapshot.hasData) {
//                   final habit = HabitModel.fromDocument(snapshot.data!.data()!);
//                   return SizedBox(
//                     height: 250,
//                     child: Center(
//                       child: Column(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               mainAxisSize: MainAxisSize.max,
//                               children: [
//                                 const Text('List Members', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     showMyDialogToAddMember(
//                                       context,
//                                       controller: _emailController,
//                                       onConfirm: () async {
//                                         // NOTE: need refactor
//                                         try {
//                                           // di<AuthenticationRepository>().getUserByEmail(_emailController.text).then((value) {
//                                           //   if (value != null) {
//                                           //     di<FirebaseFirestore>().collection('habits').doc(h.hid).update({
//                                           //       'members': FieldValue.arrayUnion([UserModel.fromEntity(value).toDocument()]),
//                                           //     }).then((value) => {debugPrint('Add Member Success')});
//                                           //   }
//                                           // });

//                                           di<FirebaseFirestore>().collection('habits').doc(h.hid).update({
//                                             'members': FieldValue.arrayUnion([_emailController.text.trim()])
//                                           }).then((value) => log('Add Member Success'));

//                                         } catch (e) {
//                                           log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
//                                         }
//                                       },
//                                     );
//                                   },
//                                   child: const Text('Add Member'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // habit.members != null
//                           //     ? Expanded(
//                           //         child: ListView.builder(
//                           //           itemCount: habit.members?.length,
//                           //           itemBuilder: (BuildContext context, int index) {
//                           //             return MemberItem(habit.members?[index]);
//                           //           },
//                           //         ),
//                           //       )
//                           //     : const Text('No Member'),
//                         ],
//                       ),
//                     ),
//                   );
//                 } else if (snapshot.hasError) {
//                   return MessageScreen(message: snapshot.error.toString());
//                 } else {
//                   return const MessageScreen(message: 'Some thing went wrong [e02]');
//                 }
//               } else if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const LoadingScreen();
//               } else if (snapshot.hasError) {
//                 return MessageScreen(message: snapshot.error.toString());
//               } else {
//                 return const MessageScreen(message: 'Some thing went wrong [e01]');
//               }
//             });
//       },
//     );
//   }
// }
