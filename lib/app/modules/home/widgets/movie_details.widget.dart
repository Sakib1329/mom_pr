import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/Get.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';
import '../../../res/assets/imageassets.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../../../widgets/custom_button.dart';
import '../models/movie_model.dart';
import '../views/videoscreen.dart';
import '../../settings/controllers/settingcontroller.dart';
import '../controllers/home_controller.dart';
import '../services/home_service.dart';

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

  double _videoAspectRatio = 16 / 9;

  bool get _hasTrailer => widget.movie.trailer != null && widget.movie.trailer!.trim().isNotEmpty;

  // Download related
  final HomeService _homeService = Get.find<HomeService>();
  bool _isDownloading = false;

  Future<void> _initTrailer() async {
    if (_trailerController != null || !_hasTrailer) return;

    setState(() => _isLoadingTrailer = true);

    try {
      _trailerController = VideoPlayerController.network(widget.movie.trailer!);
      await _trailerController!.initialize();

      if (!mounted) return;

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
          'trailer_error'.tr,
          'trailer_error'.tr,
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
        _trailerController?.play();
      });
    }
  }

  Future<void> _startDownload() async {
    if (_isDownloading) return;

    setState(() => _isDownloading = true);
print("File Uuid : ${widget.movie.fileUuid}");
    try {
      final creds = await _homeService.getVideoPlaylist(widget.movie.fileUuid, offline: true);
      final String otp = creds['otp']!;
      final String playbackInfo = creds['playbackInfo']!;
      print("OTP : $otp");
      print("PlaybackInfo : $playbackInfo");
      debugPrint('OTP received for offline download: $otp');

      OptionsDownloader optionsDownloader = OptionsDownloader();

      optionsDownloader.downloadOptionsWithOtp(
        otp,
        playbackInfo,
        null,
            (downloadOptions) {
          try {
            if (downloadOptions.allVideo.isEmpty) {
              Get.snackbar(
                'download_error'.tr,
                'No video tracks available.',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }

            if (downloadOptions.allAudio.isEmpty) {
              Get.snackbar(
                'download_error'.tr,
                'This video cannot be downloaded offline (no audio track available). Contact support or re-encode the video with separate audio.',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 8),
              );
              return;
            }

            // Highest quality video
            int videoIndex = downloadOptions.allVideo.length - 1;

            // First (and usually only) audio track
            int audioIndex = 0;

            debugPrint('Video tracks: ${downloadOptions.allVideo.length}');
            debugPrint('Audio tracks: ${downloadOptions.allAudio.length}');
            debugPrint('Selected video: $videoIndex, audio: $audioIndex');

            DownloadSelections downloadSelections = DownloadSelections(
              downloadOptions,
              videoIndex,
              audioIndex,
            );

            DownloadRequest downloadRequest = DownloadRequest(downloadSelections);

            VdoDownloadManager.getInstance().enqueue(downloadRequest);

            Get.snackbar(
              'download'.tr,
              'download_started'.tr,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } catch (e, stack) {
            debugPrint('Selection error: $e\n$stack');
            Get.snackbar('download_error'.tr, 'Error: $e',
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
            (vdoError) {
          Get.snackbar('download_error'.tr, vdoError.message,
              backgroundColor: Colors.red, colorText: Colors.white);
        },
      );
    } catch (e) {
      Get.snackbar('download_error'.tr, 'Failed to get credentials',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      if (mounted) setState(() => _isDownloading = false);
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

            // Header Image + Trailer + Premium Overlay
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.black87,
                  child: AspectRatio(
                    aspectRatio: _videoAspectRatio,
                    child: Stack(
                      children: [
                        if (widget.movie.postersUrl != null && widget.movie.postersUrl!.isNotEmpty)
                          Positioned.fill(
                            child: Image.network(
                              widget.movie.postersUrl!.first,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(color: Colors.grey[800]),
                            ),
                          )
                        else
                          Container(color: Colors.black),

                        if (_trailerInitialized)
                          Positioned.fill(child: VideoPlayer(_trailerController!)),

                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                              ),
                            ),
                          ),
                        ),

                        if (_hasTrailer && !_showTrailer)
                          Positioned.fill(
                            child: Center(
                              child: FloatingActionButton(
                                heroTag: 'trailerBtn_${widget.movie.id}',
                                backgroundColor: Colors.white.withOpacity(0.95),
                                onPressed: _toggleTrailer,
                                child: Icon(Icons.play_arrow, size: 36.sp, color: AppColor.black),
                              ),
                            ),
                          ),

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

                // Collection star
                if (widget.movie.isCollection == true)
                  Positioned(top: 10.h, right: 10.w, child: Icon(Icons.star, color: Colors.yellow, size: 30.sp)),

                if (widget.movie.isPremium && widget.movie.isCollection != true)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(ImageAssets.svg26, color: AppColor.vividAmber, height: 25.h),
                              SizedBox(width: 10.w),
                              Text('premium'.tr,
                                  style: AppTextStyles.montserratSemiBold.copyWith(color: Colors.white, fontSize: 22.sp)),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text('purchase_to_unlock'.tr,
                              style: AppTextStyles.montserratSemiBold.copyWith(color: Colors.yellowAccent, fontSize: 14.sp)),
                          SizedBox(height: 20.h),
                          CustomButton(
                            title: 'purchase'.tr,
                            onPress: () async => _showPaymentBottomSheet(context, widget.movie, settingController),
                            gradient: LinearGradient(colors: [Colors.orange, Colors.yellowAccent]),
                            width: 200.w,
                            height: 35.h,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),

              ],
            ),

            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title.isEmpty ? 'untitled_movie'.tr : widget.movie.title,
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.translucentWhite,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    '${widget.movie.releaseYear?.toString() ?? 'unknown_year'.tr} • ${widget.movie.formattedDuration}',
                    style: AppTextStyles.montserratSemiBold.copyWith(color: AppColor.customGray, fontSize: 14.sp),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    widget.movie.formattedGenres,
                    style: AppTextStyles.montserratSemiBold.copyWith(color: AppColor.customGray, fontSize: 13.sp),
                  ),
                  SizedBox(height: 18.h),

                  // Action Buttons
                  Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _actionItem(
                          icon: _isDownloading ? Icons.downloading : Icons.download,
                          label: 'download'.tr,
                          onTap: _startDownload,
                        ),
                        SizedBox(width: 20.w),
                        _actionItem(
                          icon: Icons.add,
                          label: 'my_list'.tr,
                          onTap: () => homeController.addToWatchLater(widget.movie.id, widget.movie.aliasType),
                        ),
                        SizedBox(width: 20.w),
                        _actionItem(
                          icon: homeController.movieDetails.value?.liked ?? false
                              ? Icons.thumb_up_alt
                              : Icons.thumb_up_alt_outlined,
                          label: '${'like'.tr} (${homeController.movieDetails.value?.likes ?? 0})',
                          color: homeController.movieDetails.value?.liked ?? false ? AppColor.vividAmber : AppColor.customDarkGray2,
                          onTap: () => homeController.likeMovie(widget.movie.id, widget.movie.aliasType),
                        ),
                        SizedBox(width: 20.w),
                        _actionItem(
                          icon: homeController.movieDetails.value?.disliked ?? false
                              ? Icons.thumb_down_alt
                              : Icons.thumb_down_alt_outlined,
                          label: '${'dislike'.tr} (${homeController.movieDetails.value?.dislikes ?? 0})',
                          color: homeController.movieDetails.value?.disliked ?? false ? AppColor.vividAmber : AppColor.customDarkGray2,
                          onTap: () => homeController.dislikeMovie(widget.movie.id, widget.movie.aliasType),
                        ),
                        SizedBox(width: 20.w),
                        _actionItem(
                          icon: Icons.share,
                          label: 'share'.tr,
                          onTap: () => Share.share(
                            'Check out ${widget.movie.title.isEmpty ? 'this movie' : widget.movie.title}: ${widget.movie.description.isEmpty ? 'No description' : widget.movie.description}',
                          ),
                        ),
                      ],
                    ),
                  )),
                  SizedBox(height: 20.h),

                  // Big Play Button (only when unlocked)
                  if (!widget.movie.isPremium || widget.movie.isCollection == true)
                    CustomButton(
                      title: 'play'.tr,
                      onPress: () async => _handlePlay(context, settingController),
                      gradient: const LinearGradient(colors: [Colors.orange, Colors.yellowAccent]),
                      width: double.infinity,
                      height: 35.h,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),

                  if (!widget.movie.isPremium || widget.movie.isCollection == true) SizedBox(height: 10.h),

                  Text(
                    'description_title'.tr,
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.translucentWhite,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    widget.movie.description.isEmpty ? 'no_description'.tr : widget.movie.description,
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.customGray,
                      fontSize: 13.sp,
                      height: 1.4,
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

  void _handlePlay(BuildContext context, Settingcontroller settingController) {
    if (widget.movie.isComingSoon) {
      Get.snackbar(
        'coming_soon'.tr,
        '${'available_on'.tr}${widget.movie.formattedComingSoonDate}',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    if (widget.movie.fileUuid.isEmpty) {
      Get.snackbar(
        'not_available'.tr,
        'cannot_play_yet'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.to(() => VideoPlayerScreen(fileUuid: widget.movie.fileUuid));
  }

  void _showPaymentBottomSheet(BuildContext context, Movie movie, Settingcontroller controller) {
    final paymentMethods = ['international'.tr, 'local_moncash'.tr];
    final RxString selectedMethod = paymentMethods[0].obs;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => Padding(
        padding: EdgeInsets.all(20.w),
        child: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('choose_payment_method'.tr,
                style: AppTextStyles.montserratSemiBold.copyWith(color: Colors.white, fontSize: 18.sp)),
            SizedBox(height: 20.h),
            ...paymentMethods.map((method) {
              bool isSelected = selectedMethod.value == method;
              return GestureDetector(
                onTap: () => selectedMethod.value = method,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white12 : Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 18.w,
                        height: 18.w,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white)),
                        child: isSelected
                            ? Center(
                            child: Container(
                                width: 10.w,
                                height: 10.w,
                                decoration: BoxDecoration(color: AppColor.vividAmber, shape: BoxShape.circle)))
                            : null,
                      ),
                      SizedBox(width: 12.w),
                      Text(method,
                          style: AppTextStyles.montserratSemiBold.copyWith(color: Colors.white, fontSize: 14.sp)),
                    ],
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 20.h),
            CustomButton(
              title: 'continue'.tr,
              onPress: () async {
                Get.back();
                await controller.initiatePayment(
                  id: movie.id,
                  aliasType: movie.aliasType,
                  isMonCash: selectedMethod.value == 'local_moncash'.tr,
                );
              },
              gradient: LinearGradient(colors: [Colors.orange, Colors.yellowAccent]),
              width: double.infinity,
              height: 35.h,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 15.h),
          ],
        )),
      ),
    );
  }
}