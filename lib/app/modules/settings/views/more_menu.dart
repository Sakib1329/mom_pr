import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mompr_em/app/modules/auth/views/login.dart';
import 'package:mompr_em/app/modules/settings/views/help&support.dart';
import 'package:mompr_em/app/modules/settings/views/mylist.dart';
import 'package:mompr_em/app/modules/settings/views/profile.dart';
import 'package:mompr_em/app/modules/settings/views/subscribtion.dart';
import 'package:mompr_em/app/res/assets/imageassets.dart';
import 'package:mompr_em/app/res/colors/color.dart';

import '../../../res/fonts/fonts.dart';

class MoreMenu extends StatelessWidget {
  const MoreMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Profile Section
            Container(
              padding: EdgeInsets.all(16.w), // smaller
              child: Column(
                children: [
                  // Profile Image
                  Container(
                    width: 70.w, // smaller
                    height: 70.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5.w),
                      image: const DecorationImage(
                        image: AssetImage(ImageAssets.img_1),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Name
                  Text(
                    'Awad Arman',
                    style: AppTextStyles.montserratRegular.copyWith(
                      color: AppColor.translucentWhite,
                      fontSize: 16.sp, // smaller
                    ),
                  ),
                ],
              ),
            ),


            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(ImageAssets.svg20, height: 20.h),
                      SizedBox(width: 10.w),
                      Text(
                        'Tell friends about WERLI',
                        style: AppTextStyles.montserratRegular.copyWith(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Lorem ipsum dolor sit consectetur adipiscing elit. Sit purus felis semper quis risus leo ornare pulvinar amet...',
                    style: AppTextStyles.montserratMedium.copyWith(
                      color: Colors.grey[400],
                      fontSize: 12.sp,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Terms & Conditions',
                    style: AppTextStyles.montserratMedium.copyWith(
                      color: AppColor.translucentWhite,
                      fontSize: 11.sp,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColor.translucentWhite,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Copy Link Button
                  SizedBox(
                    width: double.infinity,
                    height: 36.h,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppColor.background,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.all(8.w),

                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'Copy Link',
                            style: AppTextStyles.montserratBold.copyWith(
                              color: AppColor.black,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Social Media Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _SocialIcon(icon: ImageAssets.svg22, onTap: () {}),
                      Text(" | ", style: TextStyle(color: AppColor.customDarkGray2, fontSize: 40.sp)),
                      _SocialIcon(icon: ImageAssets.svg23, onTap: () {}),
                      Text(" | ", style: TextStyle(color: AppColor.customDarkGray2, fontSize: 40.sp)),
                      _SocialIcon(icon: ImageAssets.svg24, onTap: () {}),
                      Text(" | ", style: TextStyle(color: AppColor.customDarkGray2, fontSize: 40.sp)),
                      Container(
                     padding: EdgeInsets.all(8.w),

                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                              size: 30.sp,
                            ),
                            Text(
                              "More",
                              style: AppTextStyles.montserratSemiBold.copyWith(
                                color: Colors.white,
                                fontSize: 12.sp, // smaller
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Menu Items
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(Mylist(),transition: Transition.rightToLeft);
                    },
                    child: Row(
                      children: [
                      SvgPicture.asset(ImageAssets.svg21),
                        SizedBox(width: 5.w,),
                        Text(
                          "My List",
                          style: AppTextStyles.montserratBold.copyWith(
                            color: Colors.white,
                            fontSize: 14.sp, // smaller

                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                    Divider(
                      color: AppColor.customDarkGray2,
                    ),
                    _MenuItem(
                      icon: Icons.account_circle_outlined,
                      title: 'Account',
                      onTap: () {
                        Get.to(ProfilePage(),transition: Transition.rightToLeft);
                      },
                    ),

                    _MenuItem(
                      icon: Icons.help_outline,
                      title: 'Help',
                      onTap: () {
                        Get.to(Helpandsupport(),transition: Transition.rightToLeft);
                      },
                    ),

                    _MenuItem(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      onTap: () {
                        Get.offAll(Login(),transition: Transition.rightToLeft);
                      },
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 35.h,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Text(
            title,
            style: AppTextStyles.montserratBold.copyWith(
              color: Colors.white,
              fontSize: 14.sp, // smaller

            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final String icon;

  final VoidCallback onTap;

  const _SocialIcon({Key? key, required this.icon, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        width: 36.w, // smaller
        height: 36.w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r)),
        child: SvgPicture.asset(icon), // smaller
      ),
    );
  }
}
