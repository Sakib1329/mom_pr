import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../../../widgets/custom_button.dart';
import '../models/movie_model.dart';
import '../views/videoscreen.dart';
import '../../settings/controllers/settingcontroller.dart';
import '../controllers/home_controller.dart';

class MovieDetailsWidget extends StatefulWidget {
  final Movie movie;

  const MovieDetailsWidget({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {

  VideoPlayerController? _trailerController;
  bool _showTrailer = false;
  bool _trailerInitialized = false;
  bool _isLoadingTrailer = false;

  // ---- NEW: dynamic aspect ratio (fallback 16:9) ----
  double _videoAspectRatio = 16 / 9;

  bool get _hasTrailer =>
      widget.movie.trailer != null && widget.movie.trailer!.trim().isNotEmpty;

  Future<void> _initTrailer() async {
    if (_trailerController != null || !_hasTrailer) return;

    setState(() => _isLoadingTrailer = true);

    try {
      _trailerController = VideoPlayerController.network(widget.movie.trailer!);
      await _trailerController!.initialize();

      if (!mounted) return;

      // ---- Capture real video aspect ratio ----
      final size = _trailerController!.value.size;
      _videoAspectRatio = size.width / size.height;

      setState(() {
        _trailerInitialized = true;
        _isLoadingTrailer = false;
      });

      _trailerController!
        ..setVolume(1.0)
        ..setLooping(true);
    } catch (e) {

      if (mounted) {
        setState(() {
          _isLoadingTrailer = false;
          _trailerInitialized = false;
        });
        Get.snackbar(
          'Trailer Error',
          'Failed to load trailer. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void _disposeTrailer() {
    _trailerController?.pause();
    _trailerController?.dispose();
    _trailerController = null;
    _trailerInitialized = false;
    _isLoadingTrailer = false;
  }

  void _toggleTrailer() {
    if (_showTrailer) {
      setState(() => _showTrailer = false);
      _disposeTrailer();
    } else {
      setState(() => _showTrailer = true);
      _initTrailer().then((_) {
        // Play only after user taps
        _trailerController?.play();
      });
    }
  }

  @override
  void dispose() {
    _disposeTrailer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final Settingcontroller settingController = Get.find();

    return Container(
      color: AppColor.black,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),

            // ==================== TRAILER AREA (DYNAMIC ASPECT RATIO) ====================
            Container(
              width: double.infinity,
              color: Colors.black87,
              child: AspectRatio(
                aspectRatio: _videoAspectRatio, // <-- Uses real video ratio
                child: Stack(
                  children: [
                    // Background poster image
                    if (widget.movie.postersUrl != null &&
                        widget.movie.postersUrl!.isNotEmpty)
                      Positioned.fill(
                        child: Image.network(
                          widget.movie.postersUrl!.first,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(color: Colors.black),

                    // Video overlay (only if initialized)
                    if (_trailerInitialized)
                      Positioned.fill(
                        child: VideoPlayer(_trailerController!),
                      ),

                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
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
                    ),

                    // Play button
                    if (_hasTrailer && !_showTrailer)
                      Positioned.fill(
                        child: Center(
                          child: FloatingActionButton(
                            heroTag: 'trailerBtn_${widget.movie.id}',
                            backgroundColor: Colors.white.withOpacity(0.95),
                            onPressed: _toggleTrailer,
                            child: Icon(
                              Icons.play_arrow,
                              size: 36.sp,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                      ),

                    // Close button when playing
                    if (_showTrailer)
                      Positioned(
                        top: 10.h,
                        right: 10.w,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: _toggleTrailer,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ====================== INFO SECTION ======================
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.movie.title.isEmpty ? 'Untitled' : widget.movie.title,
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.translucentWhite,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 7.h),

                  // Year + Duration
                  Text(
                    '${widget.movie.releaseYear?.toString() ?? 'Unknown Year'} • ${widget.movie.formattedDuration}',
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.customGray,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Genre
                  Text(
                    widget.movie.formattedGenres,
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.customGray,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 18.h),

                  // Action Buttons
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _actionItem(
                        icon: Icons.add,
                        label: 'My List',
                        onTap: () => homeController.addToWatchLater(
                            widget.movie.id, widget.movie.aliasType),
                      ),
                      SizedBox(width: 25.w),
                      _actionItem(
                        icon: homeController.movieDetails.value?.liked ??
                            false
                            ? Icons.thumb_up_alt
                            : Icons.thumb_up_alt_outlined,
                        label:
                        'Like (${homeController.movieDetails.value?.likes ?? 0})',
                        color: homeController.movieDetails.value?.liked ??
                            false
                            ? AppColor.vividAmber
                            : AppColor.customDarkGray2,
                        onTap: () => homeController.likeMovie(
                            widget.movie.id, widget.movie.aliasType),
                      ),
                      SizedBox(width: 25.w),
                      _actionItem(
                        icon: homeController.movieDetails.value?.disliked ??
                            false
                            ? Icons.thumb_down_alt
                            : Icons.thumb_down_alt_outlined,
                        label:
                        'Dislike (${homeController.movieDetails.value?.dislikes ?? 0})',
                        color: homeController.movieDetails.value?.disliked ??
                            false
                            ? AppColor.vividAmber
                            : AppColor.customDarkGray2,
                        onTap: () => homeController.dislikeMovie(
                            widget.movie.id, widget.movie.aliasType),
                      ),
                      SizedBox(width: 25.w),
                      _actionItem(
                        icon: Icons.share,
                        label: 'Share',
                        onTap: () => Share.share(
                          'Check out ${widget.movie.title.isEmpty ? 'this movie' : widget.movie.title}: ${widget.movie.description.isEmpty ? 'No description' : widget.movie.description}',
                        ),
                      ),
                    ],
                  )),
                  SizedBox(height: 20.h),

                  // Play Button
                  CustomButton(
                    title: 'Play',
                    onPress: () async {
                      if (widget.movie.isPremium && widget.movie.isCollection != true) {
                        _showPremiumPurchaseSheet(
                            context, widget.movie, settingController);
                        return;
                      }

                      if (widget.movie.isComingSoon) {
                        Get.snackbar(
                          'Coming Soon',
                          'Available on ${widget.movie.formattedComingSoonDate}',
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 4),
                        );
                        return;
                      }

                      if (widget.movie.fileUuid.isEmpty) {
                        Get.snackbar(
                          'Not Available',
                          'This movie cannot be played yet.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      Get.to(() => VideoPlayerScreen(fileUuid: widget.movie.fileUuid));
                    },
                    gradient: const LinearGradient(
                        colors: [Colors.orange, Colors.yellowAccent]),
                    width: double.infinity,
                    height: 35.h,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 10.h),

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
                    widget.movie.description.isEmpty
                        ? 'No description available'
                        : widget.movie.description,
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.customGray,
                      fontSize: 13.sp,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ Helpers ------------------
  Widget _actionItem({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color ?? AppColor.customDarkGray2, size: 24.sp),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTextStyles.montserratSemiBold.copyWith(
              color: color ?? AppColor.customDarkGray2,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  void _showPremiumPurchaseSheet(
      BuildContext context, Movie movie, Settingcontroller controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Purchase to unlock and watch this movie',
              textAlign: TextAlign.center,
              style: AppTextStyles.montserratSemiBold.copyWith(
                color: Colors.yellowAccent,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(height: 25.h),
            CustomButton(
              title: 'Purchase',
              onPress: () async {
                Get.back();
                await controller.initiatePayment(
                  id: movie.id,
                  aliasType: movie.aliasType,
                  isMonCash: false,
                );
              },
              gradient: const LinearGradient(
                  colors: [Colors.orange, Colors.yellowAccent]),
              width: double.infinity,
              height: 40.h,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}