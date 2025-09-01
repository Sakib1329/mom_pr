import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mompr_em/app/res/colors/color.dart';

class NetflixStyleCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String time;

  const NetflixStyleCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(10.w),
      child: Container(

        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColor.darkGray2,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [

            Container(
              width: 150.w,
              height: 70.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Content container
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // "New Arrival" text
                    Text(
                      'New Arrival',
                      style: TextStyle(
                        color: AppColor.translucentWhite,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    // Time/Date
                    Text(
                      time,
                      style: TextStyle(
                        color: AppColor.translucentWhite,
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
      ),
    );
  }
}
