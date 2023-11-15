import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.border = const OutlineInputBorder(),
    String? Function(String?)? validator,
    this.icon,
  });
  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final InputBorder? border;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: border,
        icon: icon,
      ),
    );
  }
}
