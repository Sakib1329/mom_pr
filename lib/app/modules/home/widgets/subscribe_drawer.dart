import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/Get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Nuweli/app/res/assets/imageassets.dart';
import 'package:Nuweli/app/res/colors/color.dart';
import 'package:Nuweli/app/res/fonts/fonts.dart';

class ProfileDropdown extends StatelessWidget {
  final String userName;
  final String  status;
  final String userImageUrl;
  final VoidCallback onProfileTap;
  final VoidCallback onMyListTap;
  final VoidCallback onWatchHistoryTap;
  final VoidCallback onUnsubscribeTap;
  final VoidCallback oncollectiontap;

  const ProfileDropdown({
    super.key,
    required this.userName,
    required this.userImageUrl,
    required this.onProfileTap,
    required this.onMyListTap,
    required this.onWatchHistoryTap,
    required this.onUnsubscribeTap,
    required this.oncollectiontap, required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: AppColor.charcoal,
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: _getProfileImage(),
                  backgroundColor: AppColor.darkGray2,
                ),
                const SizedBox(height: 8),
                Text(userName, style: AppTextStyles.montserratRegular.copyWith(color: AppColor.translucentWhite)),
                const Divider(color: AppColor.darkGray2),
              ],
            ),
          ),
        ),
        PopupMenuItem(onTap: onProfileTap, child: _menuItem(ImageAssets.svg27, 'profile'.tr, 20)),
        PopupMenuItem(onTap: onMyListTap, child: _menuItem(ImageAssets.svg28, 'my_list'.tr, 20)),
        PopupMenuItem(onTap: onWatchHistoryTap, child: _menuItem(ImageAssets.svg29, 'watch_history'.tr, 20)),
        PopupMenuItem(onTap: oncollectiontap, child: _menuItem(ImageAssets.svg31, 'collections'.tr, 20)),
        const PopupMenuDivider(color: AppColor.darkGray2),
        PopupMenuItem(onTap: onUnsubscribeTap, child: _menuItem(ImageAssets.svg26, status, 18, isDestructive: true)),
      ],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200.r),
        child: Image(image: _getProfileImage(), width: 32.w, height: 30.h, fit: BoxFit.cover),
      ),
    );
  }

  ImageProvider _getProfileImage() {
    if (userImageUrl.isNotEmpty) {
      if (userImageUrl.startsWith('http') || userImageUrl.startsWith('https')) {
        return NetworkImage(userImageUrl);
      } else {
        return AssetImage(userImageUrl);
      }
    }
    return AssetImage(ImageAssets.person);
  }

  Widget _menuItem(String icon, String title, double height, {bool isDestructive = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          SvgPicture.asset(icon, color: isDestructive ? AppColor.vividAmber : Colors.white, height: height.sp, width: 30.w),
          const SizedBox(width: 12),
          Text(
            title,
            style: AppTextStyles.montserratRegular.copyWith(
              color: isDestructive ? AppColor.vividAmber : Colors.white,
              fontSize: 14.sp,
              fontWeight: isDestructive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}