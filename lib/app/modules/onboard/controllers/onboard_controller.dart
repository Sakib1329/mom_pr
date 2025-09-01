import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mompr_em/app/modules/onboard/views/onboarding1.dart';

class OnboardController extends GetxController{
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    startTimer();
  }
  void startTimer() {
    Timer(const Duration(seconds: 5), routeUser);
  }

  void routeUser() {
    final token = GetStorage().read<String>('loginToken');
    if (token != null && token.isNotEmpty) {

    } else {
      // Navigate to OnboardPage with ScreenUtilWrapper (for consistency)
      Get.off(() => Onboard1(),
          transition: Transition.rightToLeft);
    }
  }

}