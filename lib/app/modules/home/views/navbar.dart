import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../res/fonts/fonts.dart';
import '../../settings/views/mylist.dart';
import '../controllers/home_controller.dart';
import '../controllers/navcontroller.dart';
import '../views/coming_soon.dart';
import '../views/home.dart';
import '../views/search.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../../res/colors/color.dart';
import '../../settings/views/more_menu.dart';

class Navbar extends StatelessWidget {
  Navbar({Key? key}) : super(key: key);

  final _pages = <Widget>[
    HomePage(),
    SearchScreen(),
    SearchScreen(), // Placeholder for Downloads
    ComingSoon(),
    MoreMenu(),
  ];

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
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10.r)],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                child: GNav(
                  gap: 5.w,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  backgroundColor: AppColor.customDarkGray,
                  color: AppColor.customGray,
                  activeColor: AppColor.black,
                  tabBackgroundGradient: LinearGradient(
                    colors: [AppColor.vividAmber, AppColor.sunnyYellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  tabBorderRadius: 20.r,
                  selectedIndex: controller.currentIndex.value,
                  onTabChange: (index) => controller.currentIndex.value = index,
                  tabs: [
                    GButton(icon: Icons.home_rounded, text: 'home_tab'.tr),
                    GButton(icon: Icons.search_rounded, text: 'search_tab'.tr),
                    GButton(icon: Icons.download_rounded, text: 'downloads_tab'.tr),
                    GButton(icon: Icons.movie_creation_rounded, text: 'coming_soon_tab'.tr),
                    GButton(icon: Icons.menu_rounded, text: 'more_tab'.tr),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Category Overlay (All & My List)
        Obx(
              () => controller.showCategoryOverlay.value
              ? Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.9),
              child: Column(
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // All
                          GestureDetector(
                            onTapDown: (_) => controller.highlightedIndex.value = 0,
                            onTapUp: (_) => controller.highlightedIndex.value = -1,
                            onTapCancel: () => controller.highlightedIndex.value = -1,
                            onTap: () {
                              controller.selectedCategory.value = 'all_category'.tr;
                              controller.showCategoryOverlay.value = false;
                              homeController.onGenreSelected('All');
                            },
                            child: Obx(() => AnimatedScale(
                              duration: const Duration(milliseconds: 100),
                              scale: controller.highlightedIndex.value == 0 ? 1.2 : 1.0,
                              child: Text(
                                'all_category'.tr,
                                style: AppTextStyles.montserratSemiBold.copyWith(
                                  fontSize: 20.sp,
                                  color: controller.selectedCategory.value == 'all_category'.tr ||
                                      controller.highlightedIndex.value == 0
                                      ? AppColor.vividAmber
                                      : Colors.white,
                                ),
                              ),
                            )),
                          ),
                          SizedBox(height: 20.h),

                          // My List
                          GestureDetector(
                            onTapDown: (_) => controller.highlightedIndex.value = 1,
                            onTapUp: (_) => controller.highlightedIndex.value = -1,
                            onTapCancel: () => controller.highlightedIndex.value = -1,
                            onTap: () {
                              controller.selectedCategory.value = 'my_list_category'.tr;
                              controller.showCategoryOverlay.value = false;
                              Get.to(() => Mylist(), transition: Transition.rightToLeft);
                            },
                            child: Obx(() => AnimatedScale(
                              duration: const Duration(milliseconds: 100),
                              scale: controller.highlightedIndex.value == 1 ? 1.2 : 1.0,
                              child: Text(
                                'my_list_category'.tr,
                                style: AppTextStyles.montserratSemiBold.copyWith(
                                  fontSize: 20.sp,
                                  color: controller.selectedCategory.value == 'my_list_category'.tr ||
                                      controller.highlightedIndex.value == 1
                                      ? AppColor.vividAmber
                                      : Colors.white,
                                ),
                              ),
                            )),
                          ),
                          SizedBox(height: 20.h),

                          // Dynamic genres
                          ...homeController.genre.asMap().entries.map((entry) {
                            int index = entry.key + 2;
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
                                    homeController.onGenreSelected(text);
                                  },
                                  child: Obx(() => AnimatedScale(
                                    duration: const Duration(milliseconds: 100),
                                    scale: controller.highlightedIndex.value == index ? 1.2 : 1.0,
                                    child: Text(
                                      text,
                                      style: AppTextStyles.montserratSemiBold.copyWith(
                                        fontSize: 20.sp,
                                        color: controller.selectedCategory.value == text ||
                                            controller.highlightedIndex.value == index
                                            ? AppColor.vividAmber
                                            : Colors.white,
                                      ),
                                    ),
                                  )),
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
                  GestureDetector(
                    onTap: () => controller.showCategoryOverlay.value = false,
                    child: Container(
                      padding: EdgeInsets.all(18.w),
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
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