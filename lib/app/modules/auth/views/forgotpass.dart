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
import 'login.dart';

class Forgotpassword extends StatelessWidget {
  Forgotpassword({super.key});
  final Authcontroller controller = Get.find();
  final TextEditingController c1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.frompage.value = "forgot_password";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h),
            Text(
              'forgot_password_title'.tr,
              style: AppTextStyles.montserratRegular.copyWith(
                fontSize: 25.sp,
                color: AppColor.white,
                letterSpacing: 0.8.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'forgot_subtitle'.tr,
              style: AppTextStyles.montserratMedium.copyWith(
                fontSize: 14.4.sp,
                color: AppColor.mediumGrey,
                letterSpacing: 0.8.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Text(
              'email'.tr,
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 6.h),
            InputTextWidget(
              controller: c1,
              hintText: 'enter_email_or_phone'.tr,
              onChanged: (value) {},
              hintfontWeight: FontWeight.w400,
              backgroundColor: AppColor.customDarkGray2,
              borderColor: const Color(0xFF404040),
              textColor: Colors.white,
              hintTextColor: Colors.white,
              borderRadius: 6.0,
              height: 30.h,
            ),
            SizedBox(height: 20.h),
            Obx(() => CustomButton(
              onPress: () async {
                controller.resetPasswordRequest(c1.text.trim());
              },
              title: 'send'.tr,
              loading: controller.isLoadingpass.value,
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
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'remember_password'.tr,
                  style: TextStyle(
                    color: AppColor.mediumGrey,
                    fontSize: 14.sp,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.offAll(Login(), transition: Transition.leftToRight);
                  },
                  child: Text(
                    'login_link'.tr,
                    style: TextStyle(
                      color: AppColor.sunnyYellow,
                      fontSize: 14.sp,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 35.h),
          ],
        ),
      ),
    );
  }
}