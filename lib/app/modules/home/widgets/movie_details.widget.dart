import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';


class MovieDetailsWidget extends StatelessWidget {
  final String title;
  final String year;
  final String duration;
  final String genre;
  final String posterUrl;
  final String description;
  final List<MovieItem> relatedMovies;
  final List<MovieItem> recentReleases;

  const MovieDetailsWidget({
    Key? key,
    required this.title,
    required this.year,
    required this.duration,
    required this.genre,
    required this.posterUrl,
    required this.description,
    required this.relatedMovies,
    required this.recentReleases,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.black,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SizedBox(height: 10.h,),
            Stack(
              children: [
                // Poster
                Container(
                  height: 300.h, // 10% smaller than 400
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(posterUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Gradient Overlay
                Container(
                  height: 300.h,
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
                // Play Button
                Positioned(
                  top: 135.h, // moved up 10%
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 65.w,
                      height: 65.w,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.play_arrow, color: Colors.white, size: 36.sp),
                    ),
                  ),
                ),
              ],
            ),

            // Info Section
            Padding(
              padding: EdgeInsets.all(14.w), // smaller padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.translucentWhite,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 7.h),

                  // Year + Duration
                  Text(
                    '$year • $duration',
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.customGray,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Genre
                  Text(
                    genre,
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.customGray,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 18.h),

                  // Action Buttons
                  Row(
                    children: [


                      Column(children: [
                        Icon(Icons.add, color: AppColor.customDarkGray2, size: 30.sp),
                        SizedBox(height: 5.h,),
                        Text(
                          'My List',
                          style: AppTextStyles.montserratSemiBold.copyWith(
                            color: AppColor.customDarkGray2,
                            fontSize: 13.sp,
                          ),
                        ),

                      ],),
                      SizedBox(width: 30.w),
                      Column(children: [
                        Icon(Icons.share, color: AppColor.customDarkGray2, size: 30.sp),
                        SizedBox(height: 5.h,),
                        Text(
                          'Share',
                          style: AppTextStyles.montserratSemiBold.copyWith(
                            color: AppColor.customDarkGray2,
                            fontSize: 13.sp,
                          ),
                        ),

                      ],),

                    ],
                  ),
                  SizedBox(height: 18.h),

                  // Description
                  Text(
                    'Description',
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.translucentWhite,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    description,
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.customGray,
                      fontSize: 13.sp,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 27.h),

                  // Related Movies
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Related Movies',
                        style: AppTextStyles.montserratSemiBold.copyWith(
                          color: AppColor.translucentWhite,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          
                        },
                        child: Row(
                          children: [
                            Text(
                              'See all',
                              style: AppTextStyles.montserratSemiBold.copyWith(
                                color: Colors.white,
                                fontSize: 13.sp,
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            Icon(Icons.arrow_forward,color: Colors.red,),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 11.h),

                  // Related Movies List
                  SizedBox(
                    height: 180.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: relatedMovies.length,
                      itemBuilder: (context, index) {
                        return MovieCard(movie: relatedMovies[index]);
                      },
                    ),
                  ),
                  SizedBox(height: 27.h),

                  // Recent Releases
                  Text(
                    'Releases in the Past Year',
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.translucentWhite,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 11.h),

                  // Recent Releases List
                  SizedBox(
                    height: 180.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recentReleases.length,
                      itemBuilder: (context, index) {
                        return MovieCard(movie: recentReleases[index]);
                      },
                    ),
                  ),
                  SizedBox(height: 18.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final MovieItem movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.w, // smaller
      margin: EdgeInsets.only(right: 11.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          Container(
            height: 145.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.r),
              image: DecorationImage(
                image: AssetImage(movie.posterUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 7.h),

          // Title
          Text(
            movie.title,
            style: AppTextStyles.montserratSemiBold.copyWith(
              color: AppColor.translucentWhite,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class MovieItem {
  final String title;
  final String posterUrl;

  MovieItem({required this.title, required this.posterUrl});
}
