import 'dart:developer';

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/components/widgets.dart';
import '../../../../core/utils/helpers.dart';
import '../bloc/habit/habit_bloc.dart';
import '../components/habit_components.dart';

enum FilterOptions { name, time }

enum Routine { morning, afternoon, evening }

class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
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
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade300, Colors.blue.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none,
            suffixIcon: Visibility(
              visible: _searchController.text.isNotEmpty,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    searchQuery = '';
                    FocusScope.of(context).unfocus();
                  });
                },
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ),
        actions: [
          // back to today button
          IconButton(
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
            icon: const Icon(Icons.today),
          ),
          // filter button
          IconButton(
            onPressed: () {
              onTapFilter(context);
            },
            icon: const Icon(Icons.sort),
          ),

          // add habit button
          IconButton(
            onPressed: () {
              context.go('/habit/add');
            },
            icon: const Icon(Icons.add, size: 32.0),
          ),

          // refresh button
          IconButton(
            onPressed: () {
              context.read<HabitBloc>().add(HabitEventInitial());
            },
            icon: const Icon(Icons.refresh, size: 32.0),
          ),

          // // NOTE: remove this
          // ElevatedButton(
          //   onPressed: () async {
          //     final user = di<AuthenticationRepository>().getCurrentUser();
          //     log('object: ${user}');
          //     final firestore = di<FirebaseFirestore>();

          //     // firestore.collection(pathToHabits).get().then((value) {
          //     //   for (var doc in value.docs) {
          //     //     final habit = HabitModel.fromDocument(doc.data());
          //     //     debugPrint('$habit');
          //     //   }
          //     // });

          //     // firestore
          //     //     .collection(pathToHabits)
          //     //     .where('tests', arrayContainsAny: [
          //     //       {'name': 'name1', 'age' : '1'},
          //     //       'test2'
          //     //     ])
          //     //     .get()
          //     //     .then((value) {
          //     //       log('done get');
          //     //       for (var doc in value.docs) {
          //     //         final habit = HabitModel.fromDocument(doc.data());
          //     //         debugPrint('$habit');
          //     //       }
          //     //     });

          //     firestore
          //         .collection(pathToHabits)
          //         .where(Filter.or(
          //           Filter('creator.email', isEqualTo: user!.email),
          //           Filter('members', arrayContains: UserModel.fromEntity(user).toDocument()),
          //         ))
          //         .get()
          //         .then((value) {
          //       log('done get');
          //       for (var doc in value.docs) {
          //         final habit = HabitModel.fromDocument(doc.data());
          //         debugPrint('------$habit');
          //       }
          //     });

          //     debugPrint('text');
          //   },
          //   child: const Text('Button'),
          // ),
        ],
      ),
      drawer: const AppNavigationDrawer(),
      // floatingActionButton: FloatingActionButton(
      //   heroTag: 'fab_habit',
      //   onPressed: () {
      //     context.go('/habit/add');
      //   },
      //   child: const Icon(Icons.add),
      // ),
      body: BlocConsumer<HabitBloc, HabitState>(
        listener: (context, state) {
          if (state is HabitLoaded) {
            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: Colors.green.shade300,
                  // close snackbar
                  action: SnackBarAction(
                    label: 'Close',
                    textColor: Colors.white,
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          if (state is HabitLoaded) {
            return Column(
              children: [
                // habitSearchBar(
                //   context,
                //   controller: _searchController,
                //   onChange: () {
                //     setState(() {
                //       searchQuery = _searchController.text;
                //     });
                //   },
                //   onCancel: () {
                //     setState(() {
                //       _searchController.clear();
                //       searchQuery = '';
                //       FocusScope.of(context).unfocus();
                //     });
                //   },
                // ),
                const SizedBox(height: 8.0),
                EasyInfiniteDateTimeLine(
                  controller: _controller,
                  activeColor: Colors.green.shade300,
                  dayProps: const EasyDayProps(
                    dayStructure: DayStructure.dayNumDayStr,
                    height: 64.0,
                    activeDayStyle: DayStyle(
                      borderRadius: 16,
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
                // Today button and Filter button
                const SizedBox(height: 8.0),
                // buildControllerBar(context),
                // routine (morning, afternoon, evening) using chip
                buildRoutinePicker(),

                HabitList(
                  focusDate: _focus,
                  habitStream: state.habitStream,
                  currentFilter: currentFilter,
                  currentRoutine: currentRoutine,
                  query: searchQuery,
                ),
              ],
            );
          } else if (state is HabitLoading) {
            return const LoadingScreen();
          } else if (state is HabitInitial) {
            return const LoadingScreen();
          } else if (state is HabitError) {
            debugPrint('------------error: ${state.message}');
            return MessageScreen(message: state.message);
          } else {
            return const MessageScreen(message: 'Something went wrong [e04]');
          }
        },
      ),
    );
  }

  Widget buildControllerBar(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
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
            ElevatedButton(
              onPressed: () async {
                FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

                final List<PendingNotificationRequest> pendingNotificationRequests =
                    await flutterLocalNotificationsPlugin.pendingNotificationRequests();

                final List<ActiveNotification> activeNotifications = await flutterLocalNotificationsPlugin.getActiveNotifications();

                for (var pendingNotificationRequest in pendingNotificationRequests) {
                  debugPrint('pending: ${pendingNotificationRequest.id.toString()}');
                }
                for (var activeNotification in activeNotifications) {
                  debugPrint('active: ${activeNotification.id.toString()}');
                }
                log('done show');
              },
              child: const Text('all'),
            ),
            ElevatedButton(
              onPressed: () {
                log('object: ${generateNotificationId(DateTime.now())}');
              },
              child: const Text('random'),
            ),
            ElevatedButton(
              onPressed: () async {
                FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
                await flutterLocalNotificationsPlugin.cancelAll();
              },
              child: const Text('cancel all'),
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
