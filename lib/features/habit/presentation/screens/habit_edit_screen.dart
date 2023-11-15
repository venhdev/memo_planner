import 'package:flutter/material.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/constants/typedef.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_instance_entity.dart';
import '../../domain/usecase/get_create_habit_instance_by_iid.dart';
import '../../domain/usecase/get_habit_by_hid.dart';
import '../widgets/widgets.dart';

class EditHabitScreen extends StatefulWidget {
  const EditHabitScreen({
    super.key,
    this.id,
    this.type = EditType.unknown,
  });

  final String? id;
  final EditType type;

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  // init later in initState
  ResultEither<HabitEntity>? hFuture;
  ResultEither<HabitInstanceEntity>? iFuture;

  @override
  void initState() {
    super.initState();
    // do some init stuff
    if (widget.type == EditType.editHabit) {
      // get habit by hid
      hFuture = di<GetHabitByHidUC>()(widget.id!);
    } else if (widget.type == EditType.editInstance) {
      // get instance by iid
      iFuture = di<GetCreateHabitInstanceByIid>()(widget.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.type == EditType.addHabit
            ? const Text('Add Habit')
            : widget.type == EditType.editHabit
                ? const Text('Edit Habit')
                : const Text('Edit Instance'),
      ),
      body: Builder(builder: (context) {
        if (widget.type == EditType.editHabit) {
          return buildByType(
            context,
            hFuture: hFuture,
          );
        } else if (widget.type == EditType.editInstance) {
          return buildByType(
            context,
            iFuture: iFuture,
          );
        } else { // addHabit
          return buildByType(
            context,
          );
        }
      }),
    );
  }

  Widget buildByType(
    BuildContext context, {
    ResultEither<HabitEntity>? hFuture,
    ResultEither<HabitInstanceEntity>? iFuture,
  }) {
    debugPrint('buildForm: type: ${widget.type}');
    return FutureBuilder(
      future: widget.type == EditType.editHabit
          ? hFuture
          : widget.type == EditType.editInstance
              ? iFuture
              : null, // addHabit
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return snapshot.data!.fold(
              (l) {
                return MessageScreen(message: l.toString());
              },
              (r) {
                if (r is HabitEntity) {
                  return HabitForm(type: EditType.editHabit, habit: r);
                } else if (r is HabitInstanceEntity) {
                  return HabitForm(type: EditType.editInstance, instance: r);
                }
                return const MessageScreen(message: 'Unknown Error [e05]');
              },
            );
          } else {
            return MessageScreen(message: snapshot.error.toString());
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.connectionState == ConnectionState.none) {
          return const HabitForm(type: EditType.addHabit);
        }
        return const MessageScreen(message: 'Unknown Error [e06]');
      },
    );
  }
}
