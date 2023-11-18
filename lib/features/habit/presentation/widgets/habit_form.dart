import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_instance_entity.dart';
import '../../domain/entities/rrule.dart';
import '../bloc/habit/habit_bloc.dart';
import '../bloc/instance/instance_bloc.dart';
import 'week_day_selector.dart';

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

  // the "FIRST DATE" that the habit take place, and hold the start time of day
  DateTime _start = getDate(DateTime.now());
  // have the same day with _start, and hold the end time of day
  DateTime _end = getDate(DateTime.now());
  // the "END DATE" of the habit (store at UNTIL in RRule)
  DateTime? _endOfHabit;

  bool _hasEndDate = false;
  String _freq = FREQ.daily.name;
  var weekdays = List.filled(7, true);

  @override
  void initState() {
    super.initState();
    if (widget.type == EditType.editHabit) {
      _titleController.text = widget.habit!.summary!;
      _descriptionController.text = widget.habit!.description!;
      _start = widget.habit!.start!;
      _end = widget.habit!.end!;
      _endOfHabit = widget.habit!.until;
      _hasEndDate = _endOfHabit != null;
    } else if (widget.type == EditType.editInstance) {
      _titleController.text = widget.instance!.summary!;
      _descriptionController.text = widget.instance!.description!;
      _start = widget.instance!.start!;
      _end = widget.instance!.end!;
    } else if (widget.type == EditType.addHabit) {
      _endOfHabit = _start.add(const Duration(days: 30));
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
                    labelText: 'Habit Title', hintText: 'What is your habit?', border: OutlineInputBorder()),
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
                    labelText: 'Description', hintText: 'Describe your habit (optional)', border: OutlineInputBorder()),
              ),

              const SizedBox(height: 16.0),

              // dropdown to select recurrence
              buildPickRecurrence(),

              const Divider(),
              buildStartDatePicker(context),

              const Divider(),
              buildPickTime(context),

              const Divider(),
              // Checkbox to select if there is end date
              Visibility(
                visible: widget.type != EditType.editInstance,
                child: Row(
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
                      onSubmitEditAllHabit(context);
                    } else if (widget.type == EditType.editInstance) {
                      onSubmitEditInstance(context);
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

  Widget buildPickRecurrence() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: 'Recurrence',
                    hintText: 'How often do you want to do this habit?',
                    border: OutlineInputBorder(),
                  ),
                  value: _freq,
                  icon: const Icon(Icons.arrow_drop_down),
                  onChanged: (value) {
                    setState(() {
                      _freq = value!;
                    });
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  items: RRule.getFREQs.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList()),
            ),
          ],
        ),
        Visibility(
          visible: _freq == FREQ.weekly.name,
          child: MyWeekDaySelector(
            weekdays: weekdays,
            height: 52.0,
            onChanged: (value) {
              setState(() {
                weekdays[value] = !weekdays[value];
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildPickTime(BuildContext context) {
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
                      pattern: kTimeFormatPattern,
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
              var startTime = TimeOfDay.fromDateTime(_start);
              final endPicked = await pickTime(
                context,
                initTime: TimeOfDay.fromDateTime(_end),
              );
              endPicked != null
                  ? setState(
                      () {
                        // picked time is before start time
                        if (compareTimeOfDay(endPicked, startTime) == -1) {
                          showAlertDialogMessage(
                            context: context,
                            message: 'The end time must after the start time',
                            icon: const Icon(Icons.error),
                          );
                        } else {
                          _end = _end.copyWith(
                            hour: endPicked.hour,
                            minute: endPicked.minute,
                          );
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
                  const Text('End Time'),
                  Text(
                    convertDateTimeToString(
                      _end,
                      pattern: kTimeFormatPattern,
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
    return GestureDetector(
      onTap: () async {
        if (widget.type == EditType.editInstance) {
          return;
        }
        FocusScope.of(context).unfocus(); // hide keyboard
        final date = await pickDate(context, initDate: _start);
        date != null
            ? setState(
                () {
                  // due to the habit take place on the same day
                  // so the {_start} and {_end} must be the same
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
                convertDateTimeToString(_start),
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEndDatePicker(BuildContext context, bool isEndDateChecked) {
    return Visibility(
      visible: (widget.type != EditType.editInstance) && isEndDateChecked,
      child: GestureDetector(
        onTap: () async {
          FocusScope.of(context).unfocus(); // hide keyboard
          final endPicked = await pickDate(context, initDate: _end);
          endPicked != null
              ? setState(
                  () {
                    if (endPicked.isBefore(_start)) {
                      showAlertDialogMessage(
                        context: context,
                        message: 'The end date must after the start date',
                        icon: const Icon(Icons.error),
                      );
                    } else {
                      // else the endPicker is after || at the same time _start
                      _endOfHabit = endPicked;
                      debugPrint('_endOfHabit: $_endOfHabit');
                    }
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
                  _endOfHabit != null ? convertDateTimeToString(_endOfHabit!) : 'No end date',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getUntil() => convertDateTimeToString(_endOfHabit!, pattern: kDateFormatPattern);

  String getRecurrenceRuleString() =>
      _freq == FREQ.daily.name //daily
        ? _hasEndDate
          ? RRule.dailyUntil(until: getUntil()).toString()
          : RRule.daily().toString()
        : _freq == FREQ.weekly.name //weekly
          ? _hasEndDate
            ? RRule.weeklyUntil(weekdays: weekdays, until: getUntil()).toString()
            : RRule.weekly(weekdays: weekdays).toString()
          : '';

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
            recurrence: getRecurrenceRuleString(),
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
    BuildContext context
  ) {
    final updatedInstance = widget.instance!.copyWith(
      summary: _titleController.text,
      description: _descriptionController.text,
      start: _start,
      end: _end,
      edited: true,
      updated: DateTime.now(),
    );
    BlocProvider.of<HabitInstanceBloc>(context).add(
      InstanceUpdateEvent(instance: updatedInstance),
    );
  }

  void onSubmitEditAllHabit(BuildContext context) {
    final updatedHabit = widget.habit!.copyWith(
      summary: _titleController.text,
      description: _descriptionController.text,
      start: _start,
      end: _end,
      recurrence: getRecurrenceRuleString(),
      updated: DateTime.now(),
    );
    BlocProvider.of<HabitBloc>(context).add(
      HabitUpdateEvent(habit: updatedHabit),
    );
  }
}
