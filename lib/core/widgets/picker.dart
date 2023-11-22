import 'package:flutter/material.dart';

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
