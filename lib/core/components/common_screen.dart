import 'dart:developer';

import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class MessageScreen extends StatelessWidget {
  const MessageScreen({
    super.key,
    required this.message,
    this.enableBack = true,
    this.textStyle,
  });
  factory MessageScreen.error([String? message]) => MessageScreen(
        message: message ?? 'Unknown error',
        enableBack: false,
      );

  final String message;
  final bool enableBack;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    // log('MessageScreen: $message');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              child: Text(
                message,
                style: textStyle,
              ),
              onTap: () => log(message)),
          Visibility(
            visible: enableBack,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('< Back'),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageScreenWithAction extends StatelessWidget {
  factory MessageScreenWithAction.unauthenticated(VoidCallback onPressed) => MessageScreenWithAction(
        message: 'You are not authenticated. Please login to continue.',
        buttonText: 'Sign in',
        onPressed: onPressed,
      );
  const MessageScreenWithAction({
    super.key,
    this.message,
    this.buttonText = 'Button',
    required this.onPressed,
  });

  final String? message;
  final String? buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message ?? 'Something went wrong'),
          ElevatedButton(
            onPressed: () {
              onPressed();
            },
            child: Text(buttonText!),
          ),
        ],
      ),
    );
  }
}

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
