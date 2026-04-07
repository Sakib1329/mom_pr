import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/Get.dart';
import 'package:Nuweli/app/modules/auth/views/login.dart';
import 'package:Nuweli/app/res/colors/color.dart';
import '../../../constants/appconstant.dart';
import '../../../res/assets/imageassets.dart';
import '../../../res/fonts/fonts.dart';
import '../../../widgets/custom_button.dart';
import '../controllers/bottomsheetController.dart';
import '../controllers/settingcontroller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Settingcontroller controller = Get.find();
  final BottomSheetController bs = Get.find();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProfileData();
    });
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10.h, 0, 16.h),
      child: Text(
        title.tr,
        style: AppTextStyles.montserratMedium.copyWith(color: AppColor.vividAmber),
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
          if (reactiveValue != null) reactiveValue.value = value;
        },
        style: AppTextStyles.montserratRegular.copyWith(
          color: Colors.white,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          hintText: hintText.tr,
          hintStyle: AppTextStyles.montserratRegular
              .copyWith(color: Colors.grey[400], fontSize: 12.sp),
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    final options = ['male'.tr, 'female'.tr];
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Obx(() => DropdownButtonFormField<String>(
        value: (controller.selectedGender.value ?? '').isNotEmpty
            ? controller.selectedGender.value
            : null,
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
          hintText: 'select_gender'.tr,
          hintStyle: AppTextStyles.montserratRegular
              .copyWith(color: Colors.white, fontSize: 12.sp),
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
          hintText: controller.dateOfBirth.value.isNotEmpty
              ? controller.dateOfBirth.value
              : 'select_dob'.tr,
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
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
            controller.dateOfBirth.value = controller.dobController.text;
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label.tr,
              style: AppTextStyles.montserratMedium
                  .copyWith(color: Colors.white70, fontSize: 12.sp)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.montserratMedium.copyWith(
                  color: isError ? Colors.red : AppColor.vividAmber, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
          onPressed: () => Get.back(),
        ),
        title: SvgPicture.asset('assets/icons/svg1.svg', height: 20.h),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isFetchingProfile.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.vividAmber),
          );
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Obx(() {
                      final url = AppConstants.baseUrl;
                      final profileImage = controller.profileImage.value;
                      final localFile = controller.pickedImage.value ?? bs.pickedImage.value;

                      final double size = 130.w;

                      return Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor.vividAmber, width: 2),
                        ),
                        child: ClipOval(
                          child: localFile != null
                              ? Image.file(
                            localFile,
                            width: size,
                            height: size,
                            fit: BoxFit.cover,
                          )
                              : (profileImage.isNotEmpty
                              ? Image.network(
                            "$profileImage",
                            width: size,
                            height: size,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              ImageAssets.person,
                              width: size,
                              height: size,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Image.asset(
                            ImageAssets.person,
                            width: size,
                            height: size,
                            fit: BoxFit.cover,
                          )),
                        ),
                      );
                    }),
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: bs.getBottomSheet,
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: AppColor.black,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColor.vividAmber, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, size: 18, color: AppColor.vividAmber),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text('my_profile'.tr,
                  style: AppTextStyles.montserratMedium
                      .copyWith(color: Colors.white, fontSize: 18.sp)),
              SizedBox(height: 5.h),
              Text('customize_settings'.tr,
                  style: AppTextStyles.montserratRegular.copyWith(
                      color: AppColor.translucentWhite, fontSize: 16.sp)),
              SizedBox(height: 12.h),

              // 🧾 General Info
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColor.charcoal,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('general_info'),
                    Text('first_name'.tr,
                        style: AppTextStyles.montserratMedium
                            .copyWith(color: Colors.white70, fontSize: 14.sp)),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: controller.firstNameController,
                      reactiveValue: controller.firstName,
                      hintText: controller.firstName.value.isNotEmpty
                          ? controller.firstName.value
                          : 'enter_first_name',
                    ),
                    Text('last_name'.tr,
                        style: AppTextStyles.montserratMedium
                            .copyWith(color: Colors.white70, fontSize: 14.sp)),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: controller.lastNameController,
                      reactiveValue: controller.lastName,
                      hintText: controller.lastName.value.isNotEmpty
                          ? controller.lastName.value
                          : 'enter_last_name',
                    ),
                    Text('gender'.tr,
                        style: AppTextStyles.montserratMedium
                            .copyWith(color: Colors.white70, fontSize: 14.sp)),
                    SizedBox(height: 8.h),
                    _buildGenderDropdown(),
                    Text('date_of_birth'.tr,
                        style: AppTextStyles.montserratMedium
                            .copyWith(color: Colors.white70, fontSize: 14.sp)),
                    SizedBox(height: 8.h),
                    _buildDateField(),
                    _buildSectionTitle('contact_info'),

                    Text('phone'.tr,
                        style: AppTextStyles.montserratMedium
                            .copyWith(color: Colors.white70, fontSize: 14.sp)),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: controller.phoneController,
                      reactiveValue: controller.phone,
                      hintText: controller.phone.value.isNotEmpty
                          ? controller.phone.value
                          : 'enter_phone',
                    ),

                    _buildInfoRow('email_address', controller.email.value),
                    SizedBox(height: 20.h,),
                    CustomButton(
                      loading: controller.isLoading.value,
                      title: 'save_changes'.tr,
                      onPress: () async {
                        await controller.updateProfileData();
                      },
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.yellowAccent],
                      ),
                      width: double.infinity,
                      height: 30.h,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),

                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // ⚠️ Delete Account
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                    color: AppColor.charcoal,
                    borderRadius: BorderRadius.circular(12.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('delete_account'),
                    Text(
                      'type_delete_confirm'.tr,
                      style: AppTextStyles.montserratMedium
                          .copyWith(color: AppColor.darkGray3, fontSize: 14.sp),
                    ),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: controller.deleteConfirmController,
                      reactiveValue: controller.deleteConfirmText,
                      hintText: 'enter_text',
                    ),
                    Obx(() {
                      if (controller.deleteConfirmText.value.toLowerCase() == 'delete') {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r)),
                            ),
                            onPressed: () async {
                              await controller.deleteProfileData();
                            },
                            child: Text(
                              'delete_account_btn'.tr,
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
        );
      }),
    );
  }
}