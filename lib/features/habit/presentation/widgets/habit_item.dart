import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/features/habit/domain/entities/habit_instance_entity.dart';
import 'package:memo_planner/features/habit/domain/usecase/usecases.dart';
import 'package:memo_planner/features/habit/presentation/bloc/instance/instance_bloc.dart';

import '../../../../config/dependency_injection.dart';
import '../../data/models/habit_instance_model.dart';
import '../../domain/entities/habit_entity.dart';
import '../bloc/habit/habit_bloc.dart';

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
        if (snapshot.hasError) {
          return const Text('Something went wrong! [e01]');
        } else if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            debugPrint('buildStreamInstance:onLongPress ${habit.created}');
            // instance is not created so use the default habit
            return HabitItemBody(
              isICreated: false,
              focusDate: focusDate,
              habit: habit,
              instance: null,
            );
            // return buildNotCreateInstance(habit, context);
          } else {
            // instance is created
            final instance = HabitInstanceModel.fromDocument(
              snapshot.data!.docs.first.data(),
            );
            return HabitItemBody(
              isICreated: true,
              focusDate: focusDate,
              habit: habit,
              instance: instance,
            );
            // return buildCreatedInstance(instance, context);
          }
        } else {
          return const Text('Some thing went wrong [e02]');
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

  final HabitInstanceEntity? instance;
  final HabitEntity habit;
  final bool isICreated;
  final DateTime focusDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        debugPrint('HabitItemBody:build:onLongPress ${habit.created}');
      },
      onTap: () async {
        context.go('/habit/detail/${habit.hid}');
        // final result = await di<HabitInstanceRepository>().getTopStreaks(habit.hid!);
        // debugPrint('getTopStreaks: $result');
        // onInstanceTap(context, !(isICreated ? instance!.completed! : false));
      },
      child: ListTile(
        title: Text(isICreated ? instance!.summary! : habit.summary!),
        leading: Checkbox(
          value: isICreated ? instance!.completed! : false,
          onChanged: (bool? value) {
            onInstanceTap(context, value);
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            BlocProvider.of<HabitBloc>(context)
                .add(HabitDeleteEvent(habit: habit));
          },
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
}
