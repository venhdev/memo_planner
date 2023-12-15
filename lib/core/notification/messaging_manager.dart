// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log('Got a message whilst in the background!');
  log('Message data: ${message.data}');
  log('Message also contained a notification: ${message.notification}');
  log('Title: ${message.notification?.title}');
  log('Body: ${message.notification?.body}');
  // delete message to prevent showing notification
}

@singleton
class MessagingManager {
  MessagingManager(this._firebaseMessaging);

  final FirebaseMessaging _firebaseMessaging;
  get I => _firebaseMessaging;
  String? currentFCMToken;

  Future<void> init() async {
    // request permission from user (will show prompt dialog)

    await _firebaseMessaging.requestPermission();
    // await _firebaseMessaging.setForegroundNotificationPresentationOptions(
    //   alert: false, // disable alert sound
    //   badge: false, // disable notification badge
    //   sound: false, // disable notification sound
    // );

    // fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();
    currentFCMToken = fCMToken;

    // debugPrint('FCM Token: $fCMToken');

    // background message handler
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    log('init MessagingManager success! with token: $fCMToken');
  }
}
