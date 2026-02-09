import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';
import '../services/home_service.dart';
import '../../../res/colors/color.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String fileUuid;

  const VideoPlayerScreen({Key? key, required this.fileUuid}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final HomeService _homeService = Get.find<HomeService>();

  VdoPlayerController? _controller;
  EmbedInfo? _embedInfo;
  bool _isLoading = true;
  String? _error;

  // To prevent API spam, we track the last saved time
  DateTime? _lastSyncTime;

  @override
  void initState() {
    super.initState();
    _loadVideoCredentials();
  }

  @override
  void dispose() {
    // Final sync when the screen is closed
    _saveProgressToBackend();
    super.dispose();
  }

  Future<void> _loadVideoCredentials() async {
    try {
      final creds = await _homeService.getVideoPlaylist(widget.fileUuid);

      final Map<String, dynamic>? progress =
      creds['progress'] as Map<String, dynamic>?;
print(progress);
      final int savedSeconds =
          (progress?['last_position_seconds'] as num?)?.toInt() ?? 0;

      final Duration resumeDuration = Duration(seconds: savedSeconds);
print(resumeDuration);
print(savedSeconds);
      setState(() {
        _embedInfo = EmbedInfo.streaming(
          otp: creds['otp']!,
          playbackInfo: creds['playbackInfo']!,
          embedInfoOptions: EmbedInfoOptions(
            autoplay: true,
            resumePosition: resumeDuration, // ✅ resume here
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }


  /// Sends progress to the backend
  void _saveProgressToBackend() {
    if (_controller != null) {
      final int currentPosition = _controller!.value.position.inSeconds;
      final int totalDuration = _controller!.value.duration.inSeconds;

      // Logic: Don't save if the video hasn't started or is basically at the end
      if (currentPosition > 5 && totalDuration > 0) {
        _homeService.saveProgress(
          fileUuid: widget.fileUuid,
          lastPosition: currentPosition,
          totalDuration: totalDuration,
        );
        _lastSyncTime = DateTime.now();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Get.back(),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColor.vividAmber))
          : _error != null
          ? Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
        ),
      )
          : _embedInfo != null
          ? VdoPlayer(
        embedInfo: _embedInfo!,
        onPlayerCreated: (controller) {
          _controller = controller;

          controller.addListener(() {
            // Periodic Sync: Save progress every 15 seconds automatically
            if (_lastSyncTime == null ||
                DateTime.now().difference(_lastSyncTime!).inSeconds >= 15) {
              _saveProgressToBackend();
            }
          });
        },
        onError: (error) {
          setState(() => _error = error.message);
        },
        onFullscreenChange: (isFullscreen) {
          // Logic for orientation if needed
        },
      )
          : Center(
        child: Text('failed_to_load_video'.tr, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
      ),
    );
  }
}