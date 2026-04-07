import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:Nuweli/app/bindings/initialbindings.dart';
import 'package:Nuweli/app/services/push_notification.dart';
import 'package:Nuweli/app/modules/auth/views/verifiedpage.dart';
import 'package:Nuweli/app/modules/home/views/navbar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../constants/appconstant.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../../home/controllers/comingsoon_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/controllers/navcontroller.dart';
import '../../onboard/controllers/onboard_controller.dart';
import '../../settings/controllers/bottomsheetController.dart';
import '../../settings/controllers/settingcontroller.dart';
import '../api_services/api_services.dart';
import '../models/login_model.dart';
import '../models/signup_models.dart';
import '../views/changepass.dart';
import '../views/otp.dart';
import '../../../utils/error_helper.dart';

class Authcontroller extends GetxController {
  RxBool ischecked = false.obs;
  final storage = GetStorage();
  final RxString frompage = "".obs;
  final firstnamecontroller = TextEditingController();
  final lastnamecontroller = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  final isLoading = false.obs;
  final isLoadingsignup = false.obs;
  final isLoadingpass = false.obs;
  final isLoadingverify = false.obs;
  final isLoadingresend = false.obs;
  final isLoadingnewpass = false.obs;
  final isloadinggmail = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID']);
  final String _baseUrl = AppConstants.baseUrl;
  final logger = Logger();
  final _authProvider = AuthProvider();
  String registeredEmail = '';

  // Password strength observables
  final RxBool hasMinLength = false.obs;
  final RxBool hasUppercase = false.obs;
  final RxBool hasLowercase = false.obs;
  final RxBool hasDigit = false.obs;
  final RxBool hasSpecial = false.obs;

  void validatePassword(String password) {
    hasMinLength.value = password.length >= 6;
    hasUppercase.value = RegExp(r'[A-Z]').hasMatch(password);
    hasLowercase.value = RegExp(r'[a-z]').hasMatch(password);
    hasDigit.value = RegExp(r'[0-9]').hasMatch(password);
    hasSpecial.value = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  bool get isPasswordStrong =>
      hasMinLength.value && hasUppercase.value && hasLowercase.value && hasDigit.value && hasSpecial.value;

  @override
  void onInit() async {
    super.onInit();
    await _authProvider.refreshAccessToken();
    final savedEmail = storage.read<String>('email');
    final savedPassword = storage.read<String>('password');
    if (savedEmail != null && savedPassword != null) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      ischecked.value = true;
    }
  }

