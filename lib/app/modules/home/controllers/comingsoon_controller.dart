import 'package:flutter/cupertino.dart';
import 'package:get/Get.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../models/comingsoon_model.dart';
import '../services/comingsoon_service.dart';

class ComingSoonController extends GetxController {
  final ComingSoonService _service = ComingSoonService();
  final RxList<ComingSoonItem> items = <ComingSoonItem>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      error.value = '';
      final fetchedItems = await _service.fetchComingSoon();
      items.assignAll(fetchedItems);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> remindMe(String id) async {
    final success = await _service.remindMe(int.parse(id));
    await fetchItems();

    if (success) {
      Get.snackbar(
        'Success',
        'reminder_added'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColor.vividAmber,
        titleText: Text('Success', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
        messageText: Text('reminder_added'.tr, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
      );
    } else {
      Get.snackbar(
        'Failed',
        'reminder_failed'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColor.vividAmber,
        titleText: Text('Failed', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
        messageText: Text('reminder_failed'.tr, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
      );
    }
  }
}