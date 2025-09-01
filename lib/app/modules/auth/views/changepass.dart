import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mompr_em/app/modules/auth/views/otp.dart';
import 'package:mompr_em/app/modules/auth/views/verifiedpage.dart';

import '../../../res/assets/imageassets.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/input_text_widget.dart';
import '../controllers/authcontroller.dart';
import 'login.dart';

class Changepass extends StatelessWidget {
  Changepass({super.key});
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
          horizontal: 15.w,
        ), // Reduced from 20.w to 16.w
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h), // Reduced from 20.h to 16.h
            // Reduced from 20.h to 16.h
            Text(
              'Set new password',
              style: AppTextStyles.montserratRegular.copyWith(
                fontSize: 25.sp, // Reduced from 28.sp to 22.4.sp
                color: AppColor.white,
                letterSpacing: 0.8.sp, // Reduced from 1.sp to 0.8.sp
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h), // Reduced from 10.h to 8.h
            Text(
              'Secure your account with a new password',
              style: AppTextStyles.montserratMedium.copyWith(
                fontSize: 14.sp, // Reduced from 18.sp to 14.4.sp
                color: AppColor.mediumGrey,
                letterSpacing: 0.8.sp, // Reduced from 1.sp to 0.8.sp
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h), // Reduced from 30.h to 24.h
            Text(
              'New Password',
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 6.h),
            InputTextWidget(

              hintText: 'Enter your new password',
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
              'Confirm Password',
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 6.h),
            InputTextWidget(

              hintText: 'Confirm  new password',
              onChanged: (value) {},
              obscureText: true,
              backgroundColor: AppColor.customDarkGray2,
              borderColor: const Color(0xFF404040),
              textColor: Colors.white,
              hintTextColor: Colors.white,
              borderRadius: 6.0,
              height: 40.0,
            ),
            SizedBox(height: 32.h), // Reduced from 40.h to 32.h
            CustomButton(
              onPress: () async {
                Get.offAll(Verifiedpage(page: "forgot_password",),transition: Transition.rightToLeft);
              },
              title: 'Reset Password',
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

          ],
        ),
      ),
    );
  }
}
