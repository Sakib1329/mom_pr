import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../controllers/settingcontroller.dart';

class Privacypolicy extends StatelessWidget {
  final Settingcontroller controller = Get.find();
  Privacypolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        title: Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Terms & ",
                    style: AppTextStyles.montserratBold.copyWith(
                      fontSize: 20.sp,
                      color: AppColor.white, // Change this to your desired color
                    ),
                  ),
                  TextSpan(
                    text: "Conditions",
                    style: AppTextStyles.montserratBold.copyWith(
                      fontSize: 20.sp,
                      color: AppColor.vividAmber, // Different color for "Conditions"
                    ),
                  ),
                ],
              ),
            )

          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h), // Reduced from 20.w, 20.h to 16.w, 16.h
                    child: Text(
                      controller.privacyContent.value,
                      style: AppTextStyles.montserratRegular.copyWith(
                        fontSize: 13.sp,
                        color: AppColor.white,
                      ),
                    ),
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