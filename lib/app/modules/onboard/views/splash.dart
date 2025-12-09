import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Nuweli/app/res/fonts/fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:Nuweli/app/modules/onboard/controllers/onboard_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late VideoPlayerController _controller;
  final onboardController = Get.put(OnboardController());

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/splash.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(false);

        // 👇 When video finishes, call your route
        _controller.addListener(() {
          if (_controller.value.position >= _controller.value.duration) {
            onboardController.routeUser();
          }
        });

        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
                : const SizedBox(),
          ),

          // 👇 BOTTOM CENTER TEXT
          Positioned(
            bottom: 40,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "MAGIC",
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: Colors.orange,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "IVERSE",
                    style: AppTextStyles.montserratSemiBold.copyWith(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}
