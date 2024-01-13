import 'package:flutter/material.dart';

import '../utils/helpers.dart';

Future<DateTime?> showMyDatePicker(
  BuildContext context, {
  required DateTime initDate,
}) =>
    showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

Future<TimeOfDay?> showMyTimePicker(
  BuildContext context, {
  required TimeOfDay initTime,
}) =>
    showTimePicker(
      context: context,
      initialTime: initTime,
    );

class MyDatePicker extends StatelessWidget {
  const MyDatePicker({
    super.key,
    required this.date,
    required this.onTap,
    required this.onPressedClose,
  });

  final DateTime? date;
  final VoidCallback? onTap;
  final VoidCallback? onPressedClose;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(Icons.calendar_today),
      trailing: date != null ? IconButton(onPressed: onPressedClose, icon: const Icon(Icons.close)) : null,
      title: Text(date == null ? 'Set due date' : convertDateTimeToString(date!)),
    );
  }
}

class MyTimePicker extends StatelessWidget {
  const MyTimePicker({
    super.key,
    required this.date,
    required this.onTap,
    required this.onPressedClose,
  });

  final DateTime? date;
  final VoidCallback? onTap;
  final VoidCallback? onPressedClose;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(Icons.calendar_today),
      trailing: date != null ? IconButton(onPressed: onPressedClose, icon: const Icon(Icons.close)) : null,
      title: Text(date == null ? 'Set due date' : convertDateTimeToString(date!, pattern: 'HH:mm a')),
    );
  }
}

class MyDateTimePicker extends StatelessWidget {
  const MyDateTimePicker({
    super.key,
    required this.date,
    this.onTap,
    this.onTapTime,
    this.onPressedClose,
  });

  final DateTime? date;
  final VoidCallback? onTap;
  final VoidCallback? onTapTime;
  final VoidCallback? onPressedClose;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: date != null
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const Icon(Icons.calendar_today),
                  // get remaining time
                  if (date != null)
                    Text(
                      getRemainingTime(date!),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: date!.isBefore(DateTime.now()) ? Colors.red : Colors.black,
                      ),
                    ),
                ],
              ),
            )
          : const Icon(Icons.calendar_today),
      trailing: date != null ? IconButton(onPressed: onPressedClose, icon: const Icon(Icons.close)) : null,
      title: Text(date == null ? 'Set due date' : 'Due Date: ${convertDateTimeToString(date!)}'), //show date
      subtitle: date != null
          ? Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: onTapTime,
                  child: Text(
                    date == null ? 'Set time' : convertDateTimeToString(date!, pattern: 'HH:mm a'),
                    style: const TextStyle(color: Colors.black),
                  ),
                )
              ],
            )
          : null,
    );
  }
}

/// Return the same [date] with the [time] set
DateTime copyTimeOfDay(DateTime date, TimeOfDay time) => DateTime(date.year, date.month, date.day, time.hour, time.minute);
