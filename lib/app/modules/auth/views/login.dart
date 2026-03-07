import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Nuweli/app/modules/auth/views/forgotpass.dart';
import 'package:Nuweli/app/modules/auth/views/signup.dart';
import 'package:Nuweli/app/modules/home/views/navbar.dart';

import '../../../res/assets/imageassets.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/input_text_widget.dart';
import '../controllers/authcontroller.dart';

class Login extends StatelessWidget {
  final Authcontroller controller = Get.find();
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                'welcome_back'.tr,
                style: AppTextStyles.montserratRegular.copyWith(
                  color: Colors.white,
                  fontSize: 25.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.h),
              // Subtitle
              Text(
                'login_subtitle'.tr,
                style: AppTextStyles.montserratRegular.copyWith(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              // Email Label
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

              // Password Label
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
              SizedBox(height: 15.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(() => SizedBox(
                    width: 18.w,
                    height: 18.h,
                    child: Checkbox(
                      value: controller.ischecked.value,
                      onChanged: (value) {
                        controller.ischecked.toggle();
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
                  )),
                  SizedBox(width: 10.w),
                  Text(
                    "remember_me".tr,
                    style: AppTextStyles.montserratRegular.copyWith(
                      fontSize: 12.spMax,
                      color: AppColor.white,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Get.to(Forgotpassword(), transition: Transition.rightToLeftWithFade);
                    },
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColor.vividAmber, AppColor.sunnyYellow],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                      child: Text(
                        "forgot_password".tr,
                        style: AppTextStyles.montserratSemiBold.copyWith(
                          fontSize: 12.spMax,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.h),
              Obx(() => CustomButton(
                onPress: controller.login,
                loading: controller.isLoading.value,
                title: 'log_in'.tr,
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
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColor.greySoft,
                      thickness: 2,
                      endIndent: 10.w,
                    ),
                  ),
                  Text(
                    "or".tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.spMax,
                      fontFamily: 'Sans',
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColor.greySoft,
                      thickness: 2,
                      indent: 10.w,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await controller.signInWithGoogle();
                      },
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
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: ()async{
                    await controller.signInWithApple();
                    },
                      child: Container(
                        padding: EdgeInsets.all(15.w),
                        decoration: BoxDecoration(
                          color: AppColor.customDarkGray2,
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        child: SvgPicture.asset(ImageAssets.svg16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'no_account'.tr,
                        style: AppTextStyles.montserratRegular.copyWith(
                          color: AppColor.mediumGrey,
                          fontSize: 14.sp,
                        ),
                      ),
                      TextSpan(
                        text: 'sign_up'.tr,
                        style: AppTextStyles.montserratMedium.copyWith(
                            color: AppColor.sunnyYellow,
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => Signup(), transition: Transition.rightToLeftWithFade);
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}