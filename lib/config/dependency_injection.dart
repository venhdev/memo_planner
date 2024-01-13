import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import 'dependency_injection.config.dart';

final di = GetIt.instance;

@InjectableInit()
void configureDependencies() async => di.init();

@module
abstract class RegisterModule {
  // @preResolve
  // Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
  @singleton
  GoogleSignIn get googleSignIn => GoogleSignIn();

  @singleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @singleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @singleton
  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin => FlutterLocalNotificationsPlugin();

  @singleton
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;
}
