import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Nuweli/app/modules/auth/controllers/authcontroller.dart';
import 'package:Nuweli/app/modules/auth/views/login.dart';
import 'package:Nuweli/app/modules/auth/views/verifiedpage.dart';
import 'package:Nuweli/app/modules/settings/controllers/settingcontroller.dart';
import 'package:Nuweli/app/modules/settings/views/termsandcondition.dart';
import 'package:Nuweli/app/res/colors/color.dart';
import 'package:Nuweli/app/res/fonts/fonts.dart';
import '../../../res/assets/imageassets.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/input_text_widget.dart';
import 'otp.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final Authcontroller controller = Get.find<Authcontroller>();
  final Settingcontroller settingcontroller=   Get.put(Settingcontroller());

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
            // Title
            Text(
              'Create an account',
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 25.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            // Subtitle
            Text(
              '"Begin your journey to understanding dreams today."',
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
                        'First name',
                        style: AppTextStyles.montserratRegular.copyWith(
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      InputTextWidget(
                        controller: controller.firstnamecontroller,
                        hintText: 'First name',
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
                        'Last name',
                        style: AppTextStyles.montserratRegular.copyWith(
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      InputTextWidget(
                        controller: controller.lastnamecontroller,
                        hintText: 'Last name',
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
              'Email',
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 6.h),
            InputTextWidget(
              controller: controller.emailController,
              hintText: 'Email',
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
              'Password',
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 6.h),
            InputTextWidget(
              controller: controller.passwordController,
              hintText: 'Enter your password',
              onChanged: (value) {},
              obscureText: true,
              passwordIcon: ImageAssets.obsecure,
              backgroundColor: AppColor.customDarkGray2,
              borderColor: const Color(0xFF404040),
              textColor: Colors.white,
              hintTextColor: Colors.white,
              borderRadius: 6.0,
              height: 40.0,
            ),
            SizedBox(height: 14.h),
            // Confirm Password
            Text(
              'Confirm password',
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 6.h),
            InputTextWidget(
              controller: controller.confirmpasswordController,
              hintText: 'Confirm password',
              onChanged: (value) {},
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
              'Country',
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 6.h),
            InputTextWidget(
              controller: controller.countryController,
              hintText: 'Select Country',
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
                          text: 'I agree to the ',
                          style: AppTextStyles.montserratRegular.copyWith(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                        TextSpan(
                          text: 'Terms & conditions',
                          style: AppTextStyles.montserratMedium.copyWith(
                            color: const Color(0xFFFFD700),
                            fontSize: 12.sp,
                            decoration: TextDecoration.underline
                          ),
                          recognizer: TapGestureRecognizer()..onTap =()async{
                            await settingcontroller.loadPrivacyPolicy();
                            Get.to(Privacypolicy(),transition: Transition.rightToLeft);
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
            SizedBox(height: 20.h),
            // Create Account Button
           Obx(()=> CustomButton(
             onPress: () async {
               if (controller.ischecked.value) {
                 print('Creating account...');
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
             title: 'Create account',
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
           ),),
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
                      text: 'Already have an account? ',
                      style: AppTextStyles.montserratRegular.copyWith(
                        color: AppColor.mediumGrey,
                        fontSize: 14.sp,
                      ),
                    ),
                    TextSpan(
                      text: 'Log in',
                      style: AppTextStyles.montserratMedium.copyWith(
                        color: AppColor.sunnyYellow,
                        fontSize: 14.sp,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(
                                () => Login(),
                            transition: Transition.rightToLeftWithFade,
                          );
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