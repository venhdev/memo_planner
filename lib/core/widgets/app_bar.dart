import 'package:flutter/material.dart';

class MyAppBar {
  static AppBar habitAppBar({
    required BuildContext context,
    String? title,
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
}

// add 'drawer: const AppNavigationDrawer(),' to Scaffold to open drawer on click