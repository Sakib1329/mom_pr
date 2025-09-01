import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mompr_em/app/res/colors/color.dart';
import 'package:mompr_em/app/res/fonts/fonts.dart';

import '../../../res/assets/imageassets.dart';

class ProfileDropdown extends StatelessWidget {
  final String userName;
  final String userImageUrl;
  final VoidCallback onProfileTap;
  final VoidCallback onMyListTap;
  final VoidCallback onWatchHistoryTap;
  final VoidCallback onUnsubscribeTap;

  const ProfileDropdown({
    super.key,
    required this.userName,
    required this.userImageUrl,
    required this.onProfileTap,
    required this.onMyListTap,
    required this.onWatchHistoryTap,
    required this.onUnsubscribeTap,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: AppColor.charcoal, // Dark background like screenshot
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Padding(
            padding:  EdgeInsets.all(20.w),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(userImageUrl),
                  radius: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  userName,
                  style: AppTextStyles.montserratRegular.copyWith(
                    color: AppColor.translucentWhite,

                  ),
                ),
                const Divider(  color: AppColor.darkGray2,),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          onTap: onProfileTap,
          child: _menuItem(ImageAssets.svg27, "Profile"),
        ),
        PopupMenuItem(
          onTap: onMyListTap,
          child: _menuItem(ImageAssets.svg28, "My List"),
        ),
        PopupMenuItem(
          onTap: onWatchHistoryTap,
          child: _menuItem(ImageAssets.svg29, "Watch History"),
        ),
        const PopupMenuDivider(
          color: AppColor.darkGray2,
        ),
        PopupMenuItem(
          onTap: onUnsubscribeTap,
          child: _menuItem(ImageAssets.svg30, "Unsubscribe", isDestructive: true),
        ),
      ],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200.r),
        child: Image.asset(
          ImageAssets.person,
          width: 32.w,
          height: 30.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _menuItem(String icon, String title, {bool isDestructive = false}) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
        SvgPicture.asset(icon),
          const SizedBox(width: 12),
          Text(
            title,
            style: AppTextStyles.montserratRegular.copyWith(
              color: isDestructive ? Colors.red : Colors.white,
              fontSize: 14.sp,
              fontWeight: isDestructive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
