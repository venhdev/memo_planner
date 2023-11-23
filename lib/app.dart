import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'config/dependency_injection.dart';
import 'config/routes/routes.dart';
import 'config/theme/app_theme.dart';
import 'features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'features/goal/presentation/bloc/target/target_bloc.dart';
import 'features/goal/presentation/bloc/task/task_bloc.dart';
import 'features/habit/presentation/bloc/habit/habit_bloc.dart';
import 'features/habit/presentation/bloc/instance/instance_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider<ApplicationState>(
        //   create: (_) => ApplicationState(),
        // ),
        BlocProvider(
          create: (_) => di<AuthenticationBloc>()..add(AuthenticationStartedEvent()),
        ),
        BlocProvider(
          create: (_) => di<HabitBloc>()..add(HabitStartedEvent()),
        ),
        BlocProvider(
          create: (_) => di<TaskBloc>()..add(TaskEventInitial()),
        ),
        BlocProvider(
          create: (_) => di<TargetBloc>()..add(TargetEventInitial()),
        ),
        BlocProvider(
          create: (_) => di<HabitInstanceBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Memo Planner',
        theme: AppTheme.defaultTheme,
        routerConfig: AppRouters.router,
      ),
    );
  }
}
