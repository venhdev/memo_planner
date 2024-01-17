import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/routes/routes.dart';
import 'config/theme/theme_provider.dart';

class MemoPlannerApp extends StatelessWidget {
  const MemoPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Memo Planner',
      theme: Provider.of<ThemeProvider>(context).light,
      darkTheme: Provider.of<ThemeProvider>(context).dark,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      routerConfig: AppRouters.router,
    );
  }
}
