import 'package:get/get.dart';
import 'package:Nuweli/app/modules/auth/controllers/authcontroller.dart';
import 'package:Nuweli/app/modules/home/controllers/home_controller.dart';
import 'package:Nuweli/app/modules/home/controllers/navcontroller.dart';
import 'package:Nuweli/app/modules/home/services/home_service.dart';
import 'package:Nuweli/app/modules/onboard/controllers/onboard_controller.dart';
import 'package:Nuweli/app/modules/settings/controllers/settingcontroller.dart';
import 'package:Nuweli/app/modules/settings/controllers/bottomsheetController.dart';

import '../services/push_notification.dart';
import '../modules/home/controllers/comingsoon_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {

    Get.put(HomeService(), permanent: true);
    Get.put(Authcontroller(), permanent: true);
    Get.put(NavController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(BottomSheetController(), permanent: true);
    Get.put(Settingcontroller(), permanent: true);
    Get.put(ComingSoonController(), permanent: true);

  }
}
