import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_planner/features/habit/domain/usecase/usecases.dart';
import 'package:memo_planner/features/habit/presentation/bloc/instance/instance_bloc.dart';

import '../../../../config/dependency_injection.dart';
import '../../data/models/habit_instance_model.dart';
import '../../domain/entities/habit_entity.dart';

class HabitItem extends StatelessWidget {
  const HabitItem({super.key, required this.habit, required this.focusDate});

  // stream of habit instances
  final HabitEntity habit;
  final DateTime focusDate;

  @override
  Widget build(BuildContext context) {
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
          return const Text('Something went wrong hasError');
        } else if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return buildNotCreateInstance(habit, context);
          } else {
            final instance = HabitInstanceModel.fromDocument(
              snapshot.data!.docs.first.data(),
            );
            return buildCreatedInstance(instance, context);
          }
        } else {
          return const Text('Some thing went wrong [ui02]');
        }
      },
    );
  }

  Widget buildNotCreateInstance(HabitEntity habit, BuildContext context) =>
      GestureDetector(
        onLongPress: () {
          debugPrint('buildNotCreateInstance');
        },
        child: Column(
          children: [
            ListTile(
              title: Text(habit.summary ?? 'NO TITLE'),
              leading: Checkbox(
                value: false,
                onChanged: (bool? value) {
                  if (value == true) {
                    BlocProvider.of<HabitInstanceBloc>(context).add(
                      InstanceInitialEvent(
                        habit: habit,
                        date: focusDate,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );

  Widget buildCreatedInstance(
      HabitInstanceModel instance, BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        debugPrint('buildCreatedInstance');
      },
      child: Column(
        children: [
          ListTile(
            title: Text(instance.summary ?? 'NO TITLE'),
            leading: Checkbox(
              value: instance.status ?? false,
              onChanged: (bool? value) {
                debugPrint('change status $value');
                BlocProvider.of<HabitInstanceBloc>(context).add(
                  InstanceStatusChangeEvent(instance: instance, status: value!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
