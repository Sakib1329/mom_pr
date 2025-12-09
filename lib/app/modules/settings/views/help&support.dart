import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/input_text_widget.dart';
import '../controllers/settingcontroller.dart';

class HelpAndSupport extends StatelessWidget {
  final Settingcontroller controller = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: SvgPicture.asset('assets/icons/svg1.svg', height: 20.h),
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
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          "Help & Support",
                          style: AppTextStyles.montserratRegular
                              .copyWith(fontSize: 20.sp),
                        ),
                      ),
                      SizedBox(height: 24.h),
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
                              "If you are experiencing any issues, please let us know. We will try to solve them as soon as possible.",
                              style: AppTextStyles.montserratMedium
                                  .copyWith(color: Colors.white70),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              "Email",
                              style: AppTextStyles.montserratRegular
                                  .copyWith(fontSize: 16.sp),
                            ),
                            SizedBox(height: 5.h,),
                            InputTextWidget(
                              controller: titleController,
                              borderColor: AppColor.background,
                              backgroundColor: AppColor.darkGray3,
                              hintTextColor: AppColor.white,
                              hintText: 'Enter your email',
                              textColor: AppColor.white,
                              height: 30.h,
                              width: double.infinity,
                              onChanged: (val) {},
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              "Explain the problem",
                              style: AppTextStyles.montserratRegular
                                  .copyWith(fontSize: 16.sp),
                            ),
                            SizedBox(height: 5.h),
                            InputTextWidget(
                              controller: descriptionController,
                              borderColor: AppColor.background,
                              backgroundColor: AppColor.darkGray3,
                              hintText: 'Type your query here',
                              hintTextColor: AppColor.white,
                              textColor: AppColor.white,
                              height: 140.h,
                              maxLines: 8,
                              width: double.infinity,
                              onChanged: (val) {},
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Obx(() => CustomButton(
                          onPress: controller.isLoading.value
                              ? null
                              : () async {
                            await controller.submitHelpSupport(
                              email: controller.email.value,
                              description: descriptionController.text,
                            );
                          },
                          title: controller.isLoading.value
                              ? 'Submitting...'
                              : 'Submit',
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
                      ),
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
