import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'app.dart';
import 'config/bloc_config.dart';
import 'config/dependency_injection.dart';
import 'config/firebase_options.dart';
import 'config/theme/theme_provider.dart';
import 'core/service/firebase_cloud_messaging_service.dart';
import 'core/service/local_notification_service.dart';
import 'core/service/shared_preferences_service.dart';
import 'features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'features/task/presentation/bloc/task_bloc.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding); // hold splash screen until app is initialized

  tz.initializeTimeZones();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = GlobalBlocObserver();

  await configureDependencies();

  await di<LocalNotificationService>().init();
  await di<FirebaseCloudMessagingService>().init();

  final SharedPreferencesService pref = di<SharedPreferencesService>();

  FlutterNativeSplash.remove(); // remove splash screen when app is initialized
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(pref),
      ),
      BlocProvider(
        create: (_) => di<AuthBloc>()..add(AuthInitial()),
      ),
      BlocProvider(
        create: (_) => di<TaskBloc>()..add(const TaskInitial()),
      ),
    ],
    child: const MemoPlannerApp(),
  ));
}
