import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Nuweli/app/bindings/initialbindings.dart';
import 'package:Nuweli/app/services/push_notification.dart';
import 'package:Nuweli/app/modules/settings/service/setting_service.dart';
import 'package:Nuweli/app/res/colors/color.dart';
import '../../auth/views/login.dart';
import '../views/webviewpage.dart';
import '../controllers/bottomsheetController.dart'; // ✅ Import BottomSheetController

class Settingcontroller extends GetxController {
  final SettingService _settingService = SettingService();
  final BottomSheetController _bottomSheetController = Get.find<BottomSheetController>(); // ✅ Access BottomSheetController
  final RxBool isLiked = false.obs;
  final RxBool isDisliked = false.obs;
  var stripeMonthly = 0.0.obs;
  var stripeYearly = 0.0.obs;
  var moncashMonthly = 0.0.obs;
  var moncashYearly = 0.0.obs;
  var phone = ''.obs;
  final RxString privacyContent = ''.obs;
  // Subscription
  var selectedPlan = 0.obs;

  // Profile observables
  var firstName = ''.obs;
  var lastName = ''.obs;
  var dateOfBirth = ''.obs;
  var gender = ''.obs;
  var email = ''.obs;
  var profileImage = ''.obs;
  // Stores the URL from the backend

  // Local picked image for update
  var pickedImage = Rxn<File>(); // Stores the locally picked image file

  // Help & support
  var helpLoading = false.obs;

  // Loading states
  var isLoading = false.obs;

  // Text controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController(text: '+8801456423195');
  final emailController = TextEditingController();
  final deleteConfirmController = TextEditingController();
  var deleteConfirmText = ''.obs;

  var selectedGender = RxnString();

//paymentstatus
  var isSubscribed = false.obs;
  var subPeriod     = ''.obs;   // "monthly" or "yearly"
  var nextBilling   = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadPrivacyPolicy();
    fetchProfileData();
    fetchSubscriptionStatus();
    deleteConfirmController.addListener(() {
      deleteConfirmText.value = deleteConfirmController.text;
    });

