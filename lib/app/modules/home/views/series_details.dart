

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Nuweli/app/modules/home/widgets/series_details.dart';
import '../../../res/colors/color.dart';
import '../../home/controllers/home_controller.dart';



class SeriesDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Obx(() {
      if (homeController.isSeriesDetailsLoading.value) {
        return Scaffold(
          backgroundColor: AppColor.black,
          body: const Center(child: CircularProgressIndicator()),
        );
      }
      if (homeController.SeriesdetailsErrorMessage.isNotEmpty) {
        return Scaffold(
          backgroundColor: AppColor.black,
          body: Center(
            child: Text(
              homeController.SeriesdetailsErrorMessage.value,
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
        );
      }
      if (homeController.SeriesDetails.value == null) {
        return Scaffold(
          backgroundColor: AppColor.black,
          body: Center(
            child: Text(
              'No movie details available',
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
        );
      }

      final series = homeController.SeriesDetails.value!;

      return Scaffold(
        backgroundColor: AppColor.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Get.back();
            },
          ),
          centerTitle: true,
          title: SvgPicture.asset('assets/icons/svg1.svg', height: 20.h),
        ),
        body: SeriesDetailsWidget(series:series,),
      );
    });
  }
}