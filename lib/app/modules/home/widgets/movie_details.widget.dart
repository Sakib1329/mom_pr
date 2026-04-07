import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
import 'package:toastification/toastification.dart';
import 'package:get_storage/get_storage.dart';
import '../services/home_service.dart';
import '../../../utils/error_helper.dart';

// Event Listener for specific mediaId
class _DownloadEventListener implements EventListener {
  final String targetMediaId;
  final Function(String mediaId, DownloadStatus? status) onStatusUpdate;

  _DownloadEventListener({
    required this.targetMediaId,
    required this.onStatusUpdate,
  });

  @override
  void onQueued(String mediaId, DownloadStatus downloadStatus) {
    if (mediaId == targetMediaId) onStatusUpdate(mediaId, downloadStatus);
  }

  @override
  void onChanged(String mediaId, DownloadStatus downloadStatus) {
    if (mediaId == targetMediaId) onStatusUpdate(mediaId, downloadStatus);
  }

  @override
  void onCompleted(String mediaId, DownloadStatus downloadStatus) {
    if (mediaId == targetMediaId) onStatusUpdate(mediaId, downloadStatus);
  }

  @override
  void onFailed(String mediaId, DownloadStatus downloadStatus) {
    if (mediaId == targetMediaId) onStatusUpdate(mediaId, downloadStatus);
  }