  void _validateInputs({required bool isLogin}) {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPass = confirmpasswordController.text.trim();
    final firstname = firstnamecontroller.text.trim();
    final lastname = lastnamecontroller.text.trim();

    if (email.isEmpty) throw 'email_empty'.tr;
    if (!email.contains('@')) throw 'invalid_email'.tr;
    if (password.isEmpty) throw 'password_empty'.tr;
    if (isLogin) return;
    if (firstname.isEmpty) throw 'name_empty'.tr;
    if (lastname.isEmpty) throw 'name_empty'.tr;
    if (confirmPass.isEmpty) throw 'confirm_password_empty'.tr;
    if (password != confirmPass) throw 'passwords_not_match'.tr;
    if (!isPasswordStrong) throw 'password_not_strong'.tr;
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        toastification.show(
          title: Text('google_login_cancelled'.tr, style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
          description: Text('google_login_cancelled_msg'.tr, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
        return;
      }

      final String email = account.email;
      isloadinggmail.value = true;

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/google_login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "login_secret": "^sa@!24l425\$fZa#32f|\$"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final box = GetStorage();
        if (data['refresh'] != null) box.write('refreshToken', data['refresh']);
        if (data['access'] != null) box.write('loginToken', data['access']);

        toastification.show(
          title: Text('Success', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
          description: Text('google_login_success'.tr, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
          style: ToastificationStyle.fillColored, type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
        );

        Get.offAll(() => Navbar(), binding: BindingsBuilder(() {
          Get.delete<Authcontroller>(force: true);
          Get.delete<HomeController>(force: true);
          Get.delete<NavController>(force: true);
          Get.delete<OnboardController>(force: true);
          Get.delete<BottomSheetController>(force: true);
          Get.delete<Settingcontroller>(force: true);
          Get.delete<ComingSoonController>(force: true);
          InitialBinding().dependencies();
        }), transition: Transition.rightToLeft);
      } else {
        toastification.show(
          title: Text('Error', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
          description: Text('HTTP ${response.statusCode}', style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      final msg = cleanErrorMessage(e);
      if (msg != 'offline') {
        toastification.show(
          title: Text('Error', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
          description: Text(msg, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } finally {
      isloadinggmail.value = false;
    }
  }
  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = fb.OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      await fb.FirebaseAuth.instance.signInWithCredential(oauthCredential);

      final email = credential.email ?? '';
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/apple_login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "login_secret": "^sa@!24l425\$fZa#32f|\$"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final box = GetStorage();
        if (data['refresh'] != null) box.write('refreshToken', data['refresh']);
        if (data['access'] != null) box.write('loginToken', data['access']);

        toastification.show(
          title: Text('Success', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
          description: Text('google_login_success'.tr, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
          style: ToastificationStyle.fillColored, type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
        );

        Get.offAll(() => Navbar(), binding: BindingsBuilder(() {
          Get.delete<Authcontroller>(force: true);
          Get.delete<HomeController>(force: true);
          Get.delete<NavController>(force: true);
          Get.delete<OnboardController>(force: true);
          Get.delete<BottomSheetController>(force: true);
          Get.delete<Settingcontroller>(force: true);
          Get.delete<ComingSoonController>(force: true);
          InitialBinding().dependencies();
        }), transition: Transition.rightToLeft);
      } else {
        toastification.show(
          title: Text('Error', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
          description: Text('HTTP ${response.statusCode}', style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        ); }
    } catch (e) {
      final msg = cleanErrorMessage(e);
      if (msg != 'offline') {
        toastification.show(title: const Text('Error'), description: Text(msg), style: ToastificationStyle.fillColored, type: ToastificationType.error, autoCloseDuration: const Duration(seconds: 3));
      }
    }
  }
  Future<void> login() async {
    try {
      _validateInputs(isLogin: true);
      isLoading.value = true;

      final user = UserModel(email: emailController.text.trim(), password: passwordController.text.trim());
      final success = await _authProvider.login(user);

      if (success) {
        if (ischecked.value) {
          storage.write('email', user.email);
          storage.write('password', user.password);
        } else {
          storage.remove('email');
          storage.remove('password');
        }

        toastification.show(
          title: Text('Success', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
          description: Text('login_success'.tr, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
          style: ToastificationStyle.fillColored, type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
        );

        Get.offAll(() => Navbar(), binding: BindingsBuilder(() {
          Get.delete<Authcontroller>(force: true);
          Get.delete<HomeController>(force: true);
          Get.delete<NavController>(force: true);
          Get.delete<OnboardController>(force: true);
          Get.delete<BottomSheetController>(force: true);
          Get.delete<Settingcontroller>(force: true);
          Get.delete<ComingSoonController>(force: true);
          InitialBinding().dependencies();
        }), transition: Transition.rightToLeft);
        print("done");
        await initFCM();

      } else {
        throw 'login_timed_out'.tr;
      }
    } catch (e) {
      final msg = cleanErrorMessage(e);
      toastification.show(
        title: Text('Error', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
        description: Text(msg, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
        style: ToastificationStyle.fillColored, type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    try {
      _validateInputs(isLogin: false);
      isLoadingsignup.value = true;

      final newuser = SignupModel(
        firstName: firstnamecontroller.text.trim(),
        lastName: lastnamecontroller.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        country: countryController.text.trim(),
      );

      final success = await _authProvider.register(newuser);

      if (success) {
        registeredEmail = newuser.email;
        toastification.show(
          title: Text('Success', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
          description: Text('otp_sent_success'.tr, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
          style: ToastificationStyle.fillColored, type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
        );
        Get.offAll(Otpverifications(email: emailController.text.trim(), fromPage: frompage.value));
      } else {
        throw 'registration_failed'.tr;
      }
    } catch (e) {
      final msg = cleanErrorMessage(e);
      toastification.show(
        title: Text('Error', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
        description: Text(msg, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
        style: ToastificationStyle.fillColored, type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingsignup.value = false;
    }
  }

  Future<void> activateAccount(String otp) async {
    if (otp.length != 4) {
      toastification.show(title: Text('Error', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
          description: Text('invalid_otp'.tr, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
          style: ToastificationStyle.fillColored, type: ToastificationType.error, autoCloseDuration: const Duration(seconds: 3));
      return;
    }

    try {
      isLoadingverify.value = true;

      bool success;
      if (frompage.value == "signup") {
        success = await _authProvider.activateAccount(registeredEmail, otp);
        if (success) {
          toastification.show(title: Text('Success', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
              description: Text('account_activated'.tr, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
              style: ToastificationStyle.fillColored, type: ToastificationType.success, autoCloseDuration: const Duration(seconds: 3));
          Get.offAll(() => Verifiedpage(page: frompage.value));
        } else {
          throw 'activation_failed'.tr;
        }
      } else {
        success = await _authProvider.otpActivate(registeredEmail, otp);
        if (success) {
          toastification.show(title: Text('Success', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
              description: Text('password_reset_success'.tr, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
              style: ToastificationStyle.fillColored, type: ToastificationType.success, autoCloseDuration: const Duration(seconds: 3));
          Get.offAll(Changepass(), transition: Transition.rightToLeft);
        } else {
          throw 'activation_failed'.tr;
        }
      }
    } catch (e) {
      final msg = cleanErrorMessage(e);
      toastification.show(title: Text('Error', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
          description: Text(msg, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
          style: ToastificationStyle.fillColored, type: ToastificationType.error, autoCloseDuration: const Duration(seconds: 3));
    } finally {
      isLoadingverify.value = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      isLoadingresend.value = true;
      final success = await _authProvider.resendOtp(registeredEmail);
      if (success) {
        toastification.show(title: Text('OTP Sent', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
            description: Text('otp_resent'.tr, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
            style: ToastificationStyle.fillColored, type: ToastificationType.info, autoCloseDuration: const Duration(seconds: 3));
      } else {
        throw 'resend_failed'.tr;
      }
    } catch (e) {
      final msg = cleanErrorMessage(e);
      toastification.show(title: Text('Error', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
          description: Text(msg, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
          style: ToastificationStyle.fillColored, type: ToastificationType.error, autoCloseDuration: const Duration(seconds: 3));
    } finally {
      isLoadingresend.value = false;
    }
  }

  Future<void> resetPasswordRequest(String email) async {
    try {
      isLoadingpass.value = true;
      registeredEmail = email;
      final success = await _authProvider.resetPassword(registeredEmail);
      if (success) {
        toastification.show(title: Text('OTP Sent', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
            description: Text('otp_sent_reset'.tr, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
            style: ToastificationStyle.fillColored, type: ToastificationType.info, autoCloseDuration: const Duration(seconds: 3));
        Get.off(Otpverifications(email: email, fromPage: "forgot_password"), transition: Transition.rightToLeftWithFade);
      } else {
        throw 'reset_request_failed'.tr;
      }
    } catch (e) {
      final msg = cleanErrorMessage(e);
      toastification.show(title: Text('Error', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
          description: Text(msg, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
          style: ToastificationStyle.fillColored, type: ToastificationType.error, autoCloseDuration: const Duration(seconds: 3));
    } finally {
      isLoadingpass.value = false;
    }
  }

  Future<void> setNewPassword() async {
    emailController.text = registeredEmail;
    _validateInputs(isLogin: true);

    try {
      isLoadingnewpass.value = true;
      final success = await _authProvider.setNewPassword(registeredEmail, passwordController.text.trim());
      if (success) {
        toastification.show(title: Text('Success', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
            description: Text('password_reset_done'.tr, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
            style: ToastificationStyle.fillColored, type: ToastificationType.success, autoCloseDuration: const Duration(seconds: 3));
        Get.offAll(Verifiedpage(page: "forgot_password"), transition: Transition.rightToLeft);
      } else {
        throw 'Password reset failed';
      }
    } catch (e) {
      final msg = cleanErrorMessage(e);
      toastification.show(title: Text('Error', style: AppTextStyles.montserratBold.copyWith(color: AppColor.background)),
          description: Text(msg, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background)),
          style: ToastificationStyle.fillColored, type: ToastificationType.error, autoCloseDuration: const Duration(seconds: 3));
    } finally {
      isLoadingnewpass.value = false;
    }
  }
}