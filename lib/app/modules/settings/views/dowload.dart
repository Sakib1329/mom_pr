import 'dart:io';

import 'package:Nuweli/app/modules/settings/controllers/settingcontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/Get.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';
import 'package:get_storage/get_storage.dart';
import '../../../res/colors/color.dart';
import 'package:toastification/toastification.dart';
import 'offlineplayer.dart';

class DownloadsScreen extends StatefulWidget {
  final Settingcontroller settingcontroller=Get.find();
   DownloadsScreen({Key? key}) : super(key: key);

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen>
    implements EventListener {
  List<DownloadStatus> downloadedVideos = [];
  bool _isLoading = true;
  final VdoDownloadManager _downloadManager = VdoDownloadManager.getInstance();

  @override
  void initState() {
    super.initState();
    _initializePage();
    _downloadManager.addDownloadEventListener(this);
  }
  Future<void> _initializePage() async {
    await widget.settingcontroller.fetchProfileData();
    _loadDownloads();
  }
  @override
  void dispose() {
    _downloadManager.removeDownloadEventListener(this);
    super.dispose();
  }
  String formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  void onChanged(String mediaId, DownloadStatus status) => _refresh();

  @override
  void onCompleted(String mediaId, DownloadStatus status) {
    debugPrint('onCompleted triggered for mediaId: $mediaId');
    _refresh();

    // Extra force refresh after delay
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        debugPrint('Force refresh after completion');
        _loadDownloads();
      }
    });
  }

  @override
  void onDeleted(String mediaId) => _refresh();

  @override
  void onError(String mediaId, VdoError error) {
    debugPrint('Download error: $error');
    _refresh();
  }

  @override
  void onFailed(String mediaId, DownloadStatus status) => _refresh();

  @override
  void onQueued(String mediaId, DownloadStatus status) => _refresh();

  void _refresh() {
    if (mounted) {
      _loadDownloads();
    }
  }

  Future<void> _loadDownloads() async {
    try {
      final List<DownloadStatus> all = await _downloadManager.query(Query());
      final storage = GetStorage();
      Map<String, dynamic> expiryDates = storage.read('download_expiry_dates') ?? {};
      bool statusChanged = false;

      // Debug: See all downloads
      for (var status in all) {
        final mediaId = status.mediaInfo.mediaId;
        final title = status.mediaInfo.title ?? 'No title';
        
        // Auto-delete if > 15 days
        if (expiryDates.containsKey(mediaId)) {
          final downloadDate = DateTime.parse(expiryDates[mediaId]);
          final difference = DateTime.now().difference(downloadDate).inDays;
          
          if (difference >= 15) {
            debugPrint('Auto-deleting expired download: $title ($mediaId) - $difference days old');
            _downloadManager.remove(mediaId);
            expiryDates.remove(mediaId);
            statusChanged = true;
            continue;
          }
        } else if (status.status == VdoDownloadManager.STATUS_COMPLETED || status.status == 5) {
          // If for some reason date is missing but completed, set it now to avoid infinite retention
          expiryDates[mediaId] = DateTime.now().toIso8601String();
          statusChanged = true;
        }

        debugPrint(
            'Download: $title | '
                'mediaId: $mediaId | '
                'status: ${status.status}');
      }

      if (statusChanged) {
        storage.write('download_expiry_dates', expiryDates);
        // Re-query if we deleted anything
        return _loadDownloads();
      }

      final completed = all.where((status) {
        return status.status == VdoDownloadManager.STATUS_COMPLETED || status.status == 5;
      }).toList();

      if (mounted) {
        setState(() {
          downloadedVideos = completed;
          _isLoading = false;
        });
      }

      debugPrint('Found ${completed.length} completed offline videos');
    } catch (e, stack) {
      debugPrint('Error loading downloads: $e\n$stack');
    }
  }

  void _deleteDownload(String mediaId) {
    _downloadManager.remove(mediaId);
    toastification.show(
      title: Text('deleted'.tr),
      description: Text('video_removed_from_downloads'.tr),
      style: ToastificationStyle.fillColored, type: ToastificationType.error,
      autoCloseDuration: const Duration(seconds: 3),
    );
    _loadDownloads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'downloads'.tr,
          style: TextStyle(color: Colors.white, fontSize: 22.sp),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadDownloads,
        color: AppColor.vividAmber,
        backgroundColor: AppColor.greyDark,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColor.vividAmber),
              )
            : downloadedVideos.isEmpty
            ? Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.file_download_off,
                    size: 100.sp,
                    color: AppColor.customGray,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'no_downloads_yet'.tr,
                    style: TextStyle(color: Colors.white, fontSize: 20.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'tap_download_on_movie_details'.tr,
                    style: TextStyle(
                        color: AppColor.customGray, fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        )
            : ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          itemCount: downloadedVideos.length,
          itemBuilder: (context, index) {
            final status = downloadedVideos[index];
            final title = status.mediaInfo.title ?? 'untitled'.tr;
            final mediaId = status.mediaInfo.mediaId ?? '';
            final poster = status.poster;
            final duration = status.mediaInfo.duration;
            final durationText = formatDuration(duration);

            return GestureDetector(
              onTap: () {
                if (mediaId.isEmpty) return;
                Get.to(() => OfflinePlayerScreen(
                  mediaId: mediaId,
                  title: title,
                ));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 120.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        image: DecorationImage(
                          image: FileImage(File(poster!)),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: AppColor.vividAmber,
                          size: 40.sp,
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // 📄 Title + duration text (UNCHANGED)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 14.sp,
                                color: AppColor.customGray,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                durationText,
                                style: TextStyle(
                                  color: AppColor.customGray,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // 🗑 Delete button
                    IconButton(
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => _deleteDownload(mediaId),
                    ),
                  ],
                ),
              ),
            );
          },
        )


      ),
    );
  }
}