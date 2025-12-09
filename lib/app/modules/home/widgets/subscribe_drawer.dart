import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Nuweli/app/res/colors/color.dart';
import 'package:Nuweli/app/res/fonts/fonts.dart';
import '../../../res/assets/imageassets.dart';

class ProfileDropdown extends StatelessWidget {
  final String userName;
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
    required this.oncollectiontap,
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
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: _getProfileImage(), // Use helper method for dropdown avatar
                  backgroundColor: AppColor.darkGray2, // Fallback background color
                ),
                const SizedBox(height: 8),
                Text(
                  userName,
                  style: AppTextStyles.montserratRegular.copyWith(
                    color: AppColor.translucentWhite,
                  ),
                ),
                const Divider(color: AppColor.darkGray2),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          onTap: onProfileTap,
          child: _menuItem(ImageAssets.svg27, "Profile", 20),
        ),
        PopupMenuItem(
          onTap: onMyListTap,
          child: _menuItem(ImageAssets.svg28, "My List", 20),
        ),
        PopupMenuItem(
          onTap: onWatchHistoryTap,
          child: _menuItem(ImageAssets.svg29, "Watch History", 20),
        ),
        PopupMenuItem(
          onTap: oncollectiontap,
          child: _menuItem(ImageAssets.svg31, "  Collections", 20),
        ),
        const PopupMenuDivider(
          color: AppColor.darkGray2,
        ),
        PopupMenuItem(
          onTap: onUnsubscribeTap,
          child: _menuItem(ImageAssets.svg26, "Subscription", 18, isDestructive: true),
        ),
      ],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200.r),
        child: Image(
          image: _getProfileImage(), // ✅ Use helper method for button image
          width: 32.w,
          height: 30.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Helper method to determine the correct image source
  ImageProvider _getProfileImage() {
    if (userImageUrl.isNotEmpty) {
      // Check if userImageUrl is a network URL
      if (userImageUrl.startsWith('http') || userImageUrl.startsWith('https')) {
        return NetworkImage(userImageUrl);
      } else {
        // Assume it's a local asset path
        return AssetImage(userImageUrl);
      }
    }
    // Fallback to default person image if userImageUrl is empty
    return AssetImage(ImageAssets.person);
  }

  Widget _menuItem(String icon, String title, double height, {bool isDestructive = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            color: isDestructive ? AppColor.vividAmber : Colors.white,
            height: height.sp,
            width: 30.w,
          ),
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