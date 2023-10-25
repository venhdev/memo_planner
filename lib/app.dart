import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memo_planner/features/habit/presentation/bloc/bloc/habit_bloc.dart';
import 'package:provider/provider.dart';

import 'config/routes/routes.dart';
import 'core/utils/di.dart';
import 'features/authentication/presentation/bloc/bloc/authentication_bloc.dart';

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
          create: (_) =>
              di<AuthenticationBloc>()..add(AuthenticationStartedEvent()),
        ),
        BlocProvider(
          create: (_) => di<HabitBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Memo Planner',
        theme: ThemeData(
          buttonTheme: Theme.of(context).buttonTheme.copyWith(
                highlightColor: Colors.deepPurple,
              ),
          primarySwatch: Colors.deepPurple,
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        routerConfig: AppRouters.router,
      ),
    );
  }
}
