import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mompr_em/app/modules/auth/controllers/authcontroller.dart';
import 'package:mompr_em/app/modules/auth/views/login.dart';
import 'package:mompr_em/app/modules/auth/views/verifiedpage.dart';
import 'package:mompr_em/app/res/colors/color.dart';
import 'package:mompr_em/app/res/fonts/fonts.dart';
import '../../../res/assets/imageassets.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/input_text_widget.dart';
import 'otp.dart';

class Signup extends StatefulWidget {
  Signup({super.key});

  @override
  State<Signup> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<Signup> {
  final Authcontroller controller = Get.find();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  bool _agreeToTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.fromPage.value = "signup";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        title: SvgPicture.asset(
          'assets/icons/svg1.svg',
          height: 35.h,
          width: 35.w,
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
                        controller: _firstNameController,
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
                        controller: _lastNameController,
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
              controller: _emailController,
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
              controller: _passwordController,
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
              controller: _confirmPasswordController,
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
              controller: _countryController,
              hintText: 'Select Country',
              onChanged: (value) {},
              readOnly: true,
              onTap: () => _showCountryPicker(),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 18.w,
                  height: 18.h,
                  child: Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreeToTerms = value ?? false;
                      });
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Create Account Button
            CustomButton(
              onPress: () async {
                if (_agreeToTerms) {
                  print('Creating account...');
                  Get.to(
                    Otpverifications(
                      email: _emailController.text.trim(),
                      fromPage: "signup",
                    ),
                    transition: Transition.rightToLeftWithFade,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please agree to Terms & conditions',
                        style: TextStyle(color: AppColor.background),
                      ),
                      backgroundColor: AppColor.vividAmber,
                    ),
                  );
                }
              },
              title: 'Create account',
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
            ),
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
                      onEnter: (event) {
                        Get.to(
                          Login(),
                          transition: Transition.rightToLeftWithFade,
                        );
                      },
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

  // Replace your current _showCountryPicker method with this:
  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          _countryController.text = country.name;
        });
      },
      countryListTheme: CountryListThemeData(
        backgroundColor: AppColor.darkCharcoal,
        flagSize: 25.w,
        bottomSheetHeight: 500.h,
        textStyle: AppTextStyles.montserratRegular.copyWith(
          color: Colors.white, // color of country list text
          fontSize: 12.sp,
        ),
        searchTextStyle: AppTextStyles.montserratRegular.copyWith(
          color: Colors.white, // <-- user typed text color
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

}
