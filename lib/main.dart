
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mompr_em/app/modules/auth/controllers/authcontroller.dart';
import 'package:mompr_em/app/modules/home/controllers/home_controller.dart';
import 'package:mompr_em/app/modules/home/controllers/navcontroller.dart';
import 'package:mompr_em/app/modules/onboard/controllers/onboard_controller.dart';
import 'package:mompr_em/app/modules/settings/controllers/settingcontroller.dart';


import 'app/modules/onboard/views/splash.dart';

import 'app/res/colors/color.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
Get.put(OnboardController());
Get.put(NavController());
Get.put(Authcontroller());
Get.put(HomeController());
Get.put(Settingcontroller());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(360,690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        print('Initial ScreenUtil scaleWidth: ${ScreenUtil().scaleWidth}');
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: GetMaterialApp(

            debugShowCheckedModeBanner: false,
            title: "Application",
            home: SplashView(),
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
      },
    );
  }
}