import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/assets/imageassets.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/input_text_widget.dart';
import '../controllers/authcontroller.dart';

class Changepass extends StatelessWidget {
  Changepass({super.key});
  final Authcontroller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.frompage.value = "forgot_password";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h),
            Text(
              'set_new_password'.tr,
              style: AppTextStyles.montserratRegular.copyWith(
                fontSize: 25.sp,
                color: AppColor.white,
                letterSpacing: 0.8.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'secure_account'.tr,
              style: AppTextStyles.montserratMedium.copyWith(
                fontSize: 14.sp,
                color: AppColor.mediumGrey,
                letterSpacing: 0.8.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Text(
              'new_password'.tr,
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 6.h),
            InputTextWidget(
              controller: controller.passwordController,
              hintText: 'enter_new_password'.tr,
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

            Text(
              'confirm_new_password'.tr,
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 6.h),
            InputTextWidget(
              controller: controller.confirmpasswordController,
              hintText: 'confirm_new_password'.tr,
              onChanged: (value) {},
              obscureText: true,
              backgroundColor: AppColor.customDarkGray2,
              borderColor: const Color(0xFF404040),
              textColor: Colors.white,
              hintTextColor: Colors.white,
              borderRadius: 6.0,
              height: 40.0,
            ),
            SizedBox(height: 32.h),
            Obx(() => CustomButton(
              onPress: () => controller.setNewPassword(),
              title: 'reset_password'.tr,
              textColor: Colors.black,
              loading: controller.isLoadingnewpass.value,
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
            Spacer(),
          ],
        ),
      ),
    );
  }
}