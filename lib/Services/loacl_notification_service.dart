import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: ((payload) {
      if (payload != null) {
        print(payload);
      }
    }));
  }

  static Future<void> display(RemoteMessage message) async {
    try {
      final id = DateTime.now().microsecondsSinceEpoch ~/ 1000000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        'notification',
        'notification channel',
        channelDescription: 'this is my channel',
        importance: Importance.max,
        priority: Priority.high,
      ));
      await _notificationsPlugin.show(id, message.notification.title,
          message.notification.body, notificationDetails,
          payload: message.data['route']);
    } on Exception catch (e) {
      print(e);
    }
  }
}
