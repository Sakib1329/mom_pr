import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Settingcontroller extends GetxController{
  var selectedPlan = 0.obs;
  var deleteConfirmText = ''.obs;
  var nameText = ''.obs;
  var passwordText = ''.obs;
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController(text: '+8801456423195');
  final emailController = TextEditingController();
  final deleteConfirmController = TextEditingController();
  var selectedGender = RxnString();// 0 for 3 months, 1 for 12 months

  void selectPlan(int index) {
    selectedPlan.value = index;
  }
@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    deleteConfirmController.addListener(() {
      deleteConfirmText.value = deleteConfirmController.text;
    });
  }
  void subscribe() {
    // Handle subscription logic here
    String planName = selectedPlan.value == 0 ? "3 Months" : "12 Months";
    Get.snackbar(
      "Subscription",
      "Selected plan: $planName",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

}