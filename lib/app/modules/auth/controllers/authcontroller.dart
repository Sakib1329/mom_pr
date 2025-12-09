import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:Nuweli/app/bindings/initialbindings.dart';
import 'package:Nuweli/app/services/push_notification.dart';
import 'package:Nuweli/app/modules/auth/views/verifiedpage.dart';
import 'package:Nuweli/app/modules/home/views/home.dart';
import 'package:Nuweli/app/modules/home/views/navbar.dart';
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
import '../views/login.dart';
import '../views/otp.dart';

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
  final GoogleSignIn _googleSignIn = GoogleSignIn(serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],);
  final String _baseUrl = AppConstants.baseUrl;
  final logger = Logger();
  final isloadinggmail = false.obs;
  final _authProvider = AuthProvider();
  String registeredEmail = '';

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

    if (email.isEmpty) {
      throw 'Email cannot be empty';
    }
    if (!email.contains('@')) {
      throw 'Invalid email format';
    }
    if (password.isEmpty) {
      throw 'Password cannot be empty';
    }
    if (isLogin) {
      return;
    }
    if (firstname.isEmpty) {
      throw 'Name cannot be empty';
    }
    if (lastname.isEmpty) {
      throw 'Name cannot be empty';
    }
    if (confirmPass.isEmpty) {
      throw 'Confirm password cannot be empty';
    }
    if (password != confirmPass) {
      throw 'Passwords do not match';
    }
    if (password.length < 6) {
      throw 'Password must be at least 6 characters';
    }
  }

  Future<void> signInWithGoogle() async {
    try {

      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      print("hello");
      print(account);
      if (account == null) {
        Get.snackbar(
          'Google Login Cancelled',
          'Google login was cancelled',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          titleText: Text(
            'Google Login Cancelled',
            style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
          ),
          messageText: Text(
            'Google login was cancelled',
            style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
          ),
        );
        return;
      }
print("hello");
      final String email = account.email;
      isloadinggmail.value = true;
print(email);
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/google_login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({ "email": email,"login_secret": "^sa@!24l425\$fZa#32f|\$"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final box = GetStorage();
        if (data['refresh'] != null) {
          box.write('refreshToken', data['refresh']);
        }
        if (data['access'] != null) {
          box.write('loginToken', data['access']);
        }

        Get.snackbar(
          'Success',
          'Google login successful',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColor.vividAmber,
          titleText: Text(
            'Success',
            style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
          ),
          messageText: Text(
            'Google login successful',
            style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
          ),
        );
        Get.offAll(
              () => Navbar(),
          binding: BindingsBuilder(() {
            // Remove old controllers
            Get.delete<Authcontroller>(force: true);
            Get.delete<HomeController>(force: true);
            Get.delete<NavController>(force: true);
            Get.delete<OnboardController>(force: true);
            Get.delete<BottomSheetController>(force: true);
            Get.delete<Settingcontroller>(force: true);
            Get.delete<ComingSoonController>(force: true);

            // Re-initialize all
            InitialBinding().dependencies();
          }),
          transition: Transition.rightToLeft,
        );
      } else {
        Get.snackbar(
          'Error',
          'Google login failed: ${response.body}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          titleText: Text(
            'Error',
            style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
          ),
          messageText: Text(
            'Google login failed: ${response.body}',
            style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
          ),
        );
      }
    } catch (e) {

      Get.snackbar(
        'Exception',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        titleText: Text(
          'Exception',
          style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
        ),
        messageText: Text(
          'An error occurred: $e',
          style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
        ),
      );
      print(e.toString());
    } finally {
      isloadinggmail.value = false;
    }
  }

  Future<void> login() async {
    try {
      _validateInputs(isLogin: true);
      isLoading.value = true;

      final user = UserModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final success = await _authProvider.login(user);

      if (success) {
        if (ischecked.value) {
          storage.write('email', user.email);
          storage.write('password', user.password);
        } else {
          storage.remove('email');
          storage.remove('password');
        }

        Get.snackbar(
          'Success',
          'Login successful',
          backgroundColor: AppColor.vividAmber,
          snackPosition: SnackPosition.TOP,
          titleText: Text(
            'Success',
            style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
          ),
          messageText: Text(
            'Login successful',
            style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
          ),
        );

        Get.offAll(
              () => Navbar(),
          binding: BindingsBuilder(() {
            // Remove old controllers
            Get.delete<Authcontroller>(force: true);
            Get.delete<HomeController>(force: true);
            Get.delete<NavController>(force: true);
            Get.delete<OnboardController>(force: true);
            Get.delete<BottomSheetController>(force: true);
            Get.delete<Settingcontroller>(force: true);
            Get.delete<ComingSoonController>(force: true);

            // Re-initialize all
            InitialBinding().dependencies();
          }),
          transition: Transition.rightToLeft,
        );
        await initFCM();
      } else {
        throw 'Login timed out';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColor.customDodgerBlue,
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          'Error',
          style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
        ),
        messageText: Text(
          e.toString(),
          style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
        ),
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
        password: passwordController.text.trim(), country: countryController.text.trim(),
      );

      final success = await _authProvider.register(newuser);

      if (success) {
        registeredEmail = newuser.email;
        Get.snackbar(
          'Success',
          'A',
          backgroundColor: AppColor.customDodgerBlue,
          snackPosition: SnackPosition.TOP,
          titleText: Text(
            'Success',
            style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
          ),
          messageText: Text(
            'An OTP has been sent to your email address. Please check your inbox',
            style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
          ),
        );
        Get.offAll(Otpverifications(email: emailController.value.text.trim(), fromPage: frompage.value));
      } else {
        throw 'Registration failed';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColor.customDodgerBlue,
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          'Error',
          style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
        ),
        messageText: Text(
          e.toString(),
          style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
        ),
      );
    } finally {
      isLoadingsignup.value = false;
    }
  }

  Future<void> activateAccount(String otp) async {
    if (otp.length != 4) {
      Get.snackbar(
        'Error',
        'Invalid OTP',
        backgroundColor: AppColor.customDodgerBlue,
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          'Error',
          style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
        ),
        messageText: Text(
          'Invalid OTP',
          style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
        ),
      );
      return;
    }

    try {
      isLoadingverify.value = true;

      if (frompage.value == "signup") {
        final success = await _authProvider.activateAccount(registeredEmail, otp);
        if (success) {
          Get.snackbar(
            'Success',
            'Account activated successfully',
            backgroundColor: AppColor.customDodgerBlue,
            snackPosition: SnackPosition.TOP,
            titleText: Text(
              'Success',
              style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
            ),
            messageText: Text(
              'Account activated successfully',
              style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
            ),
          );
          Get.offAll(() => Verifiedpage(page: frompage.value));
        } else {
          throw 'Account activation failed';
        }
      } else {
        final success = await _authProvider.otpActivate(registeredEmail, otp);
        if (success) {
          Get.snackbar(
            'Success',
            'Password reset successful',
            backgroundColor: AppColor.customDodgerBlue,
            snackPosition: SnackPosition.TOP,
            titleText: Text(
              'Success',
              style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
            ),
            messageText: Text(
              'Password reset successful',
              style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
            ),
          );
          Get.offAll(Changepass(),transition: Transition.rightToLeft);
        } else {
          throw 'Account activation failed';
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColor.customDodgerBlue,
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          'Error',
          style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
        ),
        messageText: Text(
          e.toString(),
          style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
        ),
      );
    } finally {
      isLoadingverify.value = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      isLoadingresend.value = true;

      final success = await _authProvider.resendOtp(registeredEmail);

      if (success) {
        Get.snackbar(
          'OTP Sent',
          'Check your email for the OTP',
          backgroundColor: AppColor.customDodgerBlue,
          snackPosition: SnackPosition.TOP,
          titleText: Text(
            'OTP Sent',
            style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
          ),
          messageText: Text(
            'Check your email for the OTP',
            style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
          ),
        );
      } else {
        throw 'Failed to resend OTP';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColor.customDodgerBlue,
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          'Error',
          style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
        ),
        messageText: Text(
          e.toString(),
          style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
        ),
      );
    } finally {
      isLoadingresend.value = false;
    }
  }

  Future<void> resetPasswordRequest(String email) async {
    try {
      isLoadingpass.value = true;
      registeredEmail=email;
      final success = await _authProvider.resetPassword(registeredEmail);

      if (success) {
        Get.snackbar(
          'OTP Sent',
          'OTP sent for password reset',
          backgroundColor: AppColor.customDodgerBlue,
          snackPosition: SnackPosition.TOP,
          titleText: Text(
            'OTP Sent',
            style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
          ),
          messageText: Text(
            'OTP sent for password reset',
            style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
          ),
        );
        Get.off(Otpverifications(email: email, fromPage: "forgot_password"),transition: Transition.rightToLeftWithFade);
      } else {
        throw 'Password reset request failed';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColor.customDodgerBlue,
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          'Error',
          style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
        ),
        messageText: Text(
          e.toString(),
          style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
        ),
      );
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
        Get.snackbar(
          'Success',
          'Password reset successfully',
          backgroundColor: AppColor.customDodgerBlue,
          snackPosition: SnackPosition.TOP,
          titleText: Text(
            'Success',
            style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
          ),
          messageText: Text(
            'Password reset successfully',
            style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
          ),
        );
        Get.offAll(Verifiedpage(page: "forgot_password",),transition: Transition.rightToLeft);
      } else {
        throw 'Password reset failed';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColor.customDodgerBlue,
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          'Error',
          style: AppTextStyles.montserratBold.copyWith(color: AppColor.background),
        ),
        messageText: Text(
          e.toString(),
          style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
        ),
      );
    } finally {
      isLoadingnewpass.value = false;
    }
  }
}