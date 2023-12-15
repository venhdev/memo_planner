import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    this.controller,
    required this.label,
    this.hintText,
    this.maxLines,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.suffix,
  });
  final TextEditingController? controller;
  final String label;
  final String? hintText;
  final int? maxLines;
  final int? minLines;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final Widget? suffix;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTap: onTap,
      style: const TextStyle(color: Colors.black87),
      minLines: minLines,
      maxLines: maxLines,
      readOnly: readOnly,
      decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          suffix: suffix,
          labelText: label,
          hintText: hintText,
          labelStyle: const TextStyle(color: Colors.black45),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
    );
  }
}
