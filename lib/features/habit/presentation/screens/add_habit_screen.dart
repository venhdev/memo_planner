import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_planner/features/habit/domain/entities/rrule.dart';

import '../../../../core/utils/convertors.dart';
import '../../domain/entities/habit_entity.dart';
import '../bloc/habit/habit_bloc.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> recurrenceList = RRULE.list;

  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 16,
          right: 16,
        ),
        child: Form(
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
                  items: recurrenceList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()),

              // DatePicker for start
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final date = await pickDate(_start);
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
                      final time =
                          await pickTime(TimeOfDay.fromDateTime(_start));
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

              // DatePicker for end
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final date = await pickDate(_end);
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
                      final time =
                          await pickTime(TimeOfDay.fromDateTime(_end));
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
                    label: const Text('End Time'),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _start.isBefore(_end)) {
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
                    Navigator.pop(context);
                  } else {}
                },
                child: const Text('Add New Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> pickDate(DateTime initDate) => showDatePicker(
        context: context,
        initialDate: initDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
      );
  Future<TimeOfDay?> pickTime(TimeOfDay initTime) =>
      showTimePicker(context: context, initialTime: initTime);
}
