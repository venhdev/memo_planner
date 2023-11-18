import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/typedef.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/habit_instance_model.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_instance_entity.dart';
import '../../domain/usecase/get_habit_instance_stream.dart';
import '../bloc/habit/habit_bloc.dart';
import '../bloc/instance/instance_bloc.dart';

class HabitItem extends StatelessWidget {
  const HabitItem({super.key, required this.habit, required this.focusDate});

  // stream of habit instances
  final HabitEntity habit;
  final DateTime focusDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.green[50]!,
          ),
        ],
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
    required SQuerySnapshot stream,
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
  final bool isICreated; // is Instance created or not
  final HabitInstanceEntity? instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // context.go('/habit/detail/${habit.hid}');
        var value = isICreated ? instance!.completed! : false;
        handleStatusChanged(context, !value);
      },
      onLongPress: () {
        context.go('/habit/detail/${habit.hid}');
        // showChooseEditTypeDialog(context: context);
      },
      child: Slidable(
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.2,
          children: [
            // Edit action
            SlidableAction(
              borderRadius: BorderRadius.circular(12.0),
              onPressed: (context) {
                showChooseEditTypeDialog(context: context);
              },
              backgroundColor: Colors.cyan,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              // label: 'Edit',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.2,
          children: [
            // Delete action
            SlidableAction(
              borderRadius: BorderRadius.circular(12.0),
              onPressed: (context) {
                showConfirmDeleteDialog(context: context);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
            ),
          ],
        ),
        child: Builder(builder: (context) {
          final String summary;
          final String startTime;
          final String endTime;
          if (isICreated) {
            if (instance!.edited!) {
              summary = instance!.summary!;
              startTime = convertDateTimeToString(instance!.start!, pattern: kTimeFormatPattern);
              endTime = convertDateTimeToString(instance!.end!, pattern: kTimeFormatPattern);
            } else {
              summary = habit.summary!;
              startTime = convertDateTimeToString(habit.start!, pattern: kTimeFormatPattern);
              endTime = convertDateTimeToString(habit.end!, pattern: kTimeFormatPattern);
            }
          } else {
            summary = habit.summary!;
            startTime = convertDateTimeToString(habit.start!, pattern: kTimeFormatPattern);
            endTime = convertDateTimeToString(habit.end!, pattern: kTimeFormatPattern);
          }
          return ListTile(
            title: Text(
              summary,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              '$startTime - $endTime',
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            leading: Builder(builder: (context) {
              var canCheck = false;
              if (habit.created!.isBefore(focusDate) && habit.end!.isAfter(focusDate)) {
                canCheck = true;
              }
              return IgnorePointer(
                ignoring: canCheck,
                child: Checkbox(
                  value: isICreated ? instance!.completed! : false,
                  onChanged: (bool? value) {
                    handleStatusChanged(context, value);
                  },
                ),
              );
            }),
            trailing: TouchableIcon(
              onTap: () {
                context.go('/habit/detail/${habit.hid}');
              },
              color: Colors.green[100],
            ),
          );
        }),
      ),
    );
  }

  void handleStatusChanged(BuildContext context, bool? value) {
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
        InstanceInitialEvent(
          habit: habit,
          date: focusDate,
          completed: value!,
        ),
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
                BlocProvider.of<HabitBloc>(context).add(HabitDeleteEvent(habit: habit));
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

  void showChooseEditTypeDialog({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Type'),
          content: const Text(
            'You want to edit for all habit or just apply for this one?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.go('/habit/edit-habit/${habit.hid}');
                Navigator.pop(context);
              },
              child: const Text('All'),
            ),
            TextButton(
              onPressed: () async {
                if (isICreated) {
                  context.go('/habit/edit-instance/${instance!.iid}');
                } else {
                  final iid = getIid(habit.hid!, focusDate);
                  context.go('/habit/edit-instance/$iid');
                }

                Navigator.pop(context);
              },
              child: const Text('This one'),
            ),
          ],
        );
      },
    );
  }
}

class TouchableIcon extends StatelessWidget {
  const TouchableIcon({
    super.key,
    this.onTap,
    this.height = 48.0,
    this.width = 48.0,
    this.color = Colors.black12,
  });

  final Function? onTap;
  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap!();
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: const Icon(Icons.bar_chart),
      ),
    );
  }
}
