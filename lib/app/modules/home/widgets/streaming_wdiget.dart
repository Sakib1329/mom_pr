import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:Nuweli/app/modules/home/controllers/home_controller.dart';
import 'package:Nuweli/app/res/colors/color.dart';
import 'package:Nuweli/app/res/fonts/fonts.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../models/movie_model.dart';
import '../views/details.dart';
import '../views/videoscreen.dart';

class CategoryHomeWidget extends StatefulWidget {
  final List<Movie> continueWatchingList;
  final Map<String, List<String>> bannerMovies;
  final Map<String, List<Map<String, dynamic>>> categoryImages;
  final List<Map<String, dynamic>> previewItems;
  final HomeController homeController;

  const CategoryHomeWidget({
    super.key,
    required this.continueWatchingList,
    required this.bannerMovies,
    required this.categoryImages,
    required this.previewItems,
    required this.homeController,
  });

  @override
  State<CategoryHomeWidget> createState() => _CategoryHomeWidgetState();
}

class _CategoryHomeWidgetState extends State<CategoryHomeWidget> {
  int _currentBannerIndex = 0;
  late List<String> bannerImages;
  final customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      maxNrOfCacheObjects: 200,
      stalePeriod: const Duration(days: 30),
    ),
  );

  @override
  void initState() {
    super.initState();
    bannerImages = widget.bannerMovies.keys.toList();
  }

  void _updateBannerIndex(int index) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _currentBannerIndex = index);
    });
  }

  Map<String, dynamic>? _getBannerDetails() {
    if (bannerImages.isEmpty) return null;
    final currentPoster = bannerImages[_currentBannerIndex];
    for (var category in widget.categoryImages.values) {
      for (var item in category) {
        if (item['poster'] == currentPoster) return item;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        /// BANNER
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: 0.6.sh,
          backgroundColor: Colors.black,
          flexibleSpace: FlexibleSpaceBar(
            background: CarouselSlider(
              items: bannerImages.map((img) => _buildBannerItem(img)).toList(),
              options: CarouselOptions(
                height: 0.6.sh,
                viewportFraction: 0.88,
                autoPlay: true,
                onPageChanged: (index, _) => _updateBannerIndex(index),
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              /// 1. CONTINUE WATCHING (NETFLIX STYLE)
              if (widget.continueWatchingList.isNotEmpty)
                _buildContinueWatchingRow(),

              /// 2. PREVIEWS
              if (widget.previewItems.isNotEmpty) _buildPreviewSection(),

              SizedBox(height: 15.h),

              /// 3. CATEGORIES
              for (var entry in widget.categoryImages.entries)
                _buildCategory(
                  entry.key.tr,
                  entry.value,
                  widget.homeController,
                ),

              SizedBox(height: 20.h),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerItem(String img) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(imageUrl: img, fit: BoxFit.cover),
            Positioned(
              bottom: 18.h,
              left: 16.w,
              right: 16.w,
              child: Row(
                children: [
                  Expanded(
                    child: _buildBannerButton(
                      'watch_now'.tr,
                      Colors.white,
                      Colors.black,
                      () {
                        final d = _getBannerDetails();
                        if (d != null) {
                          Get.to(
                                () => MovieDetailsPage(),
                            transition: Transition.rightToLeftWithFade,
                          );
                          widget.homeController.fetchMovieDetails(
                            d['id'],
                            d['alias'],
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _buildBannerButton(
                      'my_list_banner'.tr,
                      Colors.grey.withOpacity(0.8),
                      Colors.white,
                      () {
                        final d = _getBannerDetails();
                        if (d != null) {
                          widget.homeController.addToWatchLater(
                            d['id'],
                            d['alias'],
                          );
                        }
                      },

                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerButton(
    String text,
    Color bg,
    Color textCol,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: textCol,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  Widget _buildContinueWatchingRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'continue_watching'.tr,
            style: AppTextStyles.montserratBold.copyWith(
              fontSize: 18.sp,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            scrollDirection: Axis.horizontal,
            itemCount: widget.continueWatchingList.length,
            separatorBuilder: (_, __) => SizedBox(width: 14.w),
            itemBuilder: (context, index) {
              final movie = widget.continueWatchingList[index];
              final int percent = (movie.watchProgress * 100).toInt();

              return GestureDetector(
                onTap: () =>
                    Get.to(() => VideoPlayerScreen(fileUuid: movie.fileUuid)),
                child: Container(
                  width: 160.w,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white.withOpacity(0.6),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1.w,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Poster Image
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9.r),
                          child: CachedNetworkImage(
                            imageUrl: movie.firstPosterUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // BOTTOM ROW: Bar and Percentage
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(
                              0.7,
                            ), // Darker background for readability
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(9.r),
                              bottomRight: Radius.circular(9.r),
                            ),
                          ),
                          child: Row(
                            children: [
                              // 1. Progress Bar
                              Expanded(
                                child: Container(
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: movie.watchProgress.clamp(
                                      0.0,
                                      1.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.vividAmber,
                                        borderRadius: BorderRadius.circular(
                                          2.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              // 2. Percentage Text
                              Text(
                                "$percent%",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
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
            },
          ),
        ),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget _buildPreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'previews'.tr,
          style: AppTextStyles.montserratBold.copyWith(
            fontSize: 20.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.previewItems.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final item = widget.previewItems[index];
              return GestureDetector(
                onTap: () {
                  Get.to(
                        () => MovieDetailsPage(),
                    transition: Transition.rightToLeftWithFade,
                  );
                  widget.homeController.fetchMovieDetails(
                    item['id'],
                    item['alias'],
                  );


                },
                child: Container(
                  width: 100.r,
                  height: 120.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(item['poster']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategory(
    String title,
    List<Map<String, dynamic>> items,
    HomeController homeController,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.montserratBold.copyWith(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 140.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(width: 7.w),
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(
                      () => MovieDetailsPage(),
                      transition: Transition.rightToLeftWithFade,
                    );
                    homeController.fetchMovieDetails(item['id'], item['alias']);
                  },

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: CachedNetworkImage(
                      imageUrl: item['poster'],
                      width: 97.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
