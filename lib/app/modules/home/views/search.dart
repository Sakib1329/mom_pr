import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mompr_em/app/res/assets/imageassets.dart';
import 'package:mompr_em/app/res/colors/color.dart';
import 'package:mompr_em/app/res/fonts/fonts.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              margin: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a show, movie, genre, e.t.c',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 22.sp),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),

            // Top Searches Title
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Top Searches',
                style: AppTextStyles.montserratBold.copyWith(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Shows List
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                children: const [
                  ShowItem(
                    imagePath: ImageAssets.img_6,
                    title: 'Citation',
                  ),
                  ShowItem(
                    imagePath: ImageAssets.img_7,
                    title: 'Cloture',
                  ),
                  ShowItem(
                    imagePath: ImageAssets.img_8,
                    title: 'The Setup',
                  ),
                  ShowItem(
                    imagePath: ImageAssets.img_9,
                    title: 'Breaking Bad',
                  ),
                  ShowItem(
                    imagePath: ImageAssets.img_10,
                    title: 'Ozark',
                  ),
                  ShowItem(
                    imagePath: ImageAssets.img_11,
                    title: 'The Governor',
                  ),
                  ShowItem(
                    imagePath: ImageAssets.img_12,
                    title: 'Your Excellency',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowItem extends StatelessWidget {
  final String imagePath;
  final String title;

  const ShowItem({
    Key? key,
    required this.imagePath,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.customDarkGray2,
      margin: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          // Thumbnail Image
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: Container(
              width: 120.w,
              height: 80.h,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 30.sp,
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Title
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.montserratSemiBold.copyWith(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Play Button
          Container(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 32.sp,
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative ShowItem widget with Network Image
class ShowItemNetwork extends StatelessWidget {
  final String imageUrl;
  final String title;

  const ShowItemNetwork({
    Key? key,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          // Thumbnail Image
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: Container(
              width: 120.w,
              height: 68.h,
              color: Colors.grey[800],
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[800],
                    child: Center(
                      child: SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.w,
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 30.sp,
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Title
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Play Button
          Container(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 32.sp,
            ),
          ),
        ],
      ),
    );
  }
}
