import 'package:flutter/material.dart';

// list day of week
const List<String> kDayOfWeek = [
  'MO', // Monday
  'TU', // Tuesday
  'WE', // Wednesday
  'TH', // Thursday
  'FR', // Friday
  'SA', // Saturday
  'SU', // Sunday
];

class MyWeekDaySelector extends StatelessWidget {
  const MyWeekDaySelector({
    super.key,
    this.height = 48.0,
    this.padding,
    this.margin = const EdgeInsets.symmetric(vertical: 8.0),
    required this.weekdays,
    required this.onChanged,
  });

  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final List<bool> weekdays;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      margin: margin,
      child: Row(
        children: [
          for (int i = 0; i < weekdays.length; i++)
            Expanded(
              child: buildButton(
                textDay: kDayOfWeek[i],
                isSelected: weekdays[i],
                onPressed: () {
                  onChanged!(i);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget buildButton({
    required bool isSelected,
    required VoidCallback onPressed,
    required String textDay,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[200] : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Text(
          textDay,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}

// class WeekDayButton extends StatelessWidget {
//   const WeekDayButton({
//     super.key,
//     required this.isSelected,
//     required this.onPressed,
//   });

//   final bool isSelected;
//   final VoidCallback? onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 48.0,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: isSelected ? Colors.blue[200] : Colors.grey[200],
//         shape: BoxShape.circle,
//       ),
//       child: GestureDetector(
//         onTap: () {
//           debugPrint('onTap $isSelected');
//           onPressed?.call();
//         },
//         child: const Text(
//           'MO',
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 16.0),
//         ),
//       ),
//     );
//   }
// }
