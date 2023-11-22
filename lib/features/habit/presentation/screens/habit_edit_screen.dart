import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/features/authentication/domain/entities/user_entity.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/constants/enum.dart';
import '../../../../core/constants/typedef.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';
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
    if (widget.type == EditType.edit) {
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
        title: widget.type == EditType.add
            ? const Text('Add Habit')
            : widget.type == EditType.edit
                ? const Text('Edit Habit')
                : const Text('Edit Instance'),
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            if (widget.type == EditType.edit) {
              return _build(
                context,
                hFuture: hFuture,
                user: state.user!,
              );
            } else if (widget.type == EditType.editInstance) {
              return _build(
                context,
                iFuture: iFuture,
                user: state.user!,
              );
            } else {
              // addHabit
              return _build(
                context,
                user: state.user!,
              );
            }
          } else {
            return MessageScreenWithAction.unauthenticated(() {
              context.go('/authentication');
            });
          }
        },
      ),
    );
  }

  Widget _build(
    BuildContext context, {
    ResultEither<HabitEntity>? hFuture,
    ResultEither<HabitInstanceEntity>? iFuture,
    required UserEntity user,
  }) {
    debugPrint('buildForm: type: ${widget.type}');
    return FutureBuilder(
      future: widget.type == EditType.edit
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
                  return HabitForm(type: EditType.edit, habit: r, user: user);
                } else if (r is HabitInstanceEntity) {
                  return HabitForm(type: EditType.editInstance, instance: r, user: user);
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
          return HabitForm(type: EditType.add, user: user);
        }
        return const MessageScreen(message: 'Unknown Error [e06]');
      },
    );
  }
}
