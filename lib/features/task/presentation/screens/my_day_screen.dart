import 'package:flutter/material.dart';
import '../../../../core/utils/helpers.dart';
import '../../data/models/myday_model.dart';
import '../../domain/repository/task_repository.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/widgets.dart';
import '../../data/models/task_model.dart';
import '../components/task_item.dart';

/// Show only the tasks of a single list
class MyDayScreen extends StatelessWidget {
  const MyDayScreen({super.key, required this.currentUserEmail});

  final String currentUserEmail;

  //stream builder + type => filter
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: di<TaskRepository>().getAllMyDayStream(currentUserEmail, getToday()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final maps = snapshot.data?.docs.map((e) => e.data()).toList();
            if (maps == null) return const MessageScreen(message: 'No data');
            if (maps.isEmpty) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('My Day'),
                ),
                body: const MessageScreen(message: 'Add some tasks to My Day', enableBack: false),
              );
            }
            final myDays = maps.map((e) => MyDayModel.fromMap(e)).toList();
            return Scaffold(
              appBar: AppBar(
                title: const Text('My Day'),
              ),
              body: _build(myDays),
            );
          } else if (snapshot.hasError) {
            return MessageScreen(message: snapshot.error.toString());
          } else {
            return const LoadingScreen();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.connectionState == ConnectionState.none) {
          return const MessageScreen(message: 'No data');
        } else {
          return const MessageScreen(message: 'Error [MyDayScreen]');
        }
      },
    );
  }

  Widget _build(List<MyDayModel> myDays) => ListView.builder(
        itemCount: myDays.length,
        itemBuilder: (context, index) => StreamBuilder(
          stream: di<TaskRepository>().getOneTaskStream(myDays[index].lid, myDays[index].tid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final map = snapshot.data?.data();
              if (map == null) return const SizedBox.shrink();
              return TaskItem(
                task: TaskModel.fromMap(map),
                showListName: true,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      );
}
