import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/core/components/widgets.dart';
import 'package:memo_planner/core/constants/enum.dart';
import 'package:memo_planner/features/task/data/models/task_list_model.dart';
import 'package:memo_planner/features/task/presentation/components/task_group_item.dart';

import '../../domain/entities/task_list_entity.dart';
import '../bloc/task_bloc.dart';
import '../components/dialogs.dart';

// show all list of tasks
class TaskHomeScreen extends StatelessWidget {
  const TaskHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    log('render TaskHomeScreen');
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: _buildAppBar(context),
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
      actions: [
        // IconButton(
        //   onPressed: () {
        //     // onTapFilter(context);
        //   },
        //   icon: const Icon(Icons.sort),
        // ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async => showDialogForAddTaskList(
              context,
              controller: TextEditingController(),
            ),
            // showDialog(
            //   context: context,
            //   builder: (context) => Container(
            //     color: Colors.red,
            //     height: 200,
            //     child: const Center(
            //       child: Text('Add new list'),
            //     ),
            //   ),
            // )
          ),
        ),
      ],
    );
  }

  Widget _build(BuildContext context, List<TaskListEntity> taskLists) {
    return ListView(
      children: [
        // TaskGroupItem.today(),
        // TaskGroupItem.allTasks(),
        // TaskGroupItem.scheduled(),
        // TaskGroupItem.done(),
        Column(
          children: TaskGroupItem.defaultItems(context),
        ),

        const Divider(),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: taskLists.length,
          itemBuilder: (context, index) {
            return TaskGroupItem(
              false,
              taskList: taskLists[index],
              onTap: () {
                context.go('/task-list/single-list/${taskLists[index].lid}');
              },
            );
          },
        ),
      ],
    );
  }
}
