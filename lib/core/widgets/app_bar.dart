import 'package:flutter/material.dart';

class MyAppBar {
  static AppBar habitAppBar({
    required BuildContext context,
    String? title = 'Habit',
  }) {
    return AppBar(
      leading: Builder(builder: (context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      }),
      title: title != null ? Text(title) : null,
    );
  }

  static AppBar goalAppBar({
    required BuildContext context,
    String? title = 'Goal',
    PreferredSizeWidget? bottom,
  }) {
    return AppBar(
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      title: title != null ? Text(title) : null,
      bottom: bottom,
    );
  }
}

InkWell buildActionButton({
    VoidCallback? onTap,
    String title = 'Button',
    Color? color = Colors.green,
  }) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(title, style: const TextStyle(fontSize: 16.0)),
      ),
    );
  }

// add 'drawer: const AppNavigationDrawer(),' to Scaffold to open drawer on click