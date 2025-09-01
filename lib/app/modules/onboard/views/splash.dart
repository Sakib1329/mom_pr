import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mompr_em/app/modules/onboard/controllers/onboard_controller.dart';

import '../../../res/assets/imageassets.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';

class SplashView extends StatelessWidget {

  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardController onboardController=Get.find();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SvgPicture.asset(ImageAssets.svg1,height: 60.h,)
          ),

        ],
      ),
    );
  }
}