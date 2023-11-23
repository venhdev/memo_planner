import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../bloc/habit/habit_bloc.dart';
import '../widgets/widgets.dart';

enum FilterOptions { name, time }

enum Routine { morning, afternoon, evening }

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  DateTime _focus = getDate(DateTime.now());
  final EasyInfiniteDateTimelineController _controller = EasyInfiniteDateTimelineController();
  final TextEditingController _searchController = TextEditingController();

  String searchQuery = '';
  FilterOptions currentFilter = FilterOptions.time;
  Routine? currentRoutine;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          return Scaffold(
            appBar: MyAppBar.habitAppBar(
              context: context,
            ),
            drawer: const AppNavigationDrawer(),
            floatingActionButton: FloatingActionButton(
              heroTag: 'fab_habit',
              onPressed: () {
                context.go('/habit/add');
              },
              child: const Icon(Icons.add),
            ),
            body: BlocConsumer<HabitBloc, HabitState>(
              listener: (context, state) {
                if (state is HabitLoaded) {
                  if (state.message != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              builder: (context, state) {
                if (state is HabitLoaded) {
                  return Column(
                    children: [
                      const SizedBox(height: 12.0),
                      habitSearchBar(
                        context,
                        controller: _searchController,
                        onChange: () {
                          setState(() {
                            searchQuery = _searchController.text;
                          });
                        },
                        onCancel: () {
                          setState(() {
                            _searchController.clear();
                            searchQuery = '';
                            FocusScope.of(context).unfocus();
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      EasyInfiniteDateTimeLine(
                        controller: _controller,
                        activeColor: Colors.green.shade300,
                        dayProps: const EasyDayProps(
                          activeDayStyle: DayStyle(
                            borderRadius: 28,
                          ),
                          borderColor: Colors.black12,
                          todayHighlightColor: Colors.green,
                        ),
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2026),
                        focusDate: _focus,
                        onDateChange: (selectedDate) {
                          setState(() {
                            _focus = selectedDate;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                final current = DateTime.now();
                                _focus = DateTime(
                                  current.year,
                                  current.month,
                                  current.day,
                                );
                                setState(() {
                                  _controller.animateToDate(
                                    _focus,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.decelerate,
                                  );
                                });
                              },
                              child: const Icon(Icons.today),
                            ),
                            IconButton(
                              onPressed: () {
                                onTapFilter(context);
                              },
                              icon: const Icon(Icons.sort),
                            ),
                          ],
                        ),
                      ),
                      // routine (morning, afternoon, evening) using chip
                      const SizedBox(height: 8),
                      buildRoutinePicker(),
                      const SizedBox(height: 16),
                  
                      HabitList(
                        focusDate: _focus,
                        habitStream: state.habitStream,
                        currentFilter: currentFilter,
                        currentRoutine: currentRoutine,
                        query: searchQuery,
                      ),
                      
                      SizedBox(height: MediaQuery.of(context).padding.bottom),
                    ],
                  );
                } else if (state is HabitLoading) {
                  return const LoadingScreen();
                } else if (state is HabitInitial) {
                  return const LoadingScreen();
                } else if (state is HabitError) {
                  return MessageScreen(message: state.message);
                } else {
                  return const MessageScreen(message: 'Something went wrong [e04]');
                }
              },
            ),
          );
        } else {
          return MessageScreenWithAction.unauthenticated(() {context.go('/authentication');});
        }
      },
    );
  }

  Widget buildRoutinePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 10),
            ActionChip(
              backgroundColor: currentRoutine == Routine.morning ? Colors.cyan[200] : null,
              avatar: const Icon(Icons.sunny_snowing),
              label: const Text('Morning'),
              onPressed: () {
                setState(() {
                  currentRoutine == Routine.morning ? currentRoutine = null : currentRoutine = Routine.morning;
                });
              },
            ),
            const SizedBox(width: 10),
            ActionChip(
              backgroundColor: currentRoutine == Routine.afternoon ? Colors.yellow[300] : null,
              avatar: const Icon(Icons.sunny),
              label: const Text('Afternoon'),
              onPressed: () {
                setState(() {
                  currentRoutine == Routine.afternoon ? currentRoutine = null : currentRoutine = Routine.afternoon;
                });
              },
            ),
            const SizedBox(width: 10),
            ActionChip(
              backgroundColor: currentRoutine == Routine.evening ? Colors.purple[200] : null,
              avatar: const Icon(Icons.bedtime),
              label: const Text('Evening'),
              onPressed: () {
                setState(() {
                  currentRoutine == Routine.evening ? currentRoutine = null : currentRoutine = Routine.evening;
                });
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Future<dynamic> onTapFilter(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sort by'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Habit name'),
                trailing: const Icon(Icons.note),
                leading: Radio(
                  value: FilterOptions.name,
                  groupValue: currentFilter,
                  onChanged: (value) {
                    setState(() {
                      currentFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Start time'),
                trailing: const Icon(Icons.schedule),
                leading: Radio(
                  value: FilterOptions.time,
                  groupValue: currentFilter,
                  onChanged: (value) {
                    setState(() {
                      currentFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget habitSearchBar(
  BuildContext context, {
  required TextEditingController controller,
  required Function onChange,
  required Function onCancel,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: SearchBar(
        elevation: MaterialStateProperty.all<double>(2.0),
        controller: controller,
        padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
        onTap: () {},
        onChanged: (_) {
          onChange();
        },
        leading: const Icon(Icons.search),
        trailing: [
          Visibility(
            visible: controller.text.isNotEmpty,
            child: IconButton(
              onPressed: () {
                onCancel();
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ]),
  );
}
