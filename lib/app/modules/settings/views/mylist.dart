import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mompr_em/app/res/assets/imageassets.dart';

import '../../../res/fonts/fonts.dart';

class Mylist extends StatelessWidget {
  const Mylist({Key? key}) : super(key: key);

  // Sample movie data
  final List<Map<String, String>> movies = const [
    {'image': ImageAssets.img_6},
    {'image': ImageAssets.img_7},
    {'image': ImageAssets.img_8},
    {'image': ImageAssets.img_9},
    {'image': ImageAssets.img_10},
    {'image': ImageAssets.img_11},
    {'image': ImageAssets.img_12},
    {'image': ImageAssets.img_13},
    {'image': ImageAssets.img_14},
    {'image': ImageAssets.img_6},
    {'image': ImageAssets.img_7},
    {'image': ImageAssets.img_8},
    {'image': ImageAssets.img_9},
    {'image': ImageAssets.img_10},
    {'image': ImageAssets.img_11},
    {'image': ImageAssets.img_12},
    {'image': ImageAssets.img_13},
    {'image': ImageAssets.img_14},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: SvgPicture.asset('assets/icons/svg1.svg', height: 30.h),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 10.h), // reduced padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My List',
                style: AppTextStyles.montserratSemiBold.copyWith(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),

              ),
              SizedBox(height: 10.h,),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // keep 3 per row
                  crossAxisSpacing: 10.w, // slightly less spacing
                  mainAxisSpacing: 14.h,
                  childAspectRatio: 0.58, // was 0.65 → makes them ~10% taller/wider
                ),
                itemCount: movies.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r), // slightly bigger radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6.r, // little bigger shadow
                          offset: Offset(0, 3.h),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            movie['image']!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[800],
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey[400],
                                  size: 42.sp, // slightly bigger
                                ),
                              );
                            },
                          ),
                          // Gradient overlay
                          Container(
                            height: 65.h, // a bit taller overlay
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
