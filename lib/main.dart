import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'app.dart';
import 'config/bloc_config.dart';
import 'config/dependency_injection.dart';
import 'config/firebase_options.dart';
import 'core/notification/local_notification_manager.dart';
import 'core/notification/messaging_manager.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding); // hold splash screen until app is initialized

  tz.initializeTimeZones();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = GlobalBlocObserver();

  configureDependencies();
  
  await di<LocalNotificationManager>().init();
  // FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  await di<MessagingManager>().init();

  FlutterNativeSplash.remove(); // remove splash screen
  runApp(const App());
}
