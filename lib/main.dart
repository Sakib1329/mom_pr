import 'dart:convert';
import 'package:Nuweli/app/constants/apptranslations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toastification/toastification.dart';

import 'app/constants/app_lifecycle.dart';
import 'app/modules/onboard/views/splash.dart';
import 'app/bindings/initialbindings.dart';
import 'app/res/colors/color.dart';

import 'app/services/notification_services.dart';
import 'app/services/push_notification.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await GetStorage.init();
  print("BACKGROUND → Handler started (app killed)");
  await showRichNotification(message.data, isBackground: true);
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initLocalNotifications();
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: "assets/.env");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("FOREGROUND → Message received: ${message.data}");

    if (message.data.isNotEmpty) {
      showRichNotification(message.data, isBackground: false);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("NOTIFICATION TAPPED → Opening app with data: ${message.data}");
    if (message.data.isNotEmpty) {
      showRichNotification(message.data, isBackground: false);
    }
  });
  await Get.putAsync(() async => AppLifecycleService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? storedLocale = box.read('locale');
    Locale initLocale = Get.deviceLocale ?? const Locale('en', 'US');
    if (storedLocale != null) {
      final parts = storedLocale.split('_');
      if (parts.length == 2) {
        initLocale = Locale(parts[0], parts[1]);
      } else {
        initLocale = Locale(parts[0]);
      }
    }

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GestureDetector(
        onTap: (){

          FocusManager.instance.primaryFocus?.unfocus();

        },
        child: ToastificationWrapper(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            translations: AppTranslations(),
            title: "Nuweli",
            home: const SplashView(),
            initialBinding: InitialBinding(),
            locale: initLocale,
            fallbackLocale: const Locale('en', 'US'),
            theme: ThemeData(
              scaffoldBackgroundColor: AppColor.background,
              appBarTheme: const AppBarTheme(
                elevation: 0,
                backgroundColor: AppColor.background,
                scrolledUnderElevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}