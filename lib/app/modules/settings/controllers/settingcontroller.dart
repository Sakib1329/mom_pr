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
import '../controllers/bottomsheetController.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';
import 'package:toastification/toastification.dart';
import '../../../utils/error_helper.dart';

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
  var isFetchingProfile = false.obs;

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
    _cleanupExpiredDownloads();
    deleteConfirmController.addListener(() {
      deleteConfirmText.value = deleteConfirmController.text;
    });

    ever(_bottomSheetController.pickedImage, (File? image) {
      if (image != null) {
        pickedImage.value = image; // Sync with BottomSheetController's picked image
      }
    });
  }

  Future<void> _cleanupExpiredDownloads() async {
    try {
      final downloadManager = VdoDownloadManager.getInstance();
      final List<DownloadStatus> all = await downloadManager.query(Query());
      final storage = GetStorage();
      Map<String, dynamic> expiryDates = storage.read('download_expiry_dates') ?? {};
      bool statusChanged = false;

      for (var status in all) {
        final mediaId = status.mediaInfo.mediaId;
        if (expiryDates.containsKey(mediaId)) {
          final downloadDate = DateTime.parse(expiryDates[mediaId]);
          if (DateTime.now().difference(downloadDate).inDays >= 15) {
            debugPrint('Auto-cleaning expired download on start: $mediaId');
            downloadManager.remove(mediaId);
            expiryDates.remove(mediaId);
            statusChanged = true;
          }
        }
      }

      if (statusChanged) {
        storage.write('download_expiry_dates', expiryDates);
      }
    } catch (e) {
      debugPrint('Error during download cleanup: $e');
    }
  }

  /// 🔹 Fetch user profile data
  Future<void> fetchProfileData() async {
    try {
      isFetchingProfile.value = true;

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
      isFetchingProfile.value = false;
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
        toastification.show(
          title: const Text('Success'),
          description: const Text('Profile updated successfully!'),
          style: ToastificationStyle.fillColored, type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
        );
        _bottomSheetController.pickedImage.value = null; // ✅ Reset BottomSheetController's image
        pickedImage.value = null; // Reset local image
        await fetchProfileData(); // Refresh profile
      } else {
        toastification.show(
          title: const Text('Failed'),
          description: const Text('Unable to update profile. Try again later.'),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      final msg = cleanErrorMessage(e);
      if (msg != 'offline') {
        toastification.show(
          title: const Text('Error'),
          description: Text(msg),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
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
        toastification.show(
          title: const Text('Success'),
          description: const Text('Profile deleted successfully!'),
          style: ToastificationStyle.fillColored, type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
        );
        Get.offAll(() => Login(), transition: Transition.rightToLeft);
      } else {
        toastification.show(
          title: const Text('Failed'),
          description: Text(data['message'] ?? 'Unable to delete profile'),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      final msg = cleanErrorMessage(e);
      if (msg != 'offline') {
        toastification.show(
          title: const Text('Error'),
          description: Text(msg),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
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
      toastification.show(
        title: const Text('Error'),
        description: const Text('Please fill all fields'),
        style: ToastificationStyle.fillColored, type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
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
        toastification.show(
          title: const Text('Success'),
          description: const Text('Your query has been submitted successfully!'),
          style: ToastificationStyle.fillColored, type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
        );
      } else {
        toastification.show(
          title: const Text('Failed'),
          description: const Text('Unable to submit your query. Try again later.'),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      final msg = cleanErrorMessage(e);
      if (msg != 'offline') {
        toastification.show(
          title: const Text('Error'),
          description: Text(msg),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
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
        toastification.show(
          title: const Text('Error'),
          description: const Text('Payment URL not received'),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      final msg = cleanErrorMessage(e);
      if (msg != 'offline') {
        toastification.show(
          title: const Text('Error'),
          description: Text(msg),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
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
        toastification.show(
          title: const Text('Error'),
          description: const Text('Payment URL not received'),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }

    } catch (e) {
      final msg = cleanErrorMessage(e);
      if (msg != 'offline') {
        toastification.show(
          title: const Text('Error'),
          description: Text(msg),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
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
        toastification.show(
          title: const Text('Success'),
          description: const Text('Subscription cancelled successfully'),
          style: ToastificationStyle.fillColored, type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 4),
        );

        // Refresh subscription status to update UI immediately
        await fetchSubscriptionStatus();

        // Optional: refresh profile if subscription affects other data
        // await fetchProfileData();
      } else {
        toastification.show(
          title: const Text('Failed'),
          description: const Text('Could not cancel subscription. Please try again later.'),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      final msg = cleanErrorMessage(e);
      if (msg != 'offline') {
        toastification.show(
          title: const Text('Error'),
          description: Text(msg),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Redirect to website subscription page with login token
  Future<void> redirectToWebSubscription() async {
    try {
      isLoading.value = true;

      final token = await _settingService.getLoginToken();

      if (token != null && token.isNotEmpty) {
        final url = 'https://nuweli.com/subscription?token=$token';
        Get.to(() => SimpleWebViewPage(url: url, buttonTitle: '', showAppBar: false));
      } else {
        toastification.show(
          title: const Text('Error'),
          description: const Text('Could not get access token. Please try again.'),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      final msg = cleanErrorMessage(e);
      if (msg != 'offline') {
        toastification.show(
          title: const Text('Error'),
          description: Text(msg),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
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



    toastification.show(
      title: const Text('Success'),
      description: const Text('You have been signed out'),
      style: ToastificationStyle.fillColored, type: ToastificationType.success,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }
}