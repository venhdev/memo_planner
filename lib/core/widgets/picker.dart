import 'package:flutter/material.dart';
import 'package:memo_planner/core/utils/helpers.dart';

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
