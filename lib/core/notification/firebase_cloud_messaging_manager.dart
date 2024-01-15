import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notification;
import 'package:googleapis/fcm/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import '../../config/credentials.dart';
import '../../features/task/data/models/task_model.dart';
import '../constants/constants.dart';
import 'local_notification_manager.dart';

// Use service account credentials to get an authenticated and auto refreshing client.
Future<AuthClient> obtainAuthenticatedClient() async {
  final accountCredentials = ServiceAccountCredentials.fromJson(
    json.encode(serviceAccountCredentials),
  );
  var scopes = <String>[
    FirebaseCloudMessagingApi.firebaseMessagingScope,
  ];

  AuthClient client = await clientViaServiceAccount(accountCredentials, scopes);

  return client; // NOTE: close client when done
}

// foreground message handler
void _foregroundMessageHandler(RemoteMessage message) {
  try {
    log('Got a message whilst in the foreground!');
    syncNotification(message);

    // if (message.notification != null) {
    //   log('Message also contained a notification: ${message.notification}');
    // }
  } catch (e) {
    log('_foregroundMessageHandler Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
  }
}

/// There are a few things to keep in mind about your background message handler:
/// 1. It must not be an anonymous function.
/// 2. It must be a top-level function (e.g. not a class method which requires initialization).
/// 3. When using Flutter version 3.3.0 or higher, the message handler must be annotated with @pragma('vm:entry-point') right above the function declaration (otherwise it may be removed during tree shaking for release mode).
/// see: https://firebase.google.com/docs/cloud-messaging/flutter/receive
@pragma('vm:entry-point')
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  log('Got a message whilst in the background!');
  syncNotification(message);
}

@singleton
class FirebaseCloudMessagingManager {
  FirebaseCloudMessagingManager(this._firebaseMessaging);

  final FirebaseMessaging _firebaseMessaging;
  get I => _firebaseMessaging;
  String? currentFCMToken;

  Future<void> init() async {
    // request permission from user (will show prompt dialog)

    // You may set the permission requests to "provisional" which allows the user to choose what type
    // of notifications they would like to receive once the user receives a notification.
    // https://firebase.flutter.dev/docs/messaging/permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('[Messaging] User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      log('[Messaging] User granted provisional permission');
    } else {
      log('[Messaging] User declined or has not accepted permission');
    }

    // fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();
    currentFCMToken = fCMToken;
    // debugPrint('FCM Token: $fCMToken');

    // foreground message handler
    FirebaseMessaging.onMessage.listen(_foregroundMessageHandler);

    // background message handler
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

    // log('init MessagingManager success! with currentFCMToken: $currentFCMToken');
  }

  Future<void> sendDataMessageToMultipleDevices({
    required List<String> tokens,
    required Map<String, String> data,
  }) async {
    try {
      final client = await obtainAuthenticatedClient();
      final fcmApi = FirebaseCloudMessagingApi(client);

      for (final token in tokens) {
        await fcmApi.projects.messages
            .send(
              SendMessageRequest(
                message: Message(
                  token: token,
                  data: data,
                  android: AndroidConfig(priority: 'high'),
                ),
              ),
              'projects/$projectId',
            )
            .then((value) => log('finished sendDataMessageToMultipleDevices msg[${value.data.toString()}]'));
      }

      client.close();
    } catch (e) {
      log('sendDataMessageToMultipleDevices Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
    }
  }

  Future<void> sendDataMessage({
    required String token,
    required Map<String, String> data,
  }) async {
    try {
      final client = await obtainAuthenticatedClient();
      final fcmApi = FirebaseCloudMessagingApi(client);

      await fcmApi.projects.messages
          .send(
            SendMessageRequest(
              message: Message(
                token: token,
                data: data,
                android: AndroidConfig(priority: 'high'),
              ),
            ),
            'projects/$projectId',
          )
          .then((value) => log('finished sendDataMessage: msg[${value.data.toString()}]'));

      client.close();
    } catch (e) {
      log('sendDataMessage Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
    }
  }
}

void syncNotification(RemoteMessage message) {
  final type = message.data['type'] as String;

  switch (type) {
    case kFCMAddOrUpdateReminder:
      tz.initializeTimeZones();
      handleAddOrUpdateReminder(message.data);
      break;
    case kFCMDeleteReminder:
      handleDeleteReminder(message.data);
      break;
    default:
      log('Unknown type: $type');
  }
}

Future<void> handleAddOrUpdateReminder(Map<String, dynamic> data) async {
  final TaskModel task = TaskModel.fromJson(data['task']!);

  LocalNotificationManager(notification.FlutterLocalNotificationsPlugin()).setScheduleNotificationFromTask(task);
}

Future<void> handleDeleteReminder(Map<String, dynamic> data) async {
  final int rid = int.parse(data['rid']! as String);
  LocalNotificationManager(notification.FlutterLocalNotificationsPlugin()).I.cancel(rid);
}

// POST https://fcm.googleapis.com/v1/projects/{projectId}/messages:send