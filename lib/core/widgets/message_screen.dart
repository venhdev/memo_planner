import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({
    super.key,
    required this.message,
    this.enableBack = true
  });

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
