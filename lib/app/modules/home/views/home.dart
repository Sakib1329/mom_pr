import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mompr_em/app/modules/home/controllers/home_controller.dart';
import 'package:mompr_em/app/modules/home/controllers/navcontroller.dart';
import 'package:mompr_em/app/modules/home/views/category_home.dart';
import 'package:mompr_em/app/modules/home/views/comedies.dart';
import 'package:mompr_em/app/modules/home/views/drama.dart';
import 'package:mompr_em/app/modules/home/views/liveshow.dart';
import 'package:mompr_em/app/modules/home/views/movie.dart';
import 'package:mompr_em/app/modules/home/views/music_video.dart';
import 'package:mompr_em/app/modules/settings/views/mylist.dart';
import 'package:mompr_em/app/modules/settings/views/profile.dart';
import 'package:mompr_em/app/modules/settings/views/subscribtion.dart';

import '../../../res/assets/imageassets.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../widgets/popupwidget.dart';
import '../widgets/subscribe_drawer.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.find();
  final NavController navController = Get.find();

  HomePage({super.key});

  final _pages = <Widget>[
    CategoryHome(),
    Movie(),
    Drama(),
    MusicVideo(),
    Liveshow(),
    Comedies(),
  ];

  final _titles = [
    'Home',
    'Movie',
    'Series',
    'Music Video',
    'Tv Shows',
    'Comedies',
  ];
  final _icons = [
    ImageAssets.svg12,
    ImageAssets.svg8,
    ImageAssets.svg9,
    ImageAssets.svg10,
    ImageAssets.svg11,
    ImageAssets.svg7,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Obx(
        () => Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: AppColor.black,
                    automaticallyImplyLeading: false,
                    floating: true,
                    snap: true,
                    pinned: false,
                    toolbarHeight: 70.h,
                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/svg1.svg',
                              height: 30.h,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    CupertinoIcons.search,
                                    color: Colors.white,
                                  ),
                                ),
                                controller.issubscribed.value
                                    ? GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 5.h,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            gradient: const LinearGradient(
                                              colors: [
                                                AppColor.vividAmber,
                                                AppColor.sunnyYellow,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                ImageAssets.svg26,
                                              ), // crown icon
                                              SizedBox(width: 8.w),
                                              Text(
                                                "Subscribe",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),

                                        ),
                                  onTap: (){
                                          Get.to(Subscribtion(),transition: Transition.rightToLeft);
                                  },
                                      )
                                    : ProfileDropdown(
                                  userName: "Awad Arman",
                                  userImageUrl: ImageAssets.person,
                                  onProfileTap: () => Get.to(ProfilePage(),transition: Transition.rightToLeft),
                                  onMyListTap: () =>  Get.to(Mylist(),transition: Transition.rightToLeft),
                                  onWatchHistoryTap: () => print("Watch History tapped"),
                                  onUnsubscribeTap: (){
                                    showDeleteConfirmationPopup(
                                      context: context,
                                      buttontext: "Unsubscribe",
                                      title: 'Unsubscribe?',
                                      subtitle: 'Are you sure want to Unsubscribe?',
                                      onDelete: () {

                                      },
                                      arguments: '',
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),

                        /// 🔹 If Home (index 0) → show full list
                        /// 🔹 Else → show only selected tab + "Category"
                        Obx(() {
                          if (controller.currentIndex.value == 0) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(_pages.length, (index) {
                                  final isSelected =
                                      controller.currentIndex.value == index;
                                  return GestureDetector(
                                    onTap: () =>
                                        controller.currentIndex.value = index,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: 15.w,
                                        left: 5.w,
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            _icons[index],
                                            colorFilter: ColorFilter.mode(
                                              isSelected
                                                  ? AppColor.white
                                                  : AppColor.customGray,
                                              BlendMode.srcIn,
                                            ),
                                            width: 20.w,
                                            height: 20.h,
                                          ),
                                          SizedBox(width: 6.w),
                                          Text(
                                            _titles[index],
                                            style: AppTextStyles
                                                .montserratSemiBold
                                                .copyWith(
                                                  fontSize: 12.sp,
                                                  color: isSelected
                                                      ? AppColor.white
                                                      : AppColor.customGray,
                                                  fontWeight: isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          } else {
                            /// 🔹 Show only selected title + extra button
                            final index = controller.currentIndex.value;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.charcoal,
                                      border: Border.all(
                                        width: 1.w,
                                        color: AppColor.white,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(2.w),
                                    child: Icon(
                                      Icons.close,
                                      color: AppColor.white,
                                    ),
                                  ),
                                  onTap: () {
                                    controller.currentIndex.value = 0;
                                  },
                                ),
                                SizedBox(width: 6.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.charcoal,
                                    borderRadius: BorderRadius.circular(200.r),
                                    border: Border.all(
                                      width: 2,
                                      color: AppColor.white,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        _icons[index],
                                        colorFilter: ColorFilter.mode(
                                          AppColor.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        _titles[index],
                                        style: AppTextStyles.montserratSemiBold
                                            .copyWith(
                                              fontSize: 12.sp,
                                              color: AppColor.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                GestureDetector(
                                  onTap: () {
                                    navController.showCategoryOverlay.value =
                                        true;
                                  },

                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.charcoal,
                                      borderRadius: BorderRadius.circular(
                                        200.r,
                                      ),
                                      border: Border.all(
                                        width: 2,
                                        color: AppColor.white,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          navController.selectedCategory.value,
                                          style: AppTextStyles.montserratBold
                                              .copyWith(
                                                fontSize: 12.sp,
                                                color: AppColor.white,
                                              ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: AppColor.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        }),

                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ];
              },
              body: _pages[controller.currentIndex.value],
            ),
          ],
        ),
      ),
    );
  }


}
