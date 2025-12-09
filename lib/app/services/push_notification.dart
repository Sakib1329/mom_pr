import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../constants/appconstant.dart';

import 'notification_services.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initLocalNotifications() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Important Notifications',
    description: 'Used for movie & series updates',
    importance: Importance.high,
    playSound: true,
  );

  final androidPlugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')),
    onDidReceiveNotificationResponse: (details) {
      print('Notification tapped: ${details.payload}');
    },
  );
}

Future<void> showNotification(RemoteMessage message) async {
  await showRichNotification(message.data, isBackground: false);
}

Future<void> initFCM() async {
  await initLocalNotifications();
  await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);

  final token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token");
  if (token != null) {
    GetStorage().write('FCMToken', token);
    await sendTokenToBackend(token);
  }



  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print("App opened from notification: ${message.data}");
  });

  FirebaseMessaging.instance.onTokenRefresh.listen(sendTokenToBackend);
}

Future<void> sendTokenToBackend(String token) async {
  final loginToken = GetStorage().read<String>('loginToken');
  if (loginToken == null) return;

  try {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/notification/register_device_token/'),
      headers: {'Authorization': 'Bearer $loginToken', 'Content-Type': 'application/json'},
      body: jsonEncode({'device_token': token}),
    );
    print(response.statusCode == 200 ? 'Token registered' : 'Token failed');
  } catch (e) {
    print('Token error: $e');
  }
}

Future<void> unregister() async {
  final loginToken = GetStorage().read<String>('loginToken');
  if (loginToken == null) return;

  try {
    await http.post(
      Uri.parse('${AppConstants.baseUrl}/notification/unregister_device_token/'),
      headers: {'Authorization': 'Bearer $loginToken'},
    );
    print('Token unregistered');
  } catch (e) {
    print('Unregister failed: $e');
  }
}