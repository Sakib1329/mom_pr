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
import 'login.dart';

class Verifiedpage extends StatelessWidget {
  final String page;
  const Verifiedpage({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        Get.offAll(Login(), transition: Transition.leftToRight);
      });
    });
    return WillPopScope(
      onWillPop: ()async=>false,
      child: Scaffold(
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                ImageAssets.svg18,

                color: AppColor.sunnyYellow,
              ),
              Text(
                page=="signup"
                ?'Sign up\nsuccessfully'
                :"Password changed Successfully",
                style: AppTextStyles.montserratRegular.copyWith(
                  color: Colors.white,
                  fontSize: 30.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
