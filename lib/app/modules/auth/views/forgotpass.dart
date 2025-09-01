import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mompr_em/app/modules/auth/views/otp.dart';

import '../../../res/assets/imageassets.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/input_text_widget.dart';
import '../controllers/authcontroller.dart';
import 'login.dart';

class Forgotpassword extends StatelessWidget {
  Forgotpassword({super.key});
  final Authcontroller controller = Get.find();
  final TextEditingController c1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.fromPage.value = "forgot_password";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
   automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ), // Reduced from 20.w to 16.w
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h), // Reduced from 20.h to 16.h
            // Reduced from 20.h to 16.h
            Text(
              'Forgot password !',
              style: AppTextStyles.montserratRegular.copyWith(
                fontSize: 25.sp, // Reduced from 28.sp to 22.4.sp
                color: AppColor.white,
                letterSpacing: 0.8.sp, // Reduced from 1.sp to 0.8.sp
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h), // Reduced from 10.h to 8.h
            Text(
              'Enter your Email or phone number to reset your Password Quickly ',
              style: AppTextStyles.montserratMedium.copyWith(
                fontSize: 14.4.sp, // Reduced from 18.sp to 14.4.sp
                color: AppColor.mediumGrey,
                letterSpacing: 0.8.sp, // Reduced from 1.sp to 0.8.sp
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h), // Reduced from 30.h to 24.h
            Text(
              'Email',
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 6.h),
            InputTextWidget(
              controller: c1,
              hintText: 'Enter your Email or phone number',
              onChanged: (value) {},

              hintfontWeight: FontWeight.w400,


              backgroundColor: AppColor.customDarkGray2,
              borderColor: const Color(0xFF404040),
              textColor: Colors.white,
              hintTextColor: Colors.white,
              borderRadius: 6.0,
              height: 30.h,
            ),
            SizedBox(height: 20.h), // Reduced from 40.h to 32.h
            CustomButton(
              onPress: () async {
                Get.off(Otpverifications(email: c1.text.trim(), fromPage: "forgot_password"),transition: Transition.rightToLeftWithFade);
              },
              title: 'Send',
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
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Remember password?',
                  style: TextStyle(
                    color: AppColor.mediumGrey,
                    fontSize: 14.sp, // Reduced from 16.sp to 12.8.sp
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.offAll(Login(), transition: Transition.leftToRight);
                  },
                  child: Text(
                    ' Login',
                    style: TextStyle(
                      color: AppColor.sunnyYellow,
                      fontSize: 14.sp, // Reduced from 16.sp to 12.8.sp
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 35.h), // Reduced from 40.h to 32.h
          ],
        ),
      ),
    );
  }
}
