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
  EmbedInfo? _embedInfo;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVideoCredentials();
  }

  Future<void> _loadVideoCredentials() async {
    try {
      final creds = await _homeService.getVideoPlaylist(widget.fileUuid);
      setState(() {
        _embedInfo = EmbedInfo.streaming(
          otp: creds['otp']!,
          playbackInfo: creds['playbackInfo']!,
          embedInfoOptions: EmbedInfoOptions(
            autoplay: true,
            // customPlayerId: "YOUR_CUSTOM_PLAYER_ID", // Optional, add if provided by VdoCipher
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Get.back(),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColor.vividAmber,))
          : _error != null
          ? Center(
        child: Text(
          _error!,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      )
          : _embedInfo != null
          ? VdoPlayer(
        embedInfo: _embedInfo!,
        onPlayerCreated: (controller) {
          controller.addListener(() {
            setState(() {
              // Log playback state for debugging
              print('Player event: isPlaying=${controller.value.isPlaying}, '
                  'isBuffering=${controller.value.isBuffering}, '
                  'isEnded=${controller.value.isEnded}');
            });
          });
        },
        onError: (error) {
          print('Playback error: ${error.message}');
          setState(() {
            _error = error.message;
          });
        },
        onFullscreenChange: (isFullscreen) => print('Fullscreen: $isFullscreen'),
      )
          : Center(
        child: Text(
          'Failed to load video',
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      ),
    );
  }
}