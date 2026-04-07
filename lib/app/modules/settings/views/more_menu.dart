import 'package:Nuweli/app/modules/settings/views/dowload.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/Get.dart';
import 'package:Nuweli/app/constants/language_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';

import 'package:Nuweli/app/modules/home/controllers/home_controller.dart';
import 'package:Nuweli/app/modules/settings/controllers/bottomsheetController.dart';
import 'package:Nuweli/app/modules/settings/controllers/settingcontroller.dart';
import 'package:Nuweli/app/modules/settings/views/help&support.dart';
import 'package:Nuweli/app/modules/settings/views/mylist.dart';
import 'package:Nuweli/app/modules/settings/views/profile.dart';

import 'package:Nuweli/app/modules/settings/views/termsandcondition.dart';
import 'package:Nuweli/app/res/assets/imageassets.dart';
import 'package:Nuweli/app/res/colors/color.dart';

import '../../../constants/appconstant.dart';
import '../../../res/fonts/fonts.dart';

class MoreMenu extends StatelessWidget {
  final HomeController controller = Get.find();
  final Settingcontroller settingcontroller = Get.find();
  final BottomSheetController bs = Get.find();

  MoreMenu({super.key});

  final String shareLink = 'https://play.google.com/apps/internaltest/4700646484215252490';

  Future<void> _launchUrlStr(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        toastification.show(
          title: const Text('Error'),
          description: const Text('Could not open the app'),
          style: ToastificationStyle.fillColored, type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      toastification.show(
        title: const Text('Error'),
        description: const Text('Action not supported on this device'),
        style: ToastificationStyle.fillColored, type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
          // Profile Section
          Container(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // ✅ Profile Image (Dynamic)
                Obx(() {
                  final url = AppConstants.baseUrl;
                  final profileImage = settingcontroller.profileImage.value;
                  final localFile = bs.pickedImage.value;

                  final double size = 70.w;

                  return Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColor.vividAmber, width: 1.5.w),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: localFile != null
                            ? FileImage(localFile)
                            : (profileImage.isNotEmpty
                            ? NetworkImage("$profileImage") as ImageProvider
                            : const AssetImage(ImageAssets.img_1)),
                      ),
                    ),
                  );
                }),

                SizedBox(height: 10.h),

                // Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      settingcontroller.firstName.value,
                      style: AppTextStyles.montserratRegular.copyWith(
                        color: AppColor.translucentWhite,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      settingcontroller.lastName.value,
                      style: AppTextStyles.montserratRegular.copyWith(
                        color: AppColor.translucentWhite,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
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
                    Expanded(
                      child: Text(
                        'tell_friends'.tr,
                        style: AppTextStyles.montserratRegular.copyWith(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text("${settingcontroller.privacyContent.value}",
                    style: AppTextStyles.montserratMedium.copyWith(
                      color: Colors.grey[400],
                      fontSize: 12.sp,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    softWrap: true),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () {

                    Get.to(Privacypolicy(), transition: Transition.rightToLeft);
                  },
                  child: Text(
                    'terms_conditions'.tr,
                    style: AppTextStyles.montserratMedium.copyWith(
                      color: AppColor.translucentWhite,
                      fontSize: 11.sp,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColor.translucentWhite,
                    ),
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
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: AppColor.background,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            shareLink,
                            style: AppTextStyles.montserratMedium.copyWith(color: AppColor.customDarkGray2, fontSize: 12.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: shareLink));
                          toastification.show(
                            title: Text('link_copied'.tr ?? 'Link Copied', style: const TextStyle(color: Colors.white)),
                            style: ToastificationStyle.fillColored, type: ToastificationType.success,
                            autoCloseDuration: const Duration(seconds: 2),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'copy_link'.tr,
                            style: AppTextStyles.montserratBold.copyWith(
                              color: AppColor.black,
                              fontSize: 14.sp,
                            ),
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
                    _SocialIcon(icon: ImageAssets.svg22, onTap: () => _launchUrlStr('whatsapp://send?text=${Uri.encodeComponent(shareLink)}')),
                    Text(" | ", style: TextStyle(color: AppColor.customDarkGray2, fontSize: 40.sp)),
                    _SocialIcon(icon: ImageAssets.svg23, onTap: () => _launchUrlStr('https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(shareLink)}')),
                    Text(" | ", style: TextStyle(color: AppColor.customDarkGray2, fontSize: 40.sp)),
                    _SocialIcon(icon: ImageAssets.svg24, onTap: () => _launchUrlStr('mailto:?subject=${Uri.encodeComponent("Check out this app!")}&body=${Uri.encodeComponent(shareLink)}')),
                    Text(" | ", style: TextStyle(color: AppColor.customDarkGray2, fontSize: 40.sp)),
                    GestureDetector(
                      onTap: () {
                        Share.share(shareLink);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r)),
                        child: Column(
                          children: [
                            Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                              size: 30.sp,
                            ),
                            Text(
                              'more'.tr,
                              style: AppTextStyles.montserratSemiBold.copyWith(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Menu Items
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {

                      Get.to(Mylist(), transition: Transition.rightToLeft);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(ImageAssets.svg21),
                        SizedBox(width: 5.w),
                        Text(
                          'my_list_title'.tr,
                          style: AppTextStyles.montserratBold.copyWith(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  Divider(color: AppColor.customDarkGray2),
                  _MenuItem(
                    icon: Icons.download,
                    title: 'downloads'.tr,
                    onTap: ()  {

                      Get.to(DownloadsScreen(), transition: Transition.rightToLeft);
                    },
                  ),
                  _MenuItem(
                    icon: Icons.account_circle_outlined,
                    title: 'account'.tr,
                    onTap: () async {

                      Get.to(ProfilePage(), transition: Transition.rightToLeft);
                    },
                  ),
                  _MenuItem(
                    icon: Icons.help_outline,
                    title: 'help'.tr,
                    onTap: () {
                      Get.to(HelpAndSupport(), transition: Transition.rightToLeft);
                    },
                  ),
                  _MenuItem(
                    icon: Icons.language,
                    title: 'language'.tr,
                    onTap: () {
                      _showLanguageDialog();
                    },
                  ),
                  _MenuItem(
                    icon: Icons.logout,
                    title: 'sign_out'.tr,
                    onTap: () {
                      settingcontroller.signOut();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: AppColor.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(color: AppColor.vividAmber.withOpacity(0.3), width: 1.w),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColor.customDarkGray2,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'language'.tr,
              style: AppTextStyles.montserratBold.copyWith(
                color: AppColor.white,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 16.h),
            _buildLanguageOption('English', 'en', 'US'),
            Divider(color: AppColor.customDarkGray2, height: 1.h),
            _buildLanguageOption('Français', 'fr', 'FR'),
            Divider(color: AppColor.customDarkGray2, height: 1.h),
            _buildLanguageOption('Español', 'es', 'ES'),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String title, String langCode, String countryCode) {
    bool isSelected = Get.locale?.languageCode == langCode;
    return InkWell(
      onTap: () {
        final fullLocale = '${langCode}_$countryCode';
        GetStorage().write('locale', fullLocale);
        Get.updateLocale(Locale(langCode, countryCode));
        LanguageApiService.changeLanguage(fullLocale);
        Get.back();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.montserratSemiBold.copyWith(
                color: isSelected ? AppColor.vividAmber : AppColor.white,
                fontSize: 16.sp,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColor.vividAmber, size: 24.sp),
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
              fontSize: 14.sp,
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

  const _SocialIcon({Key? key, required this.icon, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r)),
        child: SvgPicture.asset(icon),
      ),
    );
  }
}