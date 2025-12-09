import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Nuweli/app/modules/home/controllers/home_controller.dart';
import 'package:Nuweli/app/modules/home/views/coming_soon.dart';
import 'package:Nuweli/app/modules/home/views/home.dart';
import 'package:Nuweli/app/modules/home/views/search.dart';
import 'package:Nuweli/app/modules/settings/views/mylist.dart';
import 'package:Nuweli/app/res/fonts/fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../res/colors/color.dart';
import '../../settings/views/more_menu.dart';
import '../controllers/navcontroller.dart';

class Navbar extends StatelessWidget {
  Navbar({Key? key}) : super(key: key);

  final _pages = <Widget>[HomePage(), SearchScreen(),SearchScreen(), ComingSoon(), MoreMenu()];
  final NavController controller = Get.find();
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Obx(() => _pages[controller.currentIndex.value]),
          bottomNavigationBar: Obx(
                () => Container(
              decoration: BoxDecoration(
                color: AppColor.customDarkGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10.r),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                child: GNav(
                  gap: 8.w,
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  backgroundColor: AppColor.customDarkGray,
                  color: AppColor.customGray,
                  activeColor: AppColor.black,
                  tabBackgroundGradient: LinearGradient(
                    colors: [
                      AppColor.vividAmber,
                      AppColor.sunnyYellow,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  tabBorderRadius: 20.r,
                  selectedIndex: controller.currentIndex.value,
                  onTabChange: (index) {
                    controller.currentIndex.value = index;
                  },
                  tabs: [
                    GButton(
                      icon: Icons.home_rounded,
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.search_rounded,
                      text: 'Search',
                    ),
                    GButton(
                      icon: Icons.download_rounded,
                      text: 'Downloads',
                    ),
                    GButton(
                      icon: Icons.movie_creation_rounded,
                      text: 'Coming Soon',
                    ),
                    GButton(
                      icon: Icons.menu_rounded,
                      text: 'More',
                    ),
                  ],
                ),
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
                        // Scrollable genre list
                        Expanded(
                          flex: 5,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // All Movies item
                                GestureDetector(
                                  onTapDown: (_) =>
                                      controller.highlightedIndex.value = 0,
                                  onTapUp: (_) =>
                                      controller.highlightedIndex.value = -1,
                                  onTapCancel: () =>
                                      controller.highlightedIndex.value = -1,
                                  onTap: () {
                                    controller.selectedCategory.value = 'All';
                                    controller.showCategoryOverlay.value =
                                        false;
                                    homeController.onGenreSelected('All');
                                    print('Selected category: All');
                                  },
                                  child: Obx(
                                    () => AnimatedScale(
                                      duration: const Duration(
                                        milliseconds: 100,
                                      ),
                                      scale:
                                          controller.highlightedIndex.value == 0
                                          ? 1.2
                                          : 1.0,
                                      child: Text(
                                        'All',
                                        style: AppTextStyles.montserratSemiBold
                                            .copyWith(
                                              fontSize: 20.sp,
                                              color:
                                                  controller
                                                          .selectedCategory
                                                          .value ==
                                                      'All'
                                                  ? AppColor.vividAmber
                                                  : (controller
                                                                .highlightedIndex
                                                                .value ==
                                                            0
                                                        ? AppColor.vividAmber
                                                        : Colors.white),
                                              decoration: TextDecoration.none,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                // My List item
                                GestureDetector(
                                  onTapDown: (_) =>
                                      controller.highlightedIndex.value = 1,
                                  onTapUp: (_) =>
                                      controller.highlightedIndex.value = -1,
                                  onTapCancel: () =>
                                      controller.highlightedIndex.value = -1,
                                  onTap: () {
                                    controller.selectedCategory.value =
                                        'My List';
                                    controller.showCategoryOverlay.value =
                                        false;
                                    print('Selected category: My List');
                                    Get.to(
                                      () => Mylist(),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  child: Obx(
                                    () => AnimatedScale(
                                      duration: const Duration(
                                        milliseconds: 100,
                                      ),
                                      scale:
                                          controller.highlightedIndex.value == 1
                                          ? 1.2
                                          : 1.0,
                                      child: Text(
                                        'My List',
                                        style: AppTextStyles.montserratSemiBold
                                            .copyWith(
                                              fontSize: 20.sp,
                                              color:
                                                  controller
                                                          .selectedCategory
                                                          .value ==
                                                      'My List'
                                                  ? AppColor.vividAmber
                                                  : (controller
                                                                .highlightedIndex
                                                                .value ==
                                                            1
                                                        ? AppColor.vividAmber
                                                        : Colors.white),
                                              decoration: TextDecoration.none,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                // Dynamic genres from HomeController
                                ...homeController.genre.asMap().entries.map((
                                  entry,
                                ) {
                                  int index =
                                      entry.key +
                                      2; // Offset by 2 due to All and My List
                                  String text = entry.value;

                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTapDown: (_) =>
                                            controller.highlightedIndex.value =
                                                index,
                                        onTapUp: (_) =>
                                            controller.highlightedIndex.value =
                                                -1,
                                        onTapCancel: () =>
                                            controller.highlightedIndex.value =
                                                -1,
                                        onTap: () {
                                          controller.selectedCategory.value =
                                              text;
                                          controller.showCategoryOverlay.value =
                                              false;
                                          homeController.onGenreSelected(text);
                                          print('Selected genre: $text');
                                        },
                                        child: Obx(
                                          () => AnimatedScale(
                                            duration: const Duration(
                                              milliseconds: 100,
                                            ),
                                            scale:
                                                controller
                                                        .highlightedIndex
                                                        .value ==
                                                    index
                                                ? 1.2
                                                : 1.0,
                                            child: Text(
                                              text,
                                              style: AppTextStyles
                                                  .montserratSemiBold
                                                  .copyWith(
                                                    fontSize: 20.sp,
                                                    color:
                                                        controller
                                                                .selectedCategory
                                                                .value ==
                                                            text
                                                        ? AppColor.vividAmber
                                                        : (controller
                                                                      .highlightedIndex
                                                                      .value ==
                                                                  index
                                                              ? AppColor
                                                                    .vividAmber
                                                              : Colors.white),
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Close button
                        GestureDetector(
                          onTap: () =>
                              controller.showCategoryOverlay.value = false,
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
