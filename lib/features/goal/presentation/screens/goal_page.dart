import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  DateTime? _focusDate;
  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[50],
      child: Column(
        children: [
          EasyInfiniteDateTimeLine(
            controller: _controller,
            firstDate: DateTime(2023),
            focusDate: _focusDate,
            lastDate: DateTime(2023, 12, 31),
            onDateChange: (selectedDate) {
              setState(() {
                _focusDate = selectedDate;
              });
            },
          ),
          EasyDateTimeLine(
            initialDate: DateTime.now(),
            onDateChange: (selectedDate) {
              //`selectedDate` the new date selected.
            },
          ),
        ],
      ),
    );
  }
}
