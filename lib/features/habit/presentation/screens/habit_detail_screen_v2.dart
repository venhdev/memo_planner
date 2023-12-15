import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:memo_planner/features/habit/data/data_sources/habit_data_source.dart';
import 'package:memo_planner/features/habit/data/models/habit_model.dart';
import 'package:memo_planner/features/habit/domain/entities/habit_entity.dart';
import 'package:memo_planner/features/habit/domain/repository/habit_repository.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/widgets.dart';
import '../../domain/entities/streak_entity.dart';
import '../../domain/usecase/get_top_streak.dart';
import '../components/detail/detail_screen_components.dart';

class HabitDetailScreenV2 extends StatefulWidget {
  const HabitDetailScreenV2({
    super.key,
    required this.habit,
  });

  final HabitEntity habit;

  @override
  State<HabitDetailScreenV2> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreenV2> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // add member button
          IconButton(
              onPressed: () async {
                await openMemberModal(context, widget.habit.hid!);
              },
              icon: const Icon(Icons.person_add)),
          // refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: di<HabitRepository>().getOneHabitStream(widget.habit.hid!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
            final data = snapshot.data!.data();
            if (data == null) {
              return const MessageScreen(message: 'No Data');
            }
            final habit = HabitModel.fromDocument(data);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // habit info

                    //name
                    Text(
                      '${habit.summary}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),

                    // IconButton(onPressed: () => context.go('/habit/edit-habit/${habit.hid}'), icon: const Icon(Icons.edit)),
                  ],
                ),
                const SizedBox(height: 24),
                // List of top streak for each member
                Builder(builder: (context) {
                  if (habit.members == null || habit.members!.isEmpty) {
                    return const MessageScreen(message: 'No Member');
                  }
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: habit.members?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FutureBuilder(
                          future: di<GetTopStreakUC>()(GetTopStreakParams(habit.hid!, habit.members![index])),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasData) {
                                return snapshot.data!.fold(
                                  (failure) => MessageScreen.error(failure.message),
                                  (streak) => _buildMemberStreakItem(streak, habit.members![index]),
                                );
                              } else if (snapshot.hasError) {
                                return MessageScreen.error(snapshot.error.toString());
                              } else {
                                log('some thing went wrong [e03]');
                                return const LoadingScreen();
                              }
                            } else {
                              return const LoadingScreen();
                            }
                          },
                        );
                      },
                    ),
                  );
                }),
                // _buildTopStreak(habit),
              ],
            );
          } else if (snapshot.hasError) {
            return MessageScreen.error(snapshot.error.toString());
          } else {
            return const LoadingScreen();
          }
        },
      ),
    );
  }

  Widget _buildMemberStreakItem(StreakEntity streak, String email) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Builder(builder: (context) {
        if (streak.streaks.isNotEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                email,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              CalendarStreak(dateRange: streak.getDateRange),
              const SizedBox(height: 24),
              const Text(
                'Top Streak',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              BestStreak(streaks: streak.streaks),
            ],
          );
        } else {
          return Center(
            child: Text(
              '$email has no streak',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          );
        }
      }),
    );
  }

  Future<void> openMemberModal(BuildContext context, String hid) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder(
          stream: di<HabitRepository>().getOneHabitStream(hid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
              final habit = HabitModel.fromDocument(snapshot.data!.data()!);
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text('List Members', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                            ElevatedButton(
                              onPressed: () {
                                showMyDialogToAddMember(
                                  context,
                                  controller: _emailController,
                                  onConfirm: () async {
                                    // NOTE: need refactor
                                    di<HabitDataSource>().addMember(habit.hid!, _emailController.text.trim());
                                  },
                                );
                              },
                              child: const Text('Add Member'),
                            ),
                          ],
                        ),
                      ),
                      if (habit.members != null)
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: habit.members?.length,
                            itemBuilder: (BuildContext context, int index) {

                              return MemberItem(
                                hid: habit.hid!,
                                memberEmail: habit.members![index],
                                ownerEmail: habit.creator!.email!,
                              );
                            },
                          ),
                        )
                      else
                        const Text('No Member'),
                    ],
                  ),
                ),
              );
            } else {
              return const LoadingScreen();
            }
          },
        );
      },
    );
  }
}
  // Widget buildOld(BuildContext context) {
  //   debugPrint('HabitDetailScreen: build');
  //   return FutureBuilder(
  //     future: di<GetTopStreakUC>()(GetTopStreakParams(widget.habit.hid!, 'abc')),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         if (snapshot.hasData) {
  //           return snapshot.data!.fold(
  //             (failure) => MessageScreen(message: failure.message),
  //             (streak) => _build(streak),
  //           );
  //         } else if (snapshot.hasError) {
  //           return MessageScreen(message: snapshot.error.toString());
  //         } else {
  //           return const MessageScreen(message: 'Some thing went wrong [e03]');
  //         }
  //       } else {
  //         return const LoadingScreen();
  //       }
  //     },
  //   );
  // }

  // Widget _build(StreakEntity streak) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       actions: [
  //         // add member button
  //         IconButton(
  //             onPressed: () async {
  //               await openMemberModal(context, streak.habit);
  //             },
  //             icon: const Icon(Icons.person_add)),

  //         IconButton(
  //           icon: const Icon(Icons.refresh),
  //           tooltip: 'Refresh',
  //           onPressed: () {
  //             setState(() {});
  //           },
  //         ),
  //       ],
  //     ),
  //     body: SingleChildScrollView(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 '${streak.habit.summary}',
  //                 style: const TextStyle(
  //                   fontSize: 32,
  //                   fontWeight: FontWeight.bold,
  //                   fontFamily: 'Roboto',
  //                 ),
  //               ),
  //               IconButton(onPressed: () => context.go('/habit/edit-habit/${streak.habit.hid}'), icon: const Icon(Icons.edit)),
  //             ],
  //           ),
  //           const SizedBox(height: 24),
  //           _buildMemberStreakItem(streak),
  //         ],
  //       ),
  //     ),
  //   );
  // }

