import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum AppState {
  foreground,
  background,
  terminated,
}

class PushNotificationsManager {
  factory PushNotificationsManager() => _instance;
  PushNotificationsManager._()
      : _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  /// Function to setup up push notifications and its configurations
  Future<void> init() async {
    _setFCMToken();
    _configure();
  }

  /// Function to ask user for push notification permissions and if provided, save FCM Token in persisted local storage.
  Future<void> _setFCMToken() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    /// requesting permission for [alert], [badge] & [sound]. Only for iOS
    final NotificationSettings settings = await messaging.requestPermission();

    /// saving token only if user granted access.
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final String? token = await messaging.getToken();
      debugPrint('FirebaseMessaging token: $token');
    }
  }

  /// Function to configure the functionality of displaying and tapping on notifications.
  Future<void> _configure() async {
    /// For iOS only, setting values to show the notification when the app is in foreground state.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        ),
      ),
    );

    /// handler when notification arrives. This handler is executed only when notification arrives in foreground state.
    /// For iOS, OS handles the displaying of notification
    /// For Android, we push local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showForegroundNotificationInAndroid(message);
    });

    /// handler when user taps on the notification.
    /// For iOS, it gets executed when the app is in [foreground] / [background] state.
    /// For Android, it gets executed when the app is in [background] state.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotification(message: message.data, appState: AppState.foreground);
    });

    /// If the app is launched from terminated state by tapping on a notification, [getInitialMessage] function will return the
    /// [RemoteMessage] only once.
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    /// if [RemoteMessage] is not null, this means that the app is launched from terminated state by tapping on the notification.
    if (initialMessage != null) {
      _handleNotification(
          message: initialMessage.data, appState: AppState.terminated);
    }
  }

  Future<void> _showForegroundNotificationInAndroid(
      RemoteMessage message) async {
    _handleNotification(
      appState: AppState.foreground,
      message: message.data,
    );
  }

  Future<void> _handleNotification({
    required AppState appState,
    required Map<String, dynamic> message,
  }) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'inkDate',
        'Ink Date Notifications',
        channelDescription: 'Default push notification channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _localNotificationsPlugin.show(
      Random().nextInt(pow(2, 31).toInt()),
      'Tienes un recordatorio',
      'Recuerda tu cita el dia Sabado 31 de Octubre a las 2:00pm',
      notificationDetails,
    );
  }
}
