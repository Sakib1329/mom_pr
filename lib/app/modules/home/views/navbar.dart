// lib/app/modules/home/views/navbar.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mompr_em/app/modules/home/views/coming_soon.dart';
import 'package:mompr_em/app/modules/home/views/home.dart';
import 'package:mompr_em/app/modules/home/views/search.dart';
import 'package:mompr_em/app/modules/settings/views/mylist.dart';
import 'package:mompr_em/app/res/fonts/fonts.dart';
import '../../../res/assets/imageassets.dart';
import '../../../res/colors/color.dart';
import '../../settings/views/more_menu.dart';
import '../controllers/navcontroller.dart';

class Navbar extends StatelessWidget {
  Navbar({Key? key}) : super(key: key);

  final _pages = <Widget>[HomePage(), Search(), ComingSoon(), MoreMenu()];
  final NavController controller = Get.find();

  final List<String> categories = [
    'My List',
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Thriller',
    'Romance',
    'Sci-Fi',
    'Documentary',
    'Animation',
    'Fantasy',
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Obx(() => _pages[controller.currentIndex.value]),
          bottomNavigationBar: Obx(
                () => Container(
              height: 70.h,
              decoration: BoxDecoration(
                color: AppColor.customDarkGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10.r)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(4, (index) {
                  final isSelected = controller.currentIndex.value == index;
                  return GestureDetector(
                    onTap: () => controller.currentIndex.value = index,
                    child: SizedBox(
                      width: 90.w,
                      height: 90.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            [ImageAssets.svg3, ImageAssets.svg4, ImageAssets.svg5, ImageAssets.svg6][index],
                            colorFilter: ColorFilter.mode(
                              isSelected ? AppColor.white : AppColor.customGray,
                              BlendMode.srcIn,
                            ),
                            width: 20.w,
                            height: 20.h,
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            ['Home', 'Search', 'Coming Soon', 'More'][index],
                            style: AppTextStyles.montserratSemiBold.copyWith(
                              fontSize: 12.sp,
                              color: isSelected ? AppColor.white : AppColor.customGray,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),

        // Category Overlay
        Obx(
              () => controller.showCategoryOverlay.value
              ? Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.9),
              child: Column(
                children: [
                  const Spacer(),

                  // Scrollable category list
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: categories.asMap().entries.map((entry) {
                          int index = entry.key;
                          String text = entry.value;

                          return Column(
                            children: [
                              GestureDetector(
                                onTapDown: (_) => controller.highlightedIndex.value = index,
                                onTapUp: (_) => controller.highlightedIndex.value = -1,
                                onTapCancel: () => controller.highlightedIndex.value = -1,
                                onTap: () {
                                  controller.selectedCategory.value = text;
                                  controller.showCategoryOverlay.value = false;
                                  print('Selected category: ${controller.selectedCategory.value}');
                                  if(controller.selectedCategory.value=="My List"){
controller.selectedCategory.value="Category";
                                    Get.to(Mylist(),transition: Transition.rightToLeft);
                                  }
                                },
                                child: Obx(
                                      () => AnimatedScale(
                                    duration: const Duration(milliseconds: 100),
                                    scale: controller.highlightedIndex.value == index ? 1.2 : 1.0,
                                    child: Text(
                                      text,
                                      style: AppTextStyles.montserratSemiBold.copyWith(
                                        fontSize: 20.sp,
                                        color: controller.selectedCategory.value == text
                                            ? AppColor.vividAmber
                                            : (controller.highlightedIndex.value == index
                                            ? AppColor.vividAmber
                                            : Colors.white),
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Close button
                  GestureDetector(
                    onTap: () => controller.showCategoryOverlay.value = false,
                    child: Container(
                      padding: EdgeInsets.all(18.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.close, size: 28.sp),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
