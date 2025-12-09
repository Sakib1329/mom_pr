import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:Nuweli/app/modules/home/controllers/home_controller.dart';
import 'package:Nuweli/app/res/colors/color.dart';
import 'package:Nuweli/app/res/fonts/fonts.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CategoryHomeWidget extends StatefulWidget {
  final Map<String, List<String>> bannerMovies;
  final Map<String, List<Map<String, dynamic>>> categoryImages;
  final List<Map<String, dynamic>> previewItems; // Updated to handle id, alias, poster
  final HomeController homeController;

  const CategoryHomeWidget({
    super.key,
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
  late Map<String, List<String>> movieTypesMap;
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
    movieTypesMap = widget.bannerMovies;
  }

  void _updateBannerIndex(int index) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _currentBannerIndex = index;
        });
      }
    });
  }

  Map<String, dynamic>? _getBannerDetails() {
    for (var category in widget.categoryImages.entries) {
      for (var item in category.value) {
        if (item['poster'] == bannerImages[_currentBannerIndex]) {
          return item;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String currentBanner = bannerImages.isNotEmpty ? bannerImages[_currentBannerIndex] : '';
    List<String> currentMovieTypes = movieTypesMap[currentBanner] ?? [];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          // We'll keep the expandedHeight but the inner structure changes
          expandedHeight: 0.55.sh,
          flexibleSpace: FlexibleSpaceBar(
            background: Column(
              children: [
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CarouselSlider(
                    items: bannerImages.map((img) {
                      return AspectRatio(
                        aspectRatio: 6 / 7,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.white70,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            // ************************************************
                            // THE CORE CHANGE: Using a Stack for layering
                            // ************************************************
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // 1. The main poster image (Background)
                                CachedNetworkImage(
                                  imageUrl: img,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  // ... other image properties ...
                                  memCacheWidth: (MediaQuery.of(context).size.width * MediaQuery.of(context).devicePixelRatio).toInt(),
                                  memCacheHeight: (0.53.sh * MediaQuery.of(context).devicePixelRatio).toInt(),
                                  fadeInDuration: const Duration(milliseconds: 300),
                                  cacheManager: customCacheManager,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.w,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[800]?.withOpacity(0.1),
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                      size: 30.sp,
                                    ),
                                  ),
                                ),

                                // 2. A semi-transparent black gradient at the bottom for text contrast (Optional)
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 0.25.sh,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.4),
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // 3. The layered text and buttons (Foreground Elements)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20.h, left: 15.w, right: 15.w),
                                  child: Align(
                              alignment: AlignmentGeometry.bottomCenter,
                                child:       Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          // Watch Now Button (Placeholder for your _playButton)
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 8.w),
                                              child: _playButton(widget.homeController),
                                            ),
                                          ),
                                          // My List Button (Placeholder for your _appBarButton)
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 8.w),
                                              // Assuming _appBarButton is for "My List" in the old context
                                              child: _appBarButton(Icons.add, "My List", widget.homeController),
                                            ),
                                          ),
                                        ],
                                      ),

                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      // height might need adjustment since the elements are now inside the item
                      height: 0.53.sh,
                      viewportFraction: 1.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      onPageChanged: (index, reason) {
                        _updateBannerIndex(index);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),


        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 15.w * 0.8, vertical: 10.h * 0.8),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                if (widget.previewItems.isNotEmpty) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Previews",
                        style: AppTextStyles.montserratBold.copyWith(
                          fontSize: 25.sp * 0.8,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h * 0.8),
                      SizedBox(
                        height: 120.h * 0.8,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.previewItems.length,
                          separatorBuilder: (context, index) => SizedBox(width: 12.w * 0.8),
                          itemBuilder: (context, index) {
                            final item = widget.previewItems[index];
                            final imageUrl = item['poster'] as String;
                            final id = item['id'] as int;
                            final alias = item['alias'] as String;
                            return GestureDetector(
                              onTap: () async {
                                if (alias == "movie") {
                                  await widget.homeController.fetchMovieDetails(id, alias);
                                } else {
                                  await widget.homeController.fetchSeriesDetails(id, alias);
                                }
                              },
                              child: Container(
                                width: 130.w * 0.8,
                                height: 130.h * 0.8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    width: 120.w * 0.8,
                                    height: 120.h * 0.8,
                                    memCacheWidth: (120.w * 0.8 * MediaQuery.of(context).devicePixelRatio).toInt(),
                                    memCacheHeight: (120.h * 0.8 * MediaQuery.of(context).devicePixelRatio).toInt(),
                                    fadeInDuration: const Duration(milliseconds: 300),
                                    cacheManager: customCacheManager,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.w,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      color: Colors.grey[800],
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                        size: 30.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h * 0.8),
                ],
                for (var entry in widget.categoryImages.entries) ...[
                  _buildCategory(
                    entry.key,
                    entry.value,
                    widget.homeController,
                  ),
                  SizedBox(height: 15.h * 0.8),
                ],
              ],
            ),
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
              fontSize: 18.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5.h * 0.8),
          SizedBox(
            height: 200.h * 0.8,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (context, index) => SizedBox(width: 8.w * 0.8),
              itemBuilder: (context, index) {
                final item = items[index];
                final imageUrl = item['poster'] as String;
                final id = item['id'] as int;
                final alias = item['alias'] as String;
                return GestureDetector(
                  onTap: () async {
                    if (alias == "movie") {
                      await homeController.fetchMovieDetails(id, alias);
                    } else {
                      await homeController.fetchSeriesDetails(id, alias);
                    }
                  },
                  child: Container(
                    width: 125.w * 0.8,
                    height: 200.h * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r * 0.8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.r * 0.8),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        width: 160.w * 0.8,
                        height: 200.h * 0.8,
                        memCacheWidth: (160.w * 0.8 * MediaQuery.of(context).devicePixelRatio).toInt(),
                        memCacheHeight: (200.h * 0.8 * MediaQuery.of(context).devicePixelRatio).toInt(),
                        fadeInDuration: const Duration(milliseconds: 300),
                        cacheManager: customCacheManager,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.w,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[800],
                          child: Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 30.sp,
                          ),
                        ),
                      ),
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

  Widget _appBarButton(IconData icon, String label, HomeController homeController) {
    return GestureDetector(
      onTap: () async {
        final bannerDetails = _getBannerDetails();
        if (bannerDetails == null) return;
        final id = bannerDetails['id'] as int;
        final alias = bannerDetails['alias'] as String;

        if (label == "Info") {
          if (alias == "movie") {
            await homeController.fetchMovieDetails(id, alias);
          } else {
            await homeController.fetchSeriesDetails(id, alias);
          }
        } else if (label == "My List") {
          await homeController.addToWatchLater(id, alias);
        }
      },
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 30.sp * 0.8),
          SizedBox(height: 4.h * 0.8),
          Text(
            label,
            style: AppTextStyles.montserratBold.copyWith(
              fontSize: 16.sp * 0.8,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _playButton(HomeController homeController) {
    return GestureDetector(
      onTap: () async {
        final bannerDetails = _getBannerDetails();
        if (bannerDetails == null) return;
        final id = bannerDetails['id'] as int;
        final alias = bannerDetails['alias'] as String;
        if (alias == "movie") {
          await homeController.fetchMovieDetails(id, alias);
        } else {
          await homeController.fetchSeriesDetails(id, alias);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 28.w * 0.8, vertical: 8.h * 0.8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.vividAmber, AppColor.sunnyYellow],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10.r * 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow, color: Colors.black, size: 30.sp * 0.8),
            SizedBox(width: 8.w * 0.8),
            Text(
              "Play",
              style: AppTextStyles.montserratBold.copyWith(
                fontSize: 18.sp * 0.8,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}