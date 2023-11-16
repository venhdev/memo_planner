import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../authentication/presentation/bloc/bloc/authentication_bloc.dart';
import '../bloc/habit/habit_bloc.dart';
import '../widgets/widgets.dart';

enum FilterOptions { name, time }

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.buildAppBar(
        context: context,
      ),
      drawer: const AppNavigationDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/habit/add');
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return BlocConsumer<HabitBloc, HabitState>(
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
                        const SizedBox(height: 10),
                        Row(
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
                              icon: const Icon(Icons.filter_alt),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        HabitList(
                          focusDate: _focus,
                          habitStream: state.habitStream,
                          currentFilter: currentFilter,
                          query: searchQuery,
                        ),
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
              );
            } else {
              return MessageScreenWithAction(
                message: 'Please sign in to continue',
                buttonText: 'Sign in',
                onPressed: () {
                  context.go('/authentication/sign-in');
                },
              );
            }
          },
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
  return SearchBar(
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
      ]);
}
