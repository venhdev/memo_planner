import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/convertors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_instance_entity.dart';
import '../../domain/entities/rrule.dart';
import '../bloc/habit/habit_bloc.dart';
import '../bloc/instance/instance_bloc.dart';

enum EditType { unknown, addHabit, editHabit, editInstance }

class HabitForm extends StatefulWidget {
  const HabitForm({
    super.key,
    this.habit,
    this.instance,
    required this.type,
  });

  final EditType type;
  final HabitEntity? habit;
  final HabitInstanceEntity? instance;

  @override
  State<HabitForm> createState() => _HabitFormState();
}

class _HabitFormState extends State<HabitForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _start = getDate(DateTime.now());
  DateTime _end = getDate(DateTime.now());
  bool _hasEndDate = false;
  final List<String> recurrenceList = RRULE.list;

  @override
  void initState() {
    super.initState();
    if (widget.type == EditType.editHabit) {
      _titleController.text = widget.habit!.summary!;
      _descriptionController.text = widget.habit!.description!;
      _start = widget.habit!.start!;
      _end = widget.habit!.end!;
    } else if (widget.type == EditType.editInstance) {
      _titleController.text = widget.instance!.summary!;
      _descriptionController.text = widget.instance!.description!;
      _start = widget.instance!.date!;
      _end = widget.instance!.date!;
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
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16.0,
        right: 16.0,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              TextFormField(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                controller: _titleController,
                decoration: const InputDecoration(
                    labelText: 'Habit Title',
                    hintText: 'What is your habit?',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return '*Please enter your habit name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16.0),
              TextFormField(
                textAlign: TextAlign.center,
                controller: _descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe your habit (optional)',
                    border: OutlineInputBorder()),
              ),

              const SizedBox(height: 16.0),

              // dropdown to select recurrence
              DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: 'Recurrence',
                    hintText: 'How often do you want to do this habit?',
                    border: OutlineInputBorder(),
                  ),
                  value: recurrenceList.first,
                  icon: const Icon(Icons.arrow_downward),
                  onChanged: (value) {},
                  items: recurrenceList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child:
                          Text(value, style: const TextStyle(fontSize: 16.0)),
                    );
                  }).toList()),

              const Divider(),
              // DatePicker for start
              buildStartDatePicker(context),
              const Divider(),
              buildPickStartEndTime(context),
              const Divider(),

              // Checkbox to select if there is end date
              Row(
                children: [
                  Checkbox(
                    value: _hasEndDate,
                    onChanged: (value) {
                      setState(() {
                        _hasEndDate = value!;
                      });
                    },
                  ),
                  const Text('End Date'),
                ],
              ),

              // DatePicker for end
              buildEndDatePicker(context, _hasEndDate),

              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.type == EditType.addHabit) {
                      onSubmitAddHabit(context);
                    } else if (widget.type == EditType.editHabit) {
                      final updatedHabit = widget.habit!.copyWith(
                        summary: _titleController.text,
                        description: _descriptionController.text,
                        start: _start,
                        end: _end,
                        updated: DateTime.now(),
                      );
                      onSubmitEditAllHabit(context, updatedHabit);
                    } else if (widget.type == EditType.editInstance) {
                      final updatedInstance = widget.instance!.copyWith(
                        summary: _titleController.text,
                        description: _descriptionController.text,
                        start: _start,
                        end: _end,
                        edited: true,
                        updated: DateTime.now(),
                      );
                      onSubmitEditInstance(context, updatedInstance);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  widget.type == EditType.addHabit
                      ? 'Add New Habit'
                      : widget.type == EditType.editHabit
                          ? 'Edit All Habit'
                          : 'Edit Only This',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildPickStartEndTime(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              FocusScope.of(context).unfocus(); // hide keyboard
              final startTime = await pickTime(
                context,
                initTime: TimeOfDay.fromDateTime(_start),
              );
              startTime != null
                  ? setState(
                      () {
                        _start = _start.copyWith(
                          hour: startTime.hour,
                          minute: startTime.minute,
                        );
                        // when the start time is after end time
                        if (_start.isAfter(_end)) {
                          _end = _start;
                        }
                      },
                    )
                  : null;
            },
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  const Text('Start Time'),
                  Text(
                    convertDateTimeToString(
                      _start,
                      formatPattern: 'hh:mm',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        const VerticalDivider(
          thickness: 0.5,
          color: Colors.black,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              FocusScope.of(context).unfocus(); // hide keyboard
              final endTime = await pickTime(
                context,
                initTime: TimeOfDay.fromDateTime(_end),
              );
              endTime != null
                  ? setState(
                      () {
                        _end = _end.copyWith(
                          hour: endTime.hour,
                          minute: endTime.minute,
                        );
                      },
                    )
                  : null;
            },
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  const Text('End Time'),
                  Text(
                    convertDateTimeToString(
                      _end,
                      formatPattern: 'hh:mm',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildStartDatePicker(BuildContext context) {
    return Visibility(
      visible: widget.type != EditType.editInstance,
      child: GestureDetector(
        onTap: () async {
          debugPrint('buildStartDatePicker: onTap');
          FocusScope.of(context).unfocus(); // hide keyboard
          final date = await pickDate(context, initDate: _start);
          date != null
              ? setState(
                  () {
                    _start = _start.copyWith(
                      year: date.year,
                      month: date.month,
                      day: date.day,
                    );
                    _end = _end.copyWith(
                      year: date.year,
                      month: date.month,
                      day: date.day,
                    );
                  },
                )
              : null;
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              child: Wrap(
                spacing: 8.0,
                children: [
                  Icon(Icons.today_outlined),
                  Text('Start date:', style: TextStyle(fontSize: 16.0)),
                ],
              ),
              // child: Text('Start date:', style: TextStyle(fontSize: 16.0)),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  ddMMyyyyString(_start),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEndDatePicker(BuildContext context, bool isEndDateChecked) {
    return Visibility(
      visible: (widget.type != EditType.editInstance) && isEndDateChecked,
      child: GestureDetector(
        onTap: () async {
          debugPrint('buildEndDatePicker: onTap');
          FocusScope.of(context).unfocus(); // hide keyboard
          final endPicked = await pickDate(context, initDate: _end);
          debugPrint('buildEndDatePicker: endDate: $endPicked');
          endPicked != null
              ? setState(
                  () {
                    debugPrint('buildEndDatePicker: setState');
                    debugPrint('buildEndDatePicker: _start: $_start');
                    debugPrint('buildEndDatePicker: _end: $_end');

                    if (endPicked.isBefore(_start)) {
                      showAlertDialogMessage(
                        context: context,
                        message: 'The end date must after the start date',
                        icon: const Icon(Icons.error),
                      );
                    } else if (endPicked.isAfter(_start) ||
                        endPicked.isAtSameMomentAs(getDate(_start))) {
                      _end = _end.copyWith(
                        year: endPicked.year,
                        month: endPicked.month,
                        day: endPicked.day,
                      );
                    }
                    // _start = _start.copyWith(
                    //   year: endDate.year,
                    //   month: endDate.month,
                    //   day: endDate.day,
                    // );
                    // _end = _end.copyWith(
                    //   year: endDate.year,
                    //   month: endDate.month,
                    //   day: endDate.day,
                    // );
                  },
                )
              : null;
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              child: Wrap(
                spacing: 8.0,
                children: [
                  Icon(Icons.today_outlined),
                  Text('End date:', style: TextStyle(fontSize: 16.0)),
                ],
              ),
              // child: Text('Start date:', style: TextStyle(fontSize: 16.0)),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  ddMMyyyyString(_end),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSubmitAddHabit(BuildContext context) {
    if (_start.isBefore(_end) || _start.isAtSameMomentAs(_end)) {
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
    } else {
      showAlertDialogMessage(
        context: context,
        message: 'Start date must be before end date',
        icon: const Icon(Icons.error),
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
