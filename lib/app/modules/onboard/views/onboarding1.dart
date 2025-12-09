import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Nuweli/app/modules/auth/views/login.dart';
import 'package:Nuweli/app/modules/auth/views/signup.dart';
import 'package:Nuweli/app/modules/onboard/controllers/onboard_controller.dart';

import '../../../res/assets/imageassets.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../../../widgets/custom_button.dart';

class Onboard1 extends StatelessWidget {
  final OnboardController controller = Get.find();
  Onboard1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            ImageAssets.img,
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
          ),

          // Overlay
          Container(color: Colors.black.withOpacity(0.1)),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 50.h),

                // Top-left logo
                Align(
                  alignment: Alignment.topLeft,
                  child: SvgPicture.asset(
                    'assets/icons/svg1.svg',
                    height: 20.h, // smaller but same UI scale
                    width: 20.w,
                  ),
                ),

                const Spacer(),

                // Title
                Text(
                  "Unlimited\n movies,TV\n shows & more",
                  style: AppTextStyles.montserratRegular.copyWith(
                    fontSize: 28.sp, // reduced size
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 15.h),

                // Subtitle
                Text(
                  "Watch anywhere.\n Cancel anytime.",
                  style: AppTextStyles.montserratRegular.copyWith(
                    fontSize: 18.sp, // reduced size
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40.h),

                // Button
                CustomButton(
                  onPress: () async => Get.to(Login(), transition: Transition.rightToLeft),
                  title: "Get Started",
                  height: 30.h, // smaller button
                  fontFamily: 'Sans',
                  fontWeight: FontWeight.bold,
                  textColor: AppColor.background,
                  width: double.infinity,
                  gradient: LinearGradient(
                    colors: [AppColor.vividAmber, AppColor.sunnyYellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
