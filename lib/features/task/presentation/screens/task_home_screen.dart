import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_navigation_drawer.dart';
import '../../../../core/components/avatar.dart';
import '../../../../core/components/common_screen.dart';
import '../../../../core/constants/enum.dart';
import '../../../../core/utils/helpers.dart';
import '../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../../data/models/task_list_model.dart';
import '../../domain/entities/task_list_entity.dart';
import '../bloc/task_bloc.dart';
import '../components/add_or_edit_task_list_dialog.dart';
import '../components/task_list_item.dart';

class TaskHomeScreen extends StatelessWidget {
  const TaskHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    log('render TaskHomeScreen');
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: const AppNavigationDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.status == BlocStatus.loaded) {
            return StreamBuilder(
              stream: state.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    final docs = snapshot.data!.docs;
                    final taskLists = docs.map((doc) => TaskListModel.fromMap(doc.data())).toList();
                    return _build(context, taskLists);
                  } else if (snapshot.hasError) {
                    return MessageScreen.error(snapshot.error.toString());
                  } else {
                    return MessageScreen.error();
                  }
                } else {
                  return const LoadingScreen();
                }
              },
            );
          } else if (state.status == BlocStatus.error) {
            return MessageScreen.error(state.message);
          } else if (state.status == BlocStatus.loading) {
            return const LoadingScreen();
          } else {
            return MessageScreen.error('Something went wrong [TaskBloc]');
          }
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        convertDateTimeToString(getToday(), pattern: 'EEEE, dd-MM'),
        style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
      ),
      // open drawer when user click on avatar
      leading: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Avatar(
          photoURL: (context.read<AuthBloc>().state.user?.photoURL),
          placeHolder: (context.read<AuthBloc>().state.user?.email!),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14.0),
          child: TextButton.icon(
            label: const Text('Create', style: TextStyle(fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.add),
            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primaryContainer)),
            onPressed: () => _showDialogForAddTaskList(context),
          ),
        ),
      ],
    );
  }

  Future<dynamic> _showDialogForAddTaskList(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AddOrEditTaskListDialog(controller: TextEditingController()),
    );
  }

  Widget _build(BuildContext context, List<TaskListEntity> taskLists) {
    return ListView(
      children: [
        Column(
          children: [
            TaskListItem.myday(context),
            TaskListItem.allTasks(context),
            TaskListItem.today(context),
            TaskListItem.scheduled(context),
            TaskListItem.done(context),
            TaskListItem.assignToMe(context),
          ],
        ),
        const Divider(),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: taskLists.length,
          itemBuilder: (context, index) {
            return TaskListItem(
              false,
              taskList: taskLists[index],
              onTap: () {
                context.go('/single-list/${taskLists[index].lid}');
              },
            );
          },
        ),
      ],
    );
  }
}
