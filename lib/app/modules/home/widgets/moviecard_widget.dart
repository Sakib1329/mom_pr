import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';
import 'package:Nuweli/app/res/colors/color.dart';
import 'package:Nuweli/app/res/fonts/fonts.dart';
import '../services/home_service.dart';

class MovieCardWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final List<String> genres;
  final String seasonInfo;
  final String fileUuid;
  final bool isNotify;                    // ← NEW: Required
  final VoidCallback? onRemindMeTap;
  final VoidCallback? onShareTap;

  const MovieCardWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.genres,
    required this.seasonInfo,
    required this.fileUuid,
    required this.isNotify,               // ← Now required
    this.onRemindMeTap,
    this.onShareTap,
  }) : super(key: key);

  @override
  State<MovieCardWidget> createState() => _MovieCardWidgetState();
}

class _MovieCardWidgetState extends State<MovieCardWidget> {
  bool _isPlaying = false;
  bool _isLoading = false;
  String? _error;
  EmbedInfo? _embedInfo;

  final HomeService _homeService = Get.find<HomeService>();

  Future<void> _loadVideo() async {
    if (_isPlaying) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final creds = await _homeService.getVideoPlaylist(widget.fileUuid);
      setState(() {
        _embedInfo = EmbedInfo.streaming(
          otp: creds['otp']!,
          playbackInfo: creds['playbackInfo']!,
          embedInfoOptions: EmbedInfoOptions(autoplay: true),
        );
        _isLoading = false;
        _isPlaying = true;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 9.h,horizontal: 5.w),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              widget.title,
              style: AppTextStyles.montserratSemiBold.copyWith(
                color: Colors.white,
                fontSize: 18.sp,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12.h),

            // Subtitle / Description
            Text(
              widget.subtitle,
              style: AppTextStyles.montserratRegular.copyWith(
                color: Colors.grey[400],
                fontSize: 12.sp,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 15.h),

            // Genres
            SizedBox(
              height: 25.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.genres.length,
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  return Text(
                    "${widget.genres[index]} •",
                    style: AppTextStyles.montserratBold.copyWith(
                      color: AppColor.white,
                      fontSize: 14.sp,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15.h),

            // Video Player / Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Loading
                  if (_isLoading)
                    Container(
                      width: double.infinity,
                      height: 200.h,
                      color: Colors.black,
                      child: Center(
                        child: CircularProgressIndicator(color: AppColor.vividAmber),
                      ),
                    )
                  // Error
                  else if (_error != null)
                    Container(
                      width: double.infinity,
                      height: 200.h,
                      color: Colors.grey[900],
                      child: Center(
                        child: Text(
                          "Failed to load video",
                          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                        ),
                      ),
                    )
                  // Player
                  else if (_isPlaying && _embedInfo != null)
                      SizedBox(
                        width: double.infinity,
                        height: 200.h,
                        child: VdoPlayer(
                          embedInfo: _embedInfo!,
                          onPlayerCreated: (controller) {
                            controller.addListener(() {
                              if (controller.value.isEnded) {
                                setState(() => _isPlaying = false);
                              }
                            });
                          },
                          onError: (error) {
                            setState(() => _error = error.message);
                          },
                        ),
                      )
                    // Poster Image
                    else
                      Image.network(
                        widget.imageUrl,
                        width: double.infinity,
                        height: 200.h,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[800],
                          child: Icon(Icons.broken_image, color: Colors.white54, size: 50.sp),
                        ),
                      ),

                  // Play Overlay
                  if (!_isPlaying && !_isLoading)
                    GestureDetector(
                      onTap: _loadVideo,
                      child: Container(
                        width: double.infinity,
                        height: 200.h,
                        color: Colors.black38,
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 70.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 15.h),

            // Bottom Row: Season Info + Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Season / Release Info
                Expanded(
                  child: Text(
                    widget.seasonInfo,
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.translucentWhite,
                      fontSize: 14.sp,
                    ),
                  ),
                ),

                // Remind Me Button (Bell)
                GestureDetector(
                  onTap: widget.onRemindMeTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 4.h),
                decoration: BoxDecoration(
                    color:  widget.isNotify
                        ? AppColor.vividAmber
                        : Colors.white,
                  borderRadius: BorderRadius.circular(10.r)
                ),
                    child: Row(
                      children: [
                        Icon(
                          widget.isNotify
                              ? Icons.notifications_active
                              : Icons.notifications_none,
                          color: widget.isNotify
                              ? AppColor.black
                              : Colors.black,
                          size: 25.sp,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          'Remind Me',
                          style: AppTextStyles.montserratBold.copyWith(
                            color: widget.isNotify ? AppColor.black : AppColor.black,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.w,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}