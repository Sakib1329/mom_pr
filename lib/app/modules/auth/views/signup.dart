import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Nuweli/app/modules/auth/controllers/authcontroller.dart';
import 'package:Nuweli/app/modules/auth/views/login.dart';
import 'package:Nuweli/app/modules/settings/controllers/settingcontroller.dart';
import 'package:Nuweli/app/modules/settings/views/termsandcondition.dart';
import 'package:Nuweli/app/res/colors/color.dart';
import 'package:Nuweli/app/res/fonts/fonts.dart';
import '../../../res/assets/imageassets.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/input_text_widget.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final Authcontroller controller = Get.find<Authcontroller>();
  final Settingcontroller settingcontroller = Get.put(Settingcontroller());

  void _showCountryPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        controller.countryController.text = country.name;
      },
      countryListTheme: CountryListThemeData(
        backgroundColor: AppColor.darkCharcoal,
        flagSize: 25.w,
        bottomSheetHeight: 500.h,
        textStyle: AppTextStyles.montserratRegular.copyWith(
          color: Colors.white,
          fontSize: 12.sp,
        ),
        searchTextStyle: AppTextStyles.montserratRegular.copyWith(
          color: Colors.white,
          fontSize: 12.sp,
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          labelStyle: AppTextStyles.montserratRegular.copyWith(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.vividAmber),
            borderRadius: BorderRadius.circular(8.r),
          ),
          hintText: 'Search country',
          hintStyle: AppTextStyles.montserratRegular.copyWith(color: Colors.white54),
          fillColor: Colors.grey[800],
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildStrengthIndicator(String text, bool isSatisfied) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(
            isSatisfied ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSatisfied ? AppColor.vividAmber : Colors.grey,
            size: 18.w,
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: AppTextStyles.montserratRegular.copyWith(
              color: isSatisfied ? AppColor.vividAmber : Colors.white70,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.frompage.value = "signup";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: SvgPicture.asset(
          'assets/icons/svg1.svg',
          height: 20.h,
          width: 20.w,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 6.h),
            Text(
              'create_account'.tr,
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 25.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            Text(
              'signup_subtitle'.tr,
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),

            // First & Last Name
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'first_name'.tr,
                        style: AppTextStyles.montserratRegular.copyWith(
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      InputTextWidget(
                        controller: controller.firstnamecontroller,
                        hintText: 'first_name'.tr,
                        onChanged: (value) {},
                        backgroundColor: AppColor.customDarkGray2,
                        borderColor: const Color(0xFF404040),
                        textColor: Colors.white,
                        hintTextColor: Colors.white,
                        borderRadius: 6.0,
                        height: 40.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'last_name'.tr,
                        style: AppTextStyles.montserratRegular.copyWith(
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      InputTextWidget(
                        controller: controller.lastnamecontroller,
                        hintText: 'last_name'.tr,
                        onChanged: (value) {},
                        backgroundColor: AppColor.customDarkGray2,
                        borderColor: const Color(0xFF404040),
                        textColor: Colors.white,
                        hintTextColor: Colors.white,
                        borderRadius: 6.0,
                        height: 40.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            // Email
            Text(
              'email'.tr,
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 6.h),
            InputTextWidget(
              controller: controller.emailController,
              hintText: 'email'.tr,
              onChanged: (value) {},
              leading: true,
              leadingIcon: ImageAssets.svg13,
              backgroundColor: AppColor.customDarkGray2,
              borderColor: const Color(0xFF404040),
              textColor: Colors.white,
              hintTextColor: Colors.white,
              borderRadius: 6.0,
              height: 40.0,
            ),
            SizedBox(height: 14.h),

            // Password
            Text(
              'password'.tr,
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 6.h),
            InputTextWidget(
              controller: controller.passwordController,
              hintText: 'enter_password'.tr,
              onChanged: (value) {
                controller.validatePassword(value);
              },
              obscureText: true,
              passwordIcon: ImageAssets.obsecure,
              backgroundColor: AppColor.customDarkGray2,
              borderColor: const Color(0xFF404040),
              textColor: Colors.white,
              hintTextColor: Colors.white,
              borderRadius: 6.0,
              height: 40.0,
            ),

            // Password Strength
            Obx(() => Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password must contain:',
                    style: AppTextStyles.montserratRegular.copyWith(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildStrengthIndicator('At least 6 characters', controller.hasMinLength.value),
                  _buildStrengthIndicator('One uppercase letter', controller.hasUppercase.value),
                  _buildStrengthIndicator('One lowercase letter', controller.hasLowercase.value),
                  _buildStrengthIndicator('One number', controller.hasDigit.value),
                  _buildStrengthIndicator('One special character (!@#\$ etc.)', controller.hasSpecial.value),
                ],
              ),
            )),

            SizedBox(height: 4.h),

            // Confirm Password
            Text(
              'confirm_password'.tr,
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 6.h),
            InputTextWidget(
              controller: controller.confirmpasswordController,
              hintText: 'confirm_password'.tr,
              onChanged: (value) {
                controller.validatePassword(controller.passwordController.text);
              },
              obscureText: true,
              backgroundColor: AppColor.customDarkGray2,
              borderColor: const Color(0xFF404040),
              textColor: Colors.white,
              hintTextColor: Colors.white,
              borderRadius: 6.0,
              height: 40.0,
            ),
            SizedBox(height: 14.h),

            // Country
            Text(
              'country'.tr,
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 6.h),
            InputTextWidget(
              controller: controller.countryController,
              hintText: 'select_country'.tr,
              onChanged: (value) {},
              readOnly: true,
              onTap: () => _showCountryPicker(context),
              backimageadd: true,
              backimage: ImageAssets.svg14,
              backgroundColor: AppColor.customDarkGray2,
              borderColor: const Color(0xFF404040),
              textColor: Colors.white,
              hintTextColor: Colors.white,
              borderRadius: 6.0,
              height: 40.0,
            ),
            SizedBox(height: 14.h),

            // Terms & Conditions
            Obx(() => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 18.w,
                  height: 18.h,
                  child: Checkbox(
                    value: controller.ischecked.value,
                    onChanged: (value) {
                      controller.ischecked.value = value ?? false;
                    },
                    fillColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color(0xFFFFD700);
                      }
                      return Colors.transparent;
                    }),
                    checkColor: Colors.black,
                    side: const BorderSide(color: Color(0xFF404040)),
                  ),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'terms_prefix'.tr,
                          style: AppTextStyles.montserratRegular.copyWith(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                        TextSpan(
                          text: 'terms_conditions'.tr,
                          style: AppTextStyles.montserratMedium.copyWith(
                            color: const Color(0xFFFFD700),
                            fontSize: 12.sp,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              await settingcontroller.loadPrivacyPolicy();
                              Get.to(Privacypolicy(), transition: Transition.rightToLeft);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
            SizedBox(height: 20.h),

            // Create Account Button
            Obx(() => CustomButton(
              onPress: () async {
                if (controller.ischecked.value) {
                  await controller.register();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please agree to Terms & conditions',
                        style: AppTextStyles.montserratRegular.copyWith(color: AppColor.background),
                      ),
                      backgroundColor: AppColor.vividAmber,
                    ),
                  );
                }
              },
              title: 'create_account_btn'.tr,
              loading: controller.isLoadingsignup.value,
              textColor: Colors.black,
              gradient: LinearGradient(
                colors: [AppColor.vividAmber, AppColor.sunnyYellow],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              width: double.infinity,
              height: 30.h,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            )),
            SizedBox(height: 14.h),

            // OR Divider
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[600], height: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    'OR',
                    style: AppTextStyles.montserratRegular.copyWith(
                      color: Colors.white,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey[600], height: 1)),
              ],
            ),
            SizedBox(height: 14.h),

            // Social Login
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(1.5.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColor.vividAmber, AppColor.sunnyYellow],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(9.r),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                        color: AppColor.customDarkGray2,
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: SvgPicture.asset(ImageAssets.svg15),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      color: AppColor.customDarkGray2,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: SvgPicture.asset(ImageAssets.svg16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),

            // Already have account
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'already_have_account'.tr,
                      style: AppTextStyles.montserratRegular.copyWith(
                        color: AppColor.mediumGrey,
                        fontSize: 14.sp,
                      ),
                    ),
                    TextSpan(
                      text: 'log_in_link'.tr,
                      style: AppTextStyles.montserratMedium.copyWith(
                        color: AppColor.sunnyYellow,
                        fontSize: 14.sp,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(() => Login(), transition: Transition.rightToLeftWithFade);
                        },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}