  @override
  void onDeleted(String mediaId) {
    if (mediaId == targetMediaId) onStatusUpdate(mediaId, null);
  }
}

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

  bool get _hasTrailer =>
      widget.movie.trailer != null && widget.movie.trailer!.trim().isNotEmpty;

  // Download states
  bool _isDownloading = false;
  bool _isDownloaded = false;

  final HomeService _homeService = Get.find<HomeService>();
  final _downloadManager = VdoDownloadManager.getInstance();
  late EventListener _downloadListener;

  @override
  void initState() {
    super.initState();
    _checkDownloadStatus(); // Initial check
    _setupDownloadListener();

    // Extra safety check after few seconds (sometimes status updates delayed)
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && !_isDownloaded && !_isDownloading) {
        _checkDownloadStatus();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh when returning to this screen (good for case when deleted from downloads)
    _checkDownloadStatus();
  }

  Future<void> _checkDownloadStatus() async {
    try {
      final List<DownloadStatus> statuses = await _downloadManager.query(
        mediaId: widget.movie.fileUuid,
      );

      if (!mounted) return;

      setState(() {
        if (statuses.isEmpty) {
          _isDownloaded = false;
          _isDownloading = false;
          return;
        }

        final status = statuses.first;
        final code = status.status;

        _isDownloading =
            code == VdoDownloadManager.STATUS_PENDING ||
            code == VdoDownloadManager.STATUS_DOWNLOADING;

        _isDownloaded = code == VdoDownloadManager.STATUS_COMPLETED ||
            code == 5; // 5 sometimes used as completed in some VdoCipher versions
      });
    } catch (e) {
      debugPrint("Error checking download status: $e");
    }
  }

  void _setupDownloadListener() {
    _downloadListener = _DownloadEventListener(
      targetMediaId: widget.movie.fileUuid,
      onStatusUpdate: (mediaId, status) {
        if (!mounted) return;

        setState(() {
          if (status == null) {
            // Deleted
            _isDownloading = false;
            _isDownloaded = false;
            return;
          }

          final code = status.status;

          _isDownloading =
              code == VdoDownloadManager.STATUS_PENDING ||
              code == VdoDownloadManager.STATUS_DOWNLOADING;

          _isDownloaded = code == VdoDownloadManager.STATUS_COMPLETED ||
              code == 5;

          if (_isDownloaded) {
            toastification.show(
              title: Text('download'.tr),
              description: Text('download_completed'.tr),
              style: ToastificationStyle.fillColored, type: ToastificationType.success,
              autoCloseDuration: const Duration(seconds: 3),
            );
          } else if (code == VdoDownloadManager.STATUS_FAILED) {
            toastification.show(
              title: Text('download_error'.tr),
              description: Text('download_failed'.tr),
              style: ToastificationStyle.fillColored, type: ToastificationType.error,
              autoCloseDuration: const Duration(seconds: 3),
            );
          }
        });
      },
    );

    _downloadManager.addDownloadEventListener(_downloadListener);
  }

  @override
  void dispose() {
    _downloadManager.removeDownloadEventListener(_downloadListener);
    _disposeTrailer();
    super.dispose();
  }

  // Trailer functions
  Future<void> _initTrailer() async {
    if (_trailerController != null || !_hasTrailer) return;
    print("Trailer URL: ${widget.movie.trailer}");
    setState(() => _isLoadingTrailer = true);

    try {
      _trailerController = VideoPlayerController.network(widget.movie.trailer!);
      await _trailerController!.initialize();

      if (!mounted) return;

      final size = _trailerController!.value.size;
      if (size.height > 0) _videoAspectRatio = size.width / size.height;

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
        print(e.toString());
        final msg = cleanErrorMessage(e);
        if (msg != 'offline') {
          toastification.show(title: Text('trailer_error'.tr), description: Text(msg), style: ToastificationStyle.fillColored, type: ToastificationType.error, autoCloseDuration: const Duration(seconds: 3));
        }
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
      _initTrailer().then((_) => _trailerController?.play());
    }
  }

  // Protected download start
  Future<void> _startDownload() async {
    // Strong protection against multiple clicks / already downloaded
    if (_isDownloaded) {
      toastification.show(
        title: const Text('Info'),
        description: const Text('This movie is already downloaded'),
        style: ToastificationStyle.fillColored, type: ToastificationType.info,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    if (_isDownloading) {
      toastification.show(
        title: const Text('Info'),
        description: const Text('Download is already in progress'),
        style: ToastificationStyle.fillColored, type: ToastificationType.info,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    setState(() => _isDownloading = true);

    try {
      final creds = await _homeService.getVideoPlaylist(
        widget.movie.fileUuid,
        offline: true,
      );

      final String otp = creds['otp']!;
      final String playbackInfo = creds['playbackInfo']!;

      final optionsDownloader = OptionsDownloader();

      optionsDownloader.downloadOptionsWithOtp(
        otp,
        playbackInfo,
        null,
            (downloadOptions) {
          if (downloadOptions.allVideo.isEmpty || downloadOptions.allAudio.isEmpty) {
            if (mounted) {
              setState(() => _isDownloading = false);
              toastification.show(
                title: Text('download_error'.tr),
                description: const Text('This video cannot be downloaded offline (missing video or audio track).'),
                style: ToastificationStyle.fillColored, type: ToastificationType.error,
                autoCloseDuration: const Duration(seconds: 3),
              );
            }
            return;
          }

          final videoIndex = downloadOptions.allVideo.length - 1;
          const audioIndex = 0;

          final selections = DownloadSelections(downloadOptions, videoIndex, audioIndex);
          final request = DownloadRequest(selections);

          VdoDownloadManager.getInstance().enqueue(request);
          
          // Save download date for 15-day expiry
          final storage = GetStorage();
          Map<String, dynamic> expiryDates = storage.read('download_expiry_dates') ?? {};
          expiryDates[widget.movie.fileUuid] = DateTime.now().toIso8601String();
          storage.write('download_expiry_dates', expiryDates);

          toastification.show(
            title: Text('download'.tr),
            description: Text('download_started'.tr),
            style: ToastificationStyle.fillColored, type: ToastificationType.info,
            autoCloseDuration: const Duration(seconds: 3),
          );
        },
            (vdoError) {
          if (mounted) {
            setState(() => _isDownloading = false);
            print(vdoError.message);
            toastification.show(
              title: Text('download_error'.tr),
              description: Text(vdoError.message ?? 'Unknown error'),
              style: ToastificationStyle.fillColored, type: ToastificationType.error,
              autoCloseDuration: const Duration(seconds: 3),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isDownloading = false);
        final msg = cleanErrorMessage(e);
        if (msg != 'offline') {
          toastification.show(
            title: Text('download_error'.tr),
            description: Text(msg),
            style: ToastificationStyle.fillColored, type: ToastificationType.error,
            autoCloseDuration: const Duration(seconds: 3),
          );
        }
      }
    }
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
          Icon(
            icon,
            color: color ?? AppColor.customDarkGray2,
            size: 24.sp,
          ),
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
      toastification.show(
        title: Text('coming_soon'.tr),
        description: Text('${'available_on'.tr}${widget.movie.formattedComingSoonDate}'),
        style: ToastificationStyle.fillColored, type: ToastificationType.warning,
        autoCloseDuration: const Duration(seconds: 4),
      );
      return;
    }

    if (widget.movie.fileUuid.isEmpty) {
      toastification.show(title: Text('not_available'.tr), description: Text('cannot_play_yet'.tr), style: ToastificationStyle.fillColored, type: ToastificationType.error, autoCloseDuration: const Duration(seconds: 3));
      return;
    }

    Get.to(() => VideoPlayerScreen(fileUuid: widget.movie.fileUuid));
  }

  Future<void> _showPaymentBottomSheet(
      BuildContext context,
      Movie movie,
      Settingcontroller controller,
      ) async {
    final paymentMethods = ['international'.tr, 'local_moncash'.tr];
    final selectedMethod = paymentMethods[0].obs;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => Padding(
        padding: EdgeInsets.all(20.w),
        child: Obx(
              () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('choose_payment_method'.tr,
                  style: AppTextStyles.montserratSemiBold.copyWith(
                      color: Colors.white, fontSize: 18.sp)),
              SizedBox(height: 20.h),
              ...paymentMethods.map((method) {
                final isSelected = selectedMethod.value == method;
                return GestureDetector(
                  onTap: () => selectedMethod.value = method,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6.h),
                    padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white12 : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 18.w,
                          height: 18.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                          child: isSelected
                              ? Center(
                            child: Container(
                              width: 10.w,
                              height: 10.w,
                              decoration: BoxDecoration(
                                  color: AppColor.vividAmber,
                                  shape: BoxShape.circle),
                            ),
                          )
                              : null,
                        ),
                        SizedBox(width: 12.w),
                        Text(method,
                            style: AppTextStyles.montserratSemiBold.copyWith(
                                color: Colors.white, fontSize: 14.sp)),
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
                gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.yellowAccent]),
                width: double.infinity,
                height: 35.h,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 15.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final settingController = Get.find<Settingcontroller>();

    return Container(
      color: AppColor.black,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),

            // Poster + Trailer Section
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.black87,
                  child: AspectRatio(
                    aspectRatio: _videoAspectRatio,
                    child: Stack(
                      children: [
                        if (widget.movie.postersUrl?.isNotEmpty ?? false)
                          Positioned.fill(
                            child: Image.network(
                              widget.movie.postersUrl!.first,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: Colors.grey[800]),
                            ),
                          )
                        else
                          Container(color: Colors.black),
                        if (_trailerInitialized && _showTrailer)
                          Positioned.fill(
                              child: VideoPlayer(_trailerController!)),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8)
                                ],
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
                                child: Icon(Icons.play_arrow,
                                    size: 36.sp, color: AppColor.black),
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
                if (widget.movie.isCollection == true)
                  Positioned(
                      top: 10.h,
                      right: 10.w,
                      child:
                      Icon(Icons.star, color: Colors.yellow, size: 30.sp)),
                if (widget.movie.isPremium && widget.movie.isCollection != true)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(ImageAssets.svg26,
                                  color: AppColor.vividAmber, height: 25.h),
                              SizedBox(width: 10.w),
                              Text('premium'.tr,
                                  style: AppTextStyles.montserratSemiBold
                                      .copyWith(
                                      color: Colors.white, fontSize: 22.sp)),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text('purchase_to_unlock'.tr,
                              style: AppTextStyles.montserratSemiBold.copyWith(
                                  color: Colors.yellowAccent, fontSize: 14.sp)),
                          SizedBox(height: 20.h),
                          CustomButton(
                            title: 'purchase'.tr,
                            onPress: () async =>
                            await _showPaymentBottomSheet(
                                context, widget.movie, settingController),
                            gradient: const LinearGradient(
                                colors: [Colors.orange, Colors.yellowAccent]),
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
                    widget.movie.title.isEmpty
                        ? 'untitled_movie'.tr
                        : widget.movie.title,
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: AppColor.translucentWhite,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    '${widget.movie.releaseYear?.toString() ?? 'unknown_year'.tr} • ${widget.movie.formattedDuration}',
                    style: AppTextStyles.montserratSemiBold.copyWith(
                        color: AppColor.customGray, fontSize: 14.sp),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    widget.movie.formattedGenres,
                    style: AppTextStyles.montserratSemiBold.copyWith(
                        color: AppColor.customGray, fontSize: 13.sp),
                  ),
                  SizedBox(height: 18.h),

                  // Action buttons row
                  Obx(
                        () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _actionItem(
                            icon: _isDownloading
                                ? Icons.downloading
                                : (_isDownloaded
                                ? Icons.download_done
                                : Icons.download),
                            label: _isDownloading
                                ? 'Downloading...'
                                : (_isDownloaded ? 'Downloaded' : 'download'.tr),
                            color: _isDownloaded
                                ? Colors.green[700]
                                : (_isDownloading
                                ? Colors.orange
                                : AppColor.customDarkGray2),
                            onTap: _startDownload,
                          ),
                          SizedBox(width: 20.w),
                          _actionItem(
                            icon: Icons.add,
                            label: 'my_list'.tr,
                            onTap: () => homeController.addToWatchLater(
                                widget.movie.id, widget.movie.aliasType),
                          ),
                          SizedBox(width: 20.w),
                          _actionItem(
                            icon: homeController.movieDetails.value?.liked ?? false
                                ? Icons.thumb_up_alt
                                : Icons.thumb_up_alt_outlined,
                            label:
                            '${'like'.tr} (${homeController.movieDetails.value?.likes ?? 0})',
                            color: homeController.movieDetails.value?.liked ?? false
                                ? AppColor.vividAmber
                                : AppColor.customDarkGray2,
                            onTap: () => homeController.likeMovie(
                                widget.movie.id, widget.movie.aliasType),
                          ),
                          SizedBox(width: 20.w),
                          _actionItem(
                            icon: homeController.movieDetails.value?.disliked ?? false
                                ? Icons.thumb_down_alt
                                : Icons.thumb_down_alt_outlined,
                            label:
                            '${'dislike'.tr} (${homeController.movieDetails.value?.dislikes ?? 0})',
                            color: homeController.movieDetails.value?.disliked ?? false
                                ? AppColor.vividAmber
                                : AppColor.customDarkGray2,
                            onTap: () => homeController.dislikeMovie(
                                widget.movie.id, widget.movie.aliasType),
                          ),
                          SizedBox(width: 20.w),
                          _actionItem(
                            icon: Icons.share,
                            label: 'share'.tr,
                            onTap: () => Share.share(
                              'Check out ${widget.movie.title.isEmpty ? 'this movie' : widget.movie.title}: '
                                  '${widget.movie.description.isEmpty ? 'No description' : widget.movie.description}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  if (!widget.movie.isPremium || widget.movie.isCollection == true)
                    CustomButton(
                      title: 'play'.tr,
                      onPress: () async => _handlePlay(context, settingController),
                      gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.yellowAccent]),
                      width: double.infinity,
                      height: 32.h,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),

                  if (!widget.movie.isPremium || widget.movie.isCollection == true)
                    SizedBox(height: 10.h),

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
                    widget.movie.description.isEmpty
                        ? 'no_description'.tr
                        : widget.movie.description,
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
}