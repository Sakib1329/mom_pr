import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mompr_em/app/res/colors/color.dart';
import 'package:mompr_em/app/res/fonts/fonts.dart';

class MovieCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final List<String> genres;
  final String seasonInfo;
  final VoidCallback? onRemindMeTap;
  final VoidCallback? onShareTap;

  const MovieCardWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.genres,
    required this.seasonInfo,
    this.onRemindMeTap,
    this.onShareTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding:  EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.montserratSemiBold.copyWith(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  subtitle,
                  style: AppTextStyles.montserratSemiBold.copyWith(
                    color: Colors.grey[400],
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: 2
                  ),
                ),
                SizedBox(height: 15.h),
                // Genres Row
                SizedBox(
                  height: 25.h, // adjust height for list items
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: genres.length,
                    separatorBuilder: (context, index) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 4.h,
                        ),
                        child: Text(
                          "${genres[index]} •",
                          style: AppTextStyles.montserratBold.copyWith(
                            color: AppColor.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    },
                  ),
                )

              ],
            ),
            SizedBox(height: 15.h),
            // Movie Image Section
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 50.sp,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    seasonInfo,
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.translucentWhite,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onRemindMeTap,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Remind Me',
                          style:
                          AppTextStyles.montserratRegular.copyWith(
                            color: AppColor.translucentWhite,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 5.w),

                // Share Button
                GestureDetector(
                  onTap: onShareTap,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Share',
                          style:
                          AppTextStyles.montserratSemiBold.copyWith(
                            color: AppColor.translucentWhite,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Season Info

          ],
        ),
      ),
    );
  }
}
