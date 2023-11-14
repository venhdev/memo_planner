import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/constants/typedef.dart';
import '../../../../core/utils/convertors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_instance_entity.dart';
import '../../domain/entities/rrule.dart';
import '../../domain/usecase/get_create_habit_instance_by_iid.dart';
import '../../domain/usecase/get_habit_by_hid.dart';
import '../bloc/habit/habit_bloc.dart';
import '../bloc/instance/instance_bloc.dart';

enum EditType { unknown, addHabit, editHabit, editInstance }

class EditHabitScreenV2 extends StatefulWidget {
  const EditHabitScreenV2({
    super.key,
    this.id,
    this.type = EditType.unknown,
  });

  final String? id;
  final EditType type;

  @override
  State<EditHabitScreenV2> createState() => _EditHabitScreenV2State();
}

class _EditHabitScreenV2State extends State<EditHabitScreenV2> {
  // required ...
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _start = getDate(DateTime.now());
  DateTime _end = getDate(DateTime.now());
  final List<String> recurrenceList = RRULE.list;

  // init later in initState
  ResultEither<HabitEntity>? hFuture;
  ResultEither<HabitInstanceEntity>? iFuture;

  @override
  void initState() {
    super.initState();
    debugPrint('EditHabitScreenV2.initState()');
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
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(builder: (context) {
        if (widget.type == EditType.editHabit) {
          return buildForm(
            context,
            hFuture: hFuture,
          );
        } else if (widget.type == EditType.editInstance) {
          return buildForm(
            context,
            iFuture: iFuture,
          );
        } else {
          return buildForm(
            context,
          );
        }
      }),
    );
  }

  Widget buildForm(
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
                debugPrint('r: $r');
                debugPrint('r: ${r.runtimeType}');
                if (r is HabitEntity) {
                  _titleController.text = r.summary!;
                  _descriptionController.text = r.description!;
                  _start = r.start!;
                  _end = r.end!;
                  return buildFormBody(context, habit: r);
                } else if (r is HabitInstanceEntity) {
                  _titleController.text = r.summary!;
                  _descriptionController.text = r.description!;
                  return buildFormBody(context, instance: r);
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
          return buildFormBody(context);
        }
        return const MessageScreen(message: 'Unknown Error [e06]');
        // return Container(
        //   padding: EdgeInsets.only(
        //     top: MediaQuery.of(context).padding.top,
        //     left: 16,
        //     right: 16,
        //   ),
        //   child: buildFormBody(context),
        // );
      },
    );
  }

  Form buildFormBody(
    BuildContext context, {
    HabitEntity? habit,
    HabitInstanceEntity? instance,
  }) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Habit Title',
              hintText: 'What is your habit?',
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return '*Please enter your habit name';
              }
              return null;
            },
          ),

          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Describe your habit (optional)',
            ),
          ),

          // dropdown to select recurrence
          DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'Recurrence',
                hintText: 'How often do you want to do this habit?',
              ),
              value: recurrenceList.first,
              icon: const Icon(Icons.arrow_downward),
              onChanged: (value) {},
              items:
                  recurrenceList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList()),

          // DatePicker for start
          buildStartDatePicker(context),

          // DatePicker for end
          buildEndDatePicker(context),

          ElevatedButton(
            onPressed: () {
              if (widget.type == EditType.addHabit) {
                onSubmitAddHabit(context);
              } else if (widget.type == EditType.editHabit) {
                final updatedHabit = habit!.copyWith(
                  summary: _titleController.text,
                  description: _descriptionController.text,
                  start: _start,
                  end: _end,
                  updated: DateTime.now(),
                );
                onSubmitEditAllHabit(context, updatedHabit);
              } else if (widget.type == EditType.editInstance) {
                final updatedInstance = instance!.copyWith(
                  summary: _titleController.text,
                  description: _descriptionController.text,
                  edited: true,
                  updated: DateTime.now(),
                );
                onSubmitEditInstance(context, updatedInstance);
              }
              Navigator.pop(context);
            },
            child: Text(
              widget.type == EditType.addHabit
                  ? 'Add Habit'
                  : widget.type == EditType.editHabit
                      ? 'Edit All Habit'
                      : 'Edit Only This',
            ),
          ),
        ],
      ),
    );
  }

  Visibility buildEndDatePicker(BuildContext context) {
    return Visibility(
      visible: widget.type != EditType.editInstance,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () async {
              final date = await pickDate(context, initDate: _end);
              date != null
                  ? setState(
                      () {
                        _end = date;
                      },
                    )
                  : null;
            },
            icon: const Icon(Icons.calendar_month),
            label: const Text('End Date'),
          ),
          Text(ddMMyyyyString(_end)),
          TextButton.icon(
            onPressed: () async {
              final time = await pickTime(context,
                  initTime: TimeOfDay.fromDateTime(_end));
              time != null
                  ? setState(
                      () {
                        _end = _end.copyWith(
                          hour: time.hour,
                          minute: time.minute,
                        );
                      },
                    )
                  : null;
            },
            icon: const Icon(Icons.timer),
            label: const Text('Start Time'),
          ),
        ],
      ),
    );
  }

  Visibility buildStartDatePicker(BuildContext context) {
    return Visibility(
      visible: widget.type != EditType.editInstance,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () async {
              final date = await pickDate(context, initDate: _start);
              date != null
                  ? setState(
                      () {
                        _start = date;
                      },
                    )
                  : null;
            },
            icon: const Icon(Icons.calendar_month),
            label: const Text('Start Date'),
          ),
          Text(ddMMyyyyString(_start)),
          TextButton.icon(
            onPressed: () async {
              final time = await pickTime(context,
                  initTime: TimeOfDay.fromDateTime(_start));
              time != null
                  ? setState(
                      () {
                        _start = _start.copyWith(
                          hour: time.hour,
                          minute: time.minute,
                        );
                      },
                    )
                  : null;
            },
            icon: const Icon(Icons.timer),
            label: const Text('Start Time'),
          ),
        ],
      ),
    );
  }

  void onSubmitAddHabit(BuildContext context) {
    if (_formKey.currentState!.validate() && _start.isBefore(_end)) {
      BlocProvider.of<HabitBloc>(context).add(
        HabitAddEvent(
          habit: HabitEntity(
            hid: null,
            summary: _titleController.text,
            description: _descriptionController.text,
            start: _start,
            end: _end,
            recurrence: RRULE.daily().toString(),
            created: DateTime.now(),
            updated: DateTime.now(),
            creator: null,
          ),
        ),
      );
    }
  }

  void onSubmitEditInstance(
    BuildContext context,
    HabitInstanceEntity updatedInstance,
  ) {
    BlocProvider.of<HabitInstanceBloc>(context).add(
      InstanceUpdateEvent(instance: updatedInstance),
    );
  }

  void onSubmitEditAllHabit(
    BuildContext context,
    HabitEntity updatedHabit,
  ) {
    BlocProvider.of<HabitBloc>(context).add(
      HabitUpdateEvent(habit: updatedHabit),
    );
  }
}
