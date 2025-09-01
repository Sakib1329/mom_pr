import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mompr_em/app/modules/settings/views/more_menu.dart';

import '../../../res/assets/imageassets.dart';
import '../../../res/colors/color.dart';

import '../../../res/fonts/fonts.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/input_text_widget.dart';
import '../controllers/settingcontroller.dart';

class Helpandsupport extends StatelessWidget {

  final Settingcontroller controller = Get.find();
  final TextEditingController c1 = TextEditingController();
  final TextEditingController c2 = TextEditingController();

  Helpandsupport({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: SvgPicture.asset('assets/icons/svg1.svg', height: 30.h),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 8.h), // Reduced from 10.h to 8.h
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          "Help & Support",
                          style: AppTextStyles.montserratRegular.copyWith(fontSize: 20.sp), // Reduced from 25.sp to 20.sp
                        ),
                      ),

                      SizedBox(height: 24.h), // Reduced from 30.h to 24.h
                   Container(
                     padding: EdgeInsets.all(15.w),
                     margin: EdgeInsets.all(10.w),
                     decoration: BoxDecoration(
                       color: AppColor.charcoal,
                       borderRadius: BorderRadius.circular(12.r),
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "If you are experiencing any issues, please let us know .We will try to solve them as soon as possible.",
                          style: AppTextStyles.montserratMedium.copyWith(
                              color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          "Title",
                          style: AppTextStyles.montserratRegular.copyWith(fontSize: 16.sp),
                          textAlign: TextAlign.start// Reduced from 25.sp to 20.sp
                        ),
                        InputTextWidget(
                          onChanged: (e) {},
                          controller: c1,
                          borderColor: AppColor.background,
                          backgroundColor: AppColor.darkGray3,
                          hintTextColor: AppColor.white,
                          hintText: 'Add you grievance title here',
                          textColor: AppColor.white,

                          height: 30.h, // Reduced from 55.h to 44.h
                          width: double.infinity,
                        ),

                        SizedBox(height: 12.h),
                        Text(
                          "Explain the problem",
                          style: AppTextStyles.montserratRegular.copyWith(fontSize: 16.sp), // Reduced from 25.sp to 20.sp
                        ),
                        SizedBox(height: 5.h),// Reduced from 15.h to 12.h
                        InputTextWidget(
                          onChanged: (e) {},
                          controller: c2,

                          borderColor: AppColor.background,
                          backgroundColor: AppColor.darkGray3,
                          hintText: 'Type your query here',
                          hintTextColor: AppColor.white,
                          textColor: AppColor.vividAmber,
                          height: 140.h, // Reduced from 200.h to 160.h

                          maxLines: 8, // Reduced from 10 to 8 (closest integer after 20% reduction)
                          width: double.infinity,
                        ),
                      ],
                     ),
                   ),
                      SizedBox(height: 24.h), // Reduced from 30.h to 24.h
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w), // Reduced from 20.w to 16.w
                        child:  CustomButton(
                          onPress: () async {

                          },
                          title: 'Submit',
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
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}