import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    super.key,
    this.richText = 'No data',
    this.onPressed,
    this.actionText = 'Create new',
    this.spanChildren,
  });
  final String? richText;

  final VoidCallback? onPressed;
  final String? actionText;
  final List<InlineSpan>? spanChildren;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          children: [
            SvgPicture.asset(
              'assets/images/no-data.svg',
              height: 200,
              fit: BoxFit.scaleDown,
            ),
            const SizedBox(height: 18),
            Text.rich(
              TextSpan(
                text: richText,
                style: const TextStyle(
                  fontSize: 16,
                ),
                children: spanChildren,
              ),
              textAlign: TextAlign.center,
            ),
            Builder(builder: (context) {
              if (onPressed == null) return const SizedBox.shrink();
              return GestureDetector(
                onTap: onPressed,
                child: Text(
                  actionText!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

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
    log('render MessageScreen with message: $message');
    return Scaffold(
      body: Center(
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
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  const DividerWithText({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
  });

  final Color? color;
  final String text;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }
}
