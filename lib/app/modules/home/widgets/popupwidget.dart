import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mompr_em/app/res/fonts/fonts.dart';

import '../../../res/colors/color.dart';
import '../../../widgets/custom_button.dart';

void showDeleteConfirmationPopup({
  required BuildContext context,
  required String title,
  required String buttontext,
  required String subtitle,
  required VoidCallback onDelete,
  required String arguments,
}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent tap outside to close
    builder: (_) {
      return WillPopScope(
        onWillPop: () async => false, // Prevent back button to close
        child: Dialog(
          backgroundColor: AppColor.charcoal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r), // Reduced from 20.r to 16.r
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h), // Reduced from 30.w, 20.h to 24.w, 16.h
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.montserratRegular.copyWith(
                    fontSize: 20.sp, // Reduced from 24.sp to 19.2.sp

                    color: AppColor.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                SizedBox(height: 16.h), // Reduced from 20.h to 16.h
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.montserratRegular.copyWith(
                    fontSize: 16.sp, // Reduced from 24.sp to 19.2.sp

                    color: AppColor.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                SizedBox(height: 20.h), // Reduced from 25.h to 20.h
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(

                        child: CustomButton(
                          onPress: () async {
                            Navigator.pop(context);
                          },
                          title: 'Cancel',
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          fontSize: 10.sp, // Kept at 16.sp as requested
                          borderColor: AppColor.vividAmber,
                         height:30.h,

                          buttonColor: AppColor.background,
                          borderShadowColor: AppColor.vividAmber,
                          textColor: AppColor.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w), // Reduced from 12.w to 9.6.w
                    Expanded(
                      child: CustomButton(

                        onPress: () async {
                          onDelete();
                          Navigator.pop(context);
                        },
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        title: buttontext,
                        fontSize: 10.sp,
                        gradient: LinearGradient(
                          colors: [AppColor.vividAmber, AppColor.sunnyYellow],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),

                        height:30.h, // Kept at 42.h as requested

                        borderShadowColor: AppColor.background,
                        textColor: AppColor.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}