import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/modules/onboard/views/splash.dart';
import 'app/bindings/initialbindings.dart';
import 'app/res/colors/color.dart';

import 'app/services/notification_services.dart';  // ← FIXED: no "s" at the end

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// ────────────────────── BACKGROUND HANDLER (APP KILLED) ──────────────────────
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await GetStorage.init();
  print("BACKGROUND → Handler started (app killed)");
  await showRichNotification(message.data, isBackground: true);
}

// ────────────────────── MAIN ──────────────────────
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: "assets/.env");

  // Initialize local notifications (channel will be created inside showRichNotification)
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );

  // ───── FOREGROUND MESSAGES (when app is open) ─────
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("FOREGROUND → Message received: ${message.data}");
    // Your backend sends notification={}, so system shows tiny one
    // We override it with our beautiful rich notification
    if (message.data.isNotEmpty) {
      showRichNotification(message.data, isBackground: false);
    }
  });

  // ───── WHEN USER TAPS NOTIFICATION (app closed or background) ─────
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("NOTIFICATION TAPPED → Opening app with data: ${message.data}");
    if (message.data.isNotEmpty) {
      showRichNotification(message.data, isBackground: false);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Nuweli",
        home: const SplashView(),
        initialBinding: InitialBinding(),
        theme: ThemeData(
          scaffoldBackgroundColor: AppColor.background,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: AppColor.background,
            scrolledUnderElevation: 0,
          ),
        ),
      ),
    );
  }
}