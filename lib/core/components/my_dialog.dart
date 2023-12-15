import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_planner/config/theme/text_style.dart';

import '../../features/authentication/presentation/bloc/authentication/authentication_bloc.dart';

void showMyDialogConfirmSignOut(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Sign Out'),
      content: const Text('Are you sure to sign out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            BlocProvider.of<AuthenticationBloc>(context).add(SignOutEvent());
            Navigator.pop(context);
          },
          child: const Text('Sign Out'),
        ),
      ],
    ),
  );
}

Future<void> showMyDialogToConfirm(
  BuildContext context, {
  required String title,
  required String content,
  required VoidCallback onConfirm,
}) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () async {
              onConfirm();
              log('pop pop dialog');
              Navigator.of(context).pop();
            },
            child: Text('Yes', style: MyTextStyle.redTextDialog),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No', style: MyTextStyle.blueTextDialog),
          ),
        ],
      );
    },
  );
}

void showMyDialogToAddMember(
  BuildContext context, {
  required VoidCallback onConfirm,
  required TextEditingController controller,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Member'),
        content: // text field
            TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              controller.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}

void showMyAlertDialogMessage({
  required BuildContext context,
  required String message,
  required Icon icon,
}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          icon: icon,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
      });
}
