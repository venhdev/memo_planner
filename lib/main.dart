import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'app.dart';
import 'config/dependency_injection.dart';
import 'config/firebase_options.dart';
import 'config/global_config.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding); // hold splash screen until app is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = GlobalBlocObserver();
  configureDependencies();
  FlutterNativeSplash.remove(); // remove splash screen
  runApp(const App());
}
