import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mompr_em/app/modules/auth/views/login.dart';
import 'package:mompr_em/app/res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../controllers/settingcontroller.dart';

class ProfilePage extends StatelessWidget {
  final Settingcontroller controller = Get.find();

  ProfilePage({super.key});

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10.h, 0, 16.h),
      child: Text(
        title,
        style: AppTextStyles.montserratMedium.copyWith(color: Colors.white70),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    RxString? reactiveValue,
    required String hintText,
    bool obscureText = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: (value) {
          if (reactiveValue != null) {
            reactiveValue.value = value;
          }
        },
        style: AppTextStyles.montserratRegular.copyWith(
          color: Colors.white,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.montserratRegular
              .copyWith(color: Colors.grey[400], fontSize: 12.sp),
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    final options = ['Male', 'Female', 'Other'];

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Obx(() => DropdownButtonFormField<String>(
        value: (controller.selectedGender.value ?? '').isEmpty
            ? null
            : controller.selectedGender.value,
        style: AppTextStyles.montserratRegular
            .copyWith(color: Colors.white, fontSize: 12.sp),
        dropdownColor: Colors.grey[800],
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
        hint: Text(
          'Select your gender',
          style: AppTextStyles.montserratRegular
              .copyWith(color: Colors.white70, fontSize: 12.sp),
        ),
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
        items: options
            .map((g) => DropdownMenuItem(
          value: g,
          child: Text(
            g,
            style: AppTextStyles.montserratRegular
                .copyWith(color: Colors.white, fontSize: 14.sp),
          ),
        ))
            .toList(),
        onChanged: (val) {
          controller.selectedGender.value = val ?? '';
        },
      )),
    );
  }



  Widget _buildDateField() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: TextField(
        controller: controller.dobController,
        style: AppTextStyles.montserratRegular
            .copyWith(color: Colors.white, fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: 'Select date of birth',
          hintStyle: AppTextStyles.montserratRegular
              .copyWith(color: Colors.grey[400], fontSize: 12.sp),
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          suffixIcon: Icon(Icons.calendar_today, color: Colors.grey[400]),
        ),
        readOnly: true,
        onTap: () async {
          final picked = await showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: Colors.orange,
                    onPrimary: Colors.black,
                    surface: AppColor.background,
                    onSurface: Colors.white,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColor.vividAmber,
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            controller.dobController.text =
            "${picked.day}/${picked.month}/${picked.year}";
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, TextEditingController controller,
      {bool isError = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyles.montserratMedium
                  .copyWith(color: Colors.white70, fontSize: 12.sp)),
          Text(controller.text,
              style: AppTextStyles.montserratMedium.copyWith(
                  color: isError ? Colors.red : Colors.white, fontSize: 12.sp)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: SvgPicture.asset('assets/icons/svg1.svg', height: 30.h),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Profile',
                style: AppTextStyles.montserratMedium
                    .copyWith(color: Colors.white, fontSize: 18.sp)),
            SizedBox(height: 5.h),
            Text('Customize your settings',
                style: AppTextStyles.montserratRegular
                    .copyWith(color: AppColor.translucentWhite, fontSize: 16.sp)),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                  color: AppColor.charcoal,
                  borderRadius: BorderRadius.circular(12.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('General Information'),
                  Text('Name',
                      style: AppTextStyles.montserratMedium
                          .copyWith(color: Colors.white70, fontSize: 14.sp)),
                  SizedBox(height: 8.h),
                  _buildTextField(
                      controller: controller.nameController,
                      reactiveValue: controller.nameText,
                      hintText: 'Enter your name'),
                  Text('Gender',
                      style: AppTextStyles.montserratMedium
                          .copyWith(color: Colors.white70, fontSize: 14.sp)),
                  SizedBox(height: 8.h),
                  _buildGenderDropdown(),
                  Text('Date of Birth',
                      style: AppTextStyles.montserratMedium
                          .copyWith(color: Colors.white70, fontSize: 14.sp)),
                  SizedBox(height: 8.h),
                  _buildDateField(),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                  color: AppColor.charcoal,
                  borderRadius: BorderRadius.circular(12.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Contact Information'),
                  _buildInfoRow('Phone', controller.phoneController),
                  _buildInfoRow('Email address', controller.emailController,),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('Add Email Address',
                        style: AppTextStyles.montserratMedium.copyWith(
                            color: Colors.red,
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                  color: AppColor.charcoal,
                  borderRadius: BorderRadius.circular(12.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Delete Account'),
                  Text(
                    'Type Delete to confirm',
                    style: AppTextStyles.montserratMedium
                        .copyWith(color: AppColor.darkGray3, fontSize: 14.sp),
                  ),
                  SizedBox(height: 8.h),
                  _buildTextField(
                      controller: controller.deleteConfirmController,
                      reactiveValue: controller.deleteConfirmText,
                      hintText: 'Enter Text'),
                  Obx(() {
                    if (controller.deleteConfirmText.value == 'Delete') {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                          ),
                          onPressed: () {
                          Get.offAll(Login(),transition: Transition.rightToLeft); // replace with delete logic
                          },
                          child: Text(
                            'Delete Account',
                            style: AppTextStyles.montserratSemiBold.copyWith(
                                color: Colors.white, fontSize: 14.sp),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
