import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mompr_em/app/modules/auth/views/changepass.dart';
import 'package:mompr_em/app/modules/auth/views/verifiedpage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/assets/imageassets.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../../../widgets/custom_button.dart';
import '../controllers/authcontroller.dart';

class Otpverifications extends StatelessWidget {
  final String email;
  final String fromPage;

  Otpverifications({
    Key? key,
    required this.email,
    required this.fromPage,
  }) : super(key: key);

  final TextEditingController otpController = TextEditingController();
  final Authcontroller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(automaticallyImplyLeading: false,),
          body: _buildContent(context),
        ),
        Obx(() => controller.isLoadingresend.value
            ? Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.6),
            alignment: Alignment.center,
            child: const SpinKitWave(
              color: AppColor.white,
              size: 40, // Reduced from 50 to 40
            ),
          ),
        )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Reduced from 20.h to 16.h
            SizedBox(height: 20.h),
            SvgPicture.asset(
              ImageAssets.svg17,
              height: 40.h,
              width: 40.w,
            ),
            SizedBox(height: 10.h,),// Reduced from 20.h to 16.h
            Text(
              'Please check your email.',
              style: AppTextStyles.montserratSemiBold.copyWith(
                fontSize: 18.sp, // Reduced from 28.sp to 22.4.sp
                color: AppColor.white,
                letterSpacing: 0.8.sp, // Reduced from 1.sp to 0.8.sp
              ),
            ),
            SizedBox(height: 8.h), // Reduced from 10.h to 8.h
            Text(
              'We\'ve sent a code to $email',
              style: AppTextStyles.montserratMedium.copyWith(
                fontSize: 14.4.sp, // Reduced from 18.sp to 14.4.sp
                color: AppColor.mediumGrey,
                letterSpacing: 0.8.sp, // Reduced from 1.sp to 0.8.sp
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h), // Reduced from 30.h to 24.h
            PinCodeTextField(
              appContext: context,
              keyboardType: TextInputType.number,
              controller: otpController,
              length: 4,
              animationType: AnimationType.fade,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 30.sp
              ),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(6.4.r), // Reduced from 8.r to 6.4.r
                fieldHeight: 60.h, // Reduced from 60.h to 48.h
                fieldWidth: 70.w, // Reduced from 60.w to 48.w
                activeFillColor: AppColor.customDarkGray2,
                selectedFillColor: AppColor.customDarkGray2,
                inactiveFillColor: AppColor.customDarkGray2,
                activeColor: AppColor.sunnyYellow,
                selectedColor: AppColor.sunnyYellow,
                inactiveColor: AppColor.white,
              ),
              enableActiveFill: true,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              onChanged: (_) {},
            ),
            SizedBox(height: 24.h), // Reduced from 30.h to 24.h
           Row(
             children: [
               Expanded(
                 child: CustomButton(
                   onPress: () async {
Get.back();
                   },
                   title: 'Cancel',
                  textGradient: LinearGradient(
                    colors: [AppColor.vividAmber, AppColor.sunnyYellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
           borderColor: AppColor.white,
                   buttonColor: AppColor.background,
                   width: double.infinity,
                   height: 30.h,
                   fontSize: 14.sp,
                   fontWeight: FontWeight.w600,
                 ),
               ),
               SizedBox(width: 10.w,),
               Expanded(
                 child: CustomButton(
                   onPress: () async {
                     print(controller.fromPage.value);
                     if(controller.fromPage.value=="signup") {
                       Get.offAll(Verifiedpage(page: fromPage,),transition: Transition.rightToLeft);
                     }
                     else
                     {
                       Get.offAll(Changepass(),transition: Transition.rightToLeft);
                     }
                   },
                   title:'Verify',
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
               ),
             ],
           ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Didn’t receive code?',
                  style: TextStyle(
                    color: AppColor.mediumGrey,
                    fontSize: 12.8.sp, // Reduced from 16.sp to 12.8.sp
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: () {

                  },
                  child: Text(
                    ' Resend',
                    style: TextStyle(
                      color: AppColor.sunnyYellow,
                      fontSize: 12.8.sp, // Reduced from 16.sp to 12.8.sp
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h), // Reduced from 40.h to 32.h
          ],
        ),
      ),
    );
  }
}