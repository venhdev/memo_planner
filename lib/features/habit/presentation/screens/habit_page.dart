import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/features/habit/presentation/bloc/habit/habit_bloc.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../authentication/presentation/bloc/bloc/authentication_bloc.dart';
import '../widgets/widgets.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  DateTime? _focusDate = DateTime.now();
  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.buildAppBar(
        context: context,
        title: 'Habit',
      ),
      drawer: const AppNavigationDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/habit/add');
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return BlocBuilder<HabitBloc, HabitState>(
                builder: (context, state) {
                  if (state is HabitLoaded) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _controller.jumpToDate(DateTime.now());
                              },
                              child: const Text('Today'),
                            ),
                          ],
                        ),
                        EasyInfiniteDateTimeLine(
                          controller: _controller,
                          firstDate: DateTime(2023),
                          focusDate: _focusDate,
                          lastDate: DateTime(2023, 12, 31),
                          onDateChange: (selectedDate) {
                            setState(() {
                              _focusDate = selectedDate;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Your Habits:',
                          style: TextStyle(fontSize: 20),
                        ),
                        HabitList(
                          focusDate: _focusDate,
                          habitStream: state.habitStream,
                        ),
                      ],
                    );
                  } else {
                    return const Text('Something went wrong');
                  }
                },
              );
            } else {
              return Center(
                child: ElevatedButton(
                    onPressed: () {
                      context.go('/authentication');
                    },
                    child: const Text('Login')),
              );
            }
          },
        ),
      ),
    );
  }
}
