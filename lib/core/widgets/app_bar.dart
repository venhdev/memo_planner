import 'package:flutter/material.dart';

class MyAppBar {
  static AppBar buildAppBar({
    required BuildContext context,
    required String title,
  }) {
    return AppBar(
      leading: Builder(builder: (context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            debugPrint('Open drawer');
            Scaffold.of(context).openDrawer();
          },
        );
      }),
      title: Text(title),
    );
  }
}
