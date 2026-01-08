import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/Get.dart';
import 'package:Nuweli/app/modules/home/controllers/home_controller.dart';
import 'package:Nuweli/app/res/colors/color.dart';
import 'package:Nuweli/app/res/fonts/fonts.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CategoryHomeWidget extends StatefulWidget {
  final Map<String, List<String>> bannerMovies;
  final Map<String, List<Map<String, dynamic>>> categoryImages;
  final List<Map<String, dynamic>> previewItems;
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
  final customCacheManager = CacheManager(Config('customCacheKey', maxNrOfCacheObjects: 200, stalePeriod: const Duration(days: 30)));

  @override
  void initState() {
    super.initState();
    bannerImages = widget.bannerMovies.keys.toList();
    movieTypesMap = widget.bannerMovies;
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

  void _onBannerTap() {
    final details = _getBannerDetails();
    if (details == null) return;
    final int id = details['id'] as int;
    final String alias = details['alias'] as String;
    if (alias == "movie") {
      widget.homeController.fetchMovieDetails(id, alias);
    } else {
      widget.homeController.fetchSeriesDetails(id, alias);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: 0.6.sh,
          backgroundColor: Colors.black,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(


              ),
              child: CarouselSlider(
                items: bannerImages.map((img) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: AspectRatio(
                      aspectRatio: 6 / 7,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.9),
                            width: 1.w,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: GestureDetector(
                            onTap: _onBannerTap,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                /// POSTER
                                CachedNetworkImage(
                                  imageUrl: img,
                                  fit: BoxFit.cover,
                                  memCacheWidth: (MediaQuery.of(context).size.width *
                                      MediaQuery.of(context).devicePixelRatio)
                                      .toInt(),
                                  memCacheHeight:
                                  (0.6.sh *
                                      MediaQuery.of(context).devicePixelRatio)
                                      .toInt(),
                                  placeholder: (_, __) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (_, __, ___) => Container(
                                    color: Colors.white70,
                                    child: const Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                      size: 28,
                                    ),
                                  ),
                                ),

                                /// BUTTONS
                                Positioned(
                                  bottom: 18.h,
                                  left: 16.w,
                                  right: 16.w,
                                  child: Row(
                                    children: [
                                      /// WATCH NOW
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: _onBannerTap,
                                          child: Container(
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(8.r),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'watch_now'.tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 5.w),

                                      /// MY LIST
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            final details = _getBannerDetails();
                                            if (details == null) return;
                                            final int id =
                                            details['id'] as int;
                                            final String alias =
                                            details['alias'] as String;
                                            await widget.homeController
                                                .addToWatchLater(id, alias);
                                          },
                                          child: Container(
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color:
                                              Colors.grey.withOpacity(0.7),
                                              borderRadius:
                                              BorderRadius.circular(8.r),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 18.sp,
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  'my_list_banner'.tr,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 0.6.sh,
                  viewportFraction: 0.88,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayCurve: Curves.easeInOut,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) =>
                      _updateBannerIndex(index),
                ),
              )

            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 15.w * 0.8, vertical: 10.h * 0.8),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                if (widget.previewItems.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('previews'.tr, style: AppTextStyles.montserratBold.copyWith(fontSize: 25.sp * 0.8, color: Colors.white)),
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
                              child: SizedBox(
                                width: 130.w * 0.8,
                                height: 130.h * 0.8,

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.r),
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    memCacheWidth:
                                    (120.w * 0.8 * MediaQuery.of(context).devicePixelRatio)
                                        .toInt(),
                                    memCacheHeight:
                                    (120.h * 0.8 * MediaQuery.of(context).devicePixelRatio)
                                        .toInt(),
                                    fadeInDuration: const Duration(milliseconds: 300),
                                    cacheManager: customCacheManager,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      color: Colors.grey[800],
                                      child: const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                        size: 30,
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
                for (var entry in widget.categoryImages.entries)
                  _buildCategory(entry.key.tr, entry.value, widget.homeController),
                SizedBox(height: 15.h * 0.8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategory(String title, List<Map<String, dynamic>> items, HomeController homeController) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.montserratBold.copyWith(fontSize: 18.sp, color: Colors.white)),
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
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r * 0.8)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.r * 0.8),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        memCacheWidth: (160.w * 0.8 * MediaQuery.of(context).devicePixelRatio).toInt(),
                        memCacheHeight: (200.h * 0.8 * MediaQuery.of(context).devicePixelRatio).toInt(),
                        fadeInDuration: const Duration(milliseconds: 300),
                        cacheManager: customCacheManager,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                        errorWidget: (context, url, error) => Container(color: Colors.grey[800], child: const Icon(Icons.image, color: Colors.grey, size: 30)),
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
}