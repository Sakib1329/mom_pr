import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mompr_em/app/modules/settings/controllers/settingcontroller.dart';
import 'package:mompr_em/app/res/assets/imageassets.dart';
import 'package:mompr_em/app/res/colors/color.dart';
import 'package:mompr_em/app/res/fonts/fonts.dart';

import '../../../widgets/custom_button.dart';

class Subscribtion extends StatelessWidget {
  final Settingcontroller controller = Get.find();

  Subscribtion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: SvgPicture.asset('assets/icons/svg1.svg', height: 30.h),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageAssets.img),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark Overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.6),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 21.6.w), // 24*0.9
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 36.h), // 40*0.9

                  // Title
                  Center(
                    child: Text(
                      "Choose a plan to enjoy Werli",
                      style: AppTextStyles.montserratSemiBold.copyWith(
                        color: AppColor.translucentWhite,
                        fontSize: 18.sp, // 24*0.9

                      ),

                    ),
                  ),

                  SizedBox(height: 28.8.h), // 32*0.9

                  // Features
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildFeatureRow("Premium Content")),

                      Expanded(child: _buildFeatureRow("Ad Free Experience")),
                    ],
                  ),
                  SizedBox(height: 10.h), // 12*0.9
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildFeatureRow("4k Streaming")),
                      Expanded(child: _buildFeatureRow("High quality Sound Experience")),
                    ],
                  ),

                  SizedBox(height: 36.h), // 40*0.9

                  // Subscription Plans
                  Obx(() => _buildPlanCard(
                    title: "3 Months",
                    subtitle: "5 Device, 1 Stream",
                    price: "5\$",
                    isSelected: controller.selectedPlan.value == 0,
                    onTap: () => controller.selectPlan(0),
                  )),
                  SizedBox(height: 14.4.h), // 16*0.9
                  Obx(() => _buildPlanCard(
                    title: "12 Months",
                    subtitle: "7 Device, 2 Stream",
                    price: "10\$",
                    isSelected: controller.selectedPlan.value == 1,
                    onTap: () => controller.selectPlan(1),
                  )),
                  SizedBox(height: 21.6.h), // 24*0.9

                  // Redeem Code
                  Row(
                    children: [
                   SvgPicture.asset(
                     ImageAssets.svg25,
                   ),
                      SizedBox(width: 7.2.w), // 8*0.9
                      GestureDetector(
                        onTap: () => Get.snackbar("Redeem", "Redeem code tapped"),
                        child: Text(
                          "Have a Redeem code?",
                          style: AppTextStyles.montserratSemiBold.copyWith(
                            color: AppColor.white,
                            fontSize: 12.sp, // 16*0.9
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Spacer(),

                  // Footer Links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFooterLink("Privacy Policy"),
                      Text(" | ", style: TextStyle(color: Colors.grey, fontSize: 12.sp)), // 12*0.9
                      _buildFooterLink("Terms of Use"),
                      Text(" | ", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                      _buildFooterLink("FAQ"),
                    ],
                  ),

                  SizedBox(height: 21.6.h), // 24*0.9

                  // Subscribe Button
                  CustomButton(
                    onPress: () async {
          controller.subscribe();
                    },
                    title: 'Subscribe',
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

                  SizedBox(height: 21.6.h), // 24*0.9
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check,
          color: AppColor.white,
          size: 18.sp,
        ),
        SizedBox(width: 5.w),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.montserratSemiBold.copyWith(
              color: AppColor.translucentWhite,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildPlanCard({
    required String title,
    required String subtitle,
    required String price,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child:Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.8.r),
          gradient: isSelected
              ? const LinearGradient(
            colors: [AppColor.vividAmber, AppColor.sunnyYellow],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.montserratSemiBold.copyWith(
                    color: isSelected ?AppColor.background :AppColor.translucentWhite,
                    fontSize: 16.2.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.6.h),
                Text(
                  subtitle,
                  style: AppTextStyles.montserratSemiBold.copyWith(
                    color: isSelected ?AppColor.background :AppColor.translucentWhite,
                    fontSize: 12.6.sp,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  price,
                  style: AppTextStyles.montserratSemiBold.copyWith(
                    color: isSelected ?AppColor.background :AppColor.translucentWhite,
                    fontSize: 21.6.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10.8.w),
                Container(
                  width: 21.6.w,
                  height: 21.6.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:isSelected ?AppColor.background :AppColor.translucentWhite,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                    Icons.circle,
                    color: isSelected ?AppColor.background :AppColor.translucentWhite,
                    size: 14.4.sp,
                  )
                      : null,
                ),
              ],
            ),
          ],
        ),
      )

    );
  }

  Widget _buildFooterLink(String text) {
    return GestureDetector(
      onTap: () => Get.snackbar("Link", "$text tapped"),
      child: Text(
        text,
        style: AppTextStyles.montserratSemiBold.copyWith(
          color: Colors.grey,
          fontSize: 12.sp, // 12*0.9
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
