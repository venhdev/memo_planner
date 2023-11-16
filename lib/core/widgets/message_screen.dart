// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen(
      {super.key, required this.message, this.enableBack = true});

  final String message;
  final bool enableBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          Visibility(
            visible: enableBack,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageScreenWithAction extends StatelessWidget {
  const MessageScreenWithAction({
    super.key,
    required this.message,
    this.buttonText = 'Button',
    required this.onPressed,
  });

  final String message;
  final String? buttonText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
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
