import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mompr_em/app/modules/home/views/details.dart';
import 'package:mompr_em/app/res/colors/color.dart';
import 'package:mompr_em/app/res/fonts/fonts.dart';

class CategoryHomeWidget extends StatefulWidget {
  final Map<String, List<String>> bannerMovies;
  final Map<String, List<String>> categoryImages;
  final List<String> previewImages;

  const CategoryHomeWidget({
    super.key,
    required this.bannerMovies,
    required this.categoryImages,
    required this.previewImages,
  });

  @override
  State<CategoryHomeWidget> createState() => _CategoryHomeWidgetState();
}

class _CategoryHomeWidgetState extends State<CategoryHomeWidget> {
  int _currentBannerIndex = 0;
  late List<String> bannerImages;
  late Map<String, List<String>> movieTypesMap;

  @override
  void initState() {
    super.initState();
    bannerImages = widget.bannerMovies.keys.toList();
    movieTypesMap = widget.bannerMovies;
  }

  @override
  Widget build(BuildContext context) {
    String currentBanner = bannerImages[_currentBannerIndex];
    List<String> currentMovieTypes = movieTypesMap[currentBanner] ?? [];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: 0.55.sh,
          flexibleSpace: FlexibleSpaceBar(
            background: Column(
              children: [
                SizedBox(height: 10.h,),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.w),
                  child: CarouselSlider(
                    items: bannerImages
                        .map(
                          (img) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.r),
                          image: DecorationImage(
                            image: AssetImage(img),
                            fit: BoxFit.fill
                          ),
                        ),
                      ),
                    )
                        .toList(),
                    options: CarouselOptions(
                      height: 0.53.sh * 0.8,
                      viewportFraction: 1.0,

                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentBannerIndex = index;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15.h * 0.8),
                SizedBox(
                  height: 30.h * 0.8,
                  child: Center(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: currentMovieTypes.length,
                      padding: EdgeInsets.symmetric(horizontal: 15.w * 0.8),
                      separatorBuilder: (_, __) => SizedBox(width: 10.w * 0.8),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w * 0.8,
                            vertical: 4.h * 0.8,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  currentMovieTypes[index],
                                  style: AppTextStyles.montserratBold.copyWith(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 4.w), // spacing between text and dot
                                Text(
                                  "•", // centered dot
                                  style: AppTextStyles.montserratBold.copyWith(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.h * 0.8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w * 0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _appBarButton(Icons.add, "My List"),
                      _playButton(),
                      _appBarButton(Icons.info_outline, "Info"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding:
          EdgeInsets.symmetric(horizontal: 15.w * 0.8, vertical: 10.h * 0.8),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
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
                    SizedBox(
                      height: 150.h * 0.8,
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.previewImages.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 12.w * 0.8),
                        itemBuilder: (context, index) {
                          return Container(
                            width: 120.w * 0.8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(widget.previewImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h * 0.8),
                for (var entry in widget.categoryImages.entries) ...[
                  _buildCategory(entry.key, entry.value),
                  SizedBox(height: 15.h * 0.8),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategory(String title, List<String> images) {
    return GestureDetector(
      onTap: (){
        Get.to(MovieDetailsPage(),transition: Transition.rightToLeft);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.montserratBold.copyWith(
              fontSize: 18.sp * 0.8,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15.h * 0.8),
          SizedBox(
            height: 200.h * 0.8,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (context, index) => SizedBox(width: 12.w * 0.8),
              itemBuilder: (context, index) {
                return Container(
                  width: 160.w * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r * 0.8),
                    image: DecorationImage(
                      image: AssetImage(images[index]),
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

  Widget _appBarButton(IconData icon, String label) {
    return Column(
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
    );
  }

  Widget _playButton() {
    return Container(
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
    );
  }
}
