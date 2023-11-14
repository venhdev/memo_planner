import 'package:flutter/material.dart';

Future<DateTime?> pickDate(
  BuildContext context, {
  required DateTime initDate,
}) =>
    showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
Future<TimeOfDay?> pickTime(
  BuildContext context, {
  required TimeOfDay initTime,
}) =>
    showTimePicker(
      context: context,
      initialTime: initTime,
    );

