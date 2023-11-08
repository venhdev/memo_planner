import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({
    super.key,
    this.color,
    required this.text,
    this.fontSize,
  });

  final Color? color;
  final String text;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: color ?? Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 14.0,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