    ever(_bottomSheetController.pickedImage, (File? image) {
      if (image != null) {
        pickedImage.value = image; // Sync with BottomSheetController's picked image
      }
    });
  }

  /// 🔹 Fetch user profile data
  Future<void> fetchProfileData() async {
    try {
      isLoading.value = true;

      final data = await _settingService.fetchProfile();

      firstName.value = data['first_name'] ?? '';
      lastName.value = data['last_name'] ?? '';
      dateOfBirth.value = data['date_of_birth'] ?? '';
      gender.value = data['gender'] ?? '';
      email.value = data['email'] ?? '';
      profileImage.value = data['profile_image'] ?? '';
      phone.value=data['phone']?? "";

      // Update controllers
      firstNameController.text = firstName.value;
      lastNameController.text = lastName.value;
      dobController.text = dateOfBirth.value;
      emailController.text = email.value;
      selectedGender.value = gender.value;
    } catch (e) {

    } finally {
      isLoading.value = false;
    }
  }
  Future<void> loadPrivacyPolicy() async {
    try {
      isLoading.value = true;

      final data = await _settingService.fetchPrivacyPolicy();
      privacyContent.value = data;
    } catch (e) {
      print("Error loading privacy policy: $e");
    } finally {
      isLoading.value = false;
    }
  }
  /// 🔹 Update user profile (with image)
  Future<void> updateProfileData() async {
    try {
      isLoading.value = true;

      final success = await _settingService.updateProfile(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        dateOfBirth: dobController.text.trim(),
        gender: selectedGender.value ?? '',
        email: emailController.text.trim(),
        phone: phone.value,
        profileImageFile: pickedImage.value ?? _bottomSheetController.pickedImage.value, // ✅ Use synced image
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        _bottomSheetController.pickedImage.value = null; // ✅ Reset BottomSheetController's image
        pickedImage.value = null; // Reset local image
        await fetchProfileData(); // Refresh profile
      } else {
        Get.snackbar(
          'Failed',
          'Unable to update profile. Try again later.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Delete profile
  Future<void> deleteProfileData() async {
    try {
      isLoading.value = true;

      final data = await _settingService.deleteProfile();

      if (data['message'] != null && data['message'] == 'account deleted') {
        Get.snackbar(
          'Success',
          'Profile deleted successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => Login(), transition: Transition.rightToLeft);
      } else {
        Get.snackbar(
          'Failed',
          data['message'] ?? 'Unable to delete profile',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Submit Help & Support request
  Future<void> submitHelpSupport({
    required String email,
    required String description,
  }) async {
    if (email.isEmpty || description.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      helpLoading.value = true;

      final success = await _settingService.helpSupport(
        email: email.trim(),
        description: description.trim(),
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Your query has been submitted successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Failed',
          'Unable to submit your query. Try again later.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      helpLoading.value = false;
    }
  }

  /// 🔹 Subscription Plan Selection
  void selectPlan(int index) => selectedPlan.value = index;


  /// 🔹 Initiate Payment
  Future<void> initiatePayment({
    required int id,
    required String aliasType,
    required bool isMonCash,
  }) async {
    try {
      final url = await _settingService.purchase(
        id: id,
        aliasType: aliasType,
        isMonCash: isMonCash,
      );

      if (url != null && url.isNotEmpty) {
        Get.to(() => SimpleWebViewPage(url: url, buttonTitle: 'Payment'));
      } else {
        Get.snackbar('Error', 'Payment URL not received',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// 🔹 Subscription Payment (monthly/yearly)
  Future<void> paySubscription({
    required String period,
    required bool isMonCash,
  }) async {
    print(isMonCash);
    try {
      isLoading.value = true;

      final url = await _settingService.subscriptionPayment(
        period: period,
        isMonCash: isMonCash,
      );

      if (url != null && url.isNotEmpty) {
        Get.to(() =>
            SimpleWebViewPage(url: url, buttonTitle: 'Subscription Payment'));
      } else {
        Get.snackbar(
          'Error',
          'Payment URL not received',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    } catch (e) {

      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

    } finally {
      isLoading.value = false;
      await fetchSubscriptionStatus();
    }
  }

  Future<void> fetchSubscriptionPrices() async {
    try {
      isLoading.value = true;

      final data = await _settingService.fetchSubscriptionPrices();

      // Update observables with fetched prices
      stripeMonthly.value = (data['stripe']['monthly'] ?? 0).toDouble();
      stripeYearly.value = (data['stripe']['yearly'] ?? 0).toDouble();
      moncashMonthly.value = (data['moncash']['monthly'] ?? 0).toDouble();
      moncashYearly.value = (data['moncash']['yearly'] ?? 0).toDouble();
    } catch (e) {
  print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchSubscriptionStatus() async {
    try {
      isLoading.value = true;

      final data = await _settingService.fetchSubscriptionProfile();

      if (data != null) {
        isSubscribed.value = data['is_subscribed'] == true;
        subPeriod.value    = (data['period'] ?? '').toLowerCase();
        nextBilling.value  = data['next_billing'] ?? '';
      } else {
        isSubscribed.value = false;
        subPeriod.value    = '';
        nextBilling.value  = '';
        await fetchSubscriptionPrices();
      }
    } catch (e) {
      print("fetchSubscriptionStatus error: $e");
      isSubscribed.value = false;
    }
     finally {
      isLoading.value = false;
     }
  }

  Future<void> cancelCurrentSubscription() async {
    try {
      isLoading.value = true;

      final success = await _settingService.cancelSubscription();

      if (success) {
        Get.snackbar(
          'Success',
          'Subscription cancelled successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );

        // Refresh subscription status to update UI immediately
        await fetchSubscriptionStatus();

        // Optional: refresh profile if subscription affects other data
        // await fetchProfileData();
      } else {
        Get.snackbar(
          'Failed',
          'Could not cancel subscription. Please try again later.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
  /// 🔹 Sign out user
  Future<void> signOut() async {
    final box = GetStorage();
    Get.offAll(() => Login(), transition: Transition.rightToLeft);
    await unregister();
    await box.remove('loginToken');
    await box.remove('refreshToken');



    Get.snackbar(
      'Success',
      'You have been signed out',
      backgroundColor: AppColor.vividAmber,
      colorText: AppColor.black,
    );
  }
}