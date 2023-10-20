import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/authentication/presentation/bloc/bloc/authentication_bloc.dart';
import 'app.dart';
import 'config/firebase_options.dart';
import 'config/global_config.dart';
import 'package:provider/provider.dart';

import 'core/utils/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = GlobalBlocObserver();
  configureDependencies();

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider<ApplicationState>(
        //   create: (_) => ApplicationState(),
        // ),
        BlocProvider(
          create: (_) =>
              di<AuthenticationBloc>()..add(AuthenticationStartedEvent()),
        ),
      ],
      child: const App(),
    ),
  );
}
