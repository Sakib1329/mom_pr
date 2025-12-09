import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Nuweli/app/modules/home/views/navbar.dart';
import 'package:Nuweli/app/modules/onboard/views/onboarding1.dart';

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
    print(token);

    if (token != null && token.isNotEmpty) {
Get.off(Navbar(),transition: Transition.rightToLeft);
    } else {
      Get.off(() => Onboard1(),
          transition: Transition.rightToLeft);
    }
  }

}