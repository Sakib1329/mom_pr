import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Nuweli/app/modules/onboard/controllers/onboard_controller.dart';

import '../../../res/assets/imageassets.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../../../widgets/custom_button.dart';

class Onboarding2 extends StatelessWidget {
  final OnboardController controller = Get.find();
  Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/icons/svg1.svg',
          height: 20.h,
          width: 20.w,
        ),


      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 80.w),
        child: Column(
          children: [

            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(width: 120.h, child: Image.asset(ImageAssets.img_1)),
                    SizedBox(height: 5.h,),
                    Text("Emenalo",style: AppTextStyles.montserratRegular.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.w500

                    ),)
                  ],
                ),
                Column(
                  children: [
                    SizedBox(width: 120.h, child: Image.asset(ImageAssets.img_2)),
                    SizedBox(height: 5.h,),
                    Text("Onyeka",style: AppTextStyles.montserratRegular.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.w500

                    ),)
                  ],
                ),
              ],
            ),
            SizedBox(height: 40.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(width: 120.h, child: Image.asset(ImageAssets.img_3)),
                    SizedBox(height: 5.h,),
                    Text("Thelma",style: AppTextStyles.montserratRegular.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.w500

                    ),)
                  ],
                ),
                Column(
                  children: [
                    SizedBox(width: 120.h, child: Image.asset(ImageAssets.img_4)),
                    SizedBox(height: 5.h,),
                    Text("Kids",style: AppTextStyles.montserratRegular.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.w500

                    ),)
                  ],
                ),
              ],
            ),
            SizedBox(height: 60.h,),
            Row(
              children: [
                Column(
                  children: [
                    SizedBox(width: 120.h, child: SvgPicture.asset(ImageAssets.svg2,height: 60.h
                      ,)),
                    SizedBox(height: 20.h,),
                    Text("Add Profile",style: AppTextStyles.montserratRegular.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.w500

                    ),)
                  ],
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
