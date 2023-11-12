import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/core/utils/convertors.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/habit_instance_model.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_instance_entity.dart';
import '../../domain/usecase/get_habit_instances.dart';
import '../bloc/habit/habit_bloc.dart';
import '../bloc/instance/instance_bloc.dart';

class HabitItem extends StatelessWidget {
  const HabitItem({super.key, required this.habit, required this.focusDate});

  // stream of habit instances
  final HabitEntity habit;
  final DateTime focusDate;

  @override
  Widget build(BuildContext context) {
    debugPrint('HabitItem:build ${habit.created}');
    // add event to bloc when focus date change
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: buildStreamInstance(
        stream: di<GetHabitInstanceStreamUC>()(
          GetHabitInstanceParams(
            habit: habit,
            focusDate: focusDate,
          ),
        ),
        habit: habit,
        context: context,
      ),
    );
  }

  Widget buildStreamInstance({
    required Stream<QuerySnapshot<Map<String, dynamic>>> stream,
    required HabitEntity habit,
    required BuildContext context,
  }) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            // instance is not created so use the habit info to display
            return HabitItemBody(
              isICreated: false,
              focusDate: focusDate,
              habit: habit,
              instance: null,
            );
          } else {
            // instance is created
            return HabitItemBody(
              isICreated: true,
              focusDate: focusDate,
              habit: habit,
              instance: HabitInstanceModel.fromDocument(
                snapshot.data!.docs.first.data(),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return MessageScreen(message: snapshot.error.toString());
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}

class HabitItemBody extends StatelessWidget {
  const HabitItemBody({
    super.key,
    required this.isICreated,
    this.instance,
    required this.habit,
    required this.focusDate,
  });

  final HabitEntity habit;
  final DateTime focusDate;
  final bool isICreated; // is Instance created
  final HabitInstanceEntity? instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        debugPrint('HabitItemBody:build:onLongPress ${habit.created}');
      },
      onTap: () {
        context.go('/habit/detail/${habit.hid}');
      },
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (context) {
                showConfirmDeleteDialog(context: context);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
              onPressed: (context) {
                showEditTypeDialog(context: context);
                // isICreated
                //     ? context.go('/habit/edit-instance/${instance!.iid}')
                //     : context.go('/habit/edit-habit/${habit.hid}');
              },
              backgroundColor: Colors.cyan,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        child: ListTile(
          title: Text(isICreated ? instance!.summary! : habit.summary!),
          leading: Checkbox(
            value: isICreated ? instance!.completed! : false,
            onChanged: (bool? value) {
              onInstanceTap(context, value);
            },
          ),
        ),
      ),
    );
  }

  void onInstanceTap(BuildContext context, bool? value) {
    if (isICreated) {
      // Change the instance's status of completed
      BlocProvider.of<HabitInstanceBloc>(context).add(
        InstanceStatusChangeEvent(
          instance: instance!,
          completed: value!,
        ),
      );
    } else {
      // This will be create new instance with completed = true
      BlocProvider.of<HabitInstanceBloc>(context).add(
        InstanceInitialEvent(habit: habit, date: focusDate),
      );
    }
  }

  void showConfirmDeleteDialog({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Habit'),
          content: Text(
            'Are you sure to permanently delete ${habit.summary} habit?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                BlocProvider.of<HabitBloc>(context)
                    .add(HabitDeleteEvent(habit: habit));
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void showEditTypeDialog({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Type'),
          content: const Text(
            'You want to edit to all habit or just this one?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.go('/habit/edit-habit/${habit.hid}');
                Navigator.pop(context);
                // isICreated
                //     ? context.go('/habit/edit-instance/${instance!.iid}')
                //     : context.go('/habit/edit-habit/${habit.hid}');
              },
              child: const Text('All'),
            ),
            TextButton(
              onPressed: () async {
                if (isICreated) {
                  context.go('/habit/edit-instance/${instance!.iid}');
                } else {
                  // the instance is not created yet
                  // create new instance with completed = false
                  BlocProvider.of<HabitInstanceBloc>(context).add(
                    InstanceInitialEvent(
                      habit: habit,
                      date: focusDate,
                      completed: false,
                    ),
                  );

                  // and then go to edit instance screen
                  final iid = getIid(habit.hid!, focusDate);
                  context.go('/habit/edit-instance/$iid');
                }

                Navigator.pop(context);
              },
              child: const Text('Just this one'),
            ),
          ],
        );
      },
    );
  }
}
