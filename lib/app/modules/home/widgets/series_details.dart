import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/Get.dart';
import 'package:Nuweli/app/modules/home/controllers/home_controller.dart';
import 'package:Nuweli/app/res/assets/imageassets.dart';
import 'package:share_plus/share_plus.dart';
import '../../../res/colors/color.dart';
import '../../../res/fonts/fonts.dart';
import '../../../widgets/custom_button.dart';
import '../models/series_model.dart';
import '../../settings/controllers/settingcontroller.dart';
import 'package:toastification/toastification.dart';
import '../views/videoscreen.dart';

class SeriesDetailsWidget extends StatelessWidget {
  final Series series;

  const SeriesDetailsWidget({super.key, required this.series});

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
            Stack(
              children: [
                SizedBox(
                  height: 300.h,
                  width: double.infinity,
                  child: series.postersUrl.isNotEmpty
                      ? Image.network(
                    series.postersUrl.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[800],
                      child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: 50.sp),
                    ),
                  )
                      : Container(
                    color: Colors.grey[800],
                    child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: 50.sp),
                  ),
                ),
                Container(
                  height: 300.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                    ),
                  ),
                ),
                if (series.isCollection == true)
                  Positioned(top: 10.h, right: 10.w, child: Icon(Icons.star, color: Colors.yellow, size: 30.sp)),
                if (series.isPremium && series.isCollection != true)
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
                              Text('premium'.tr, style: AppTextStyles.montserratSemiBold.copyWith(color: Colors.white, fontSize: 22.sp)),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text('purchase_to_unlock'.tr, style: AppTextStyles.montserratSemiBold.copyWith(color: Colors.yellowAccent, fontSize: 14.sp)),
                          SizedBox(height: 20.h),
                          CustomButton(
                            title: 'purchase'.tr,
                            onPress: () async => _showPaymentBottomSheet(context, series, settingController),
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
                if (!series.isPremium || series.isCollection == true)
                  Positioned(
                    bottom: 20.h,
                    left: 20.w,
                    child: GestureDetector(
                      onTap: () {
                        if (series.seasons.isNotEmpty && series.seasons[homeController.selectedSeasonIndex.value].episodes.isNotEmpty) {
                          final episode = series.seasons[homeController.selectedSeasonIndex.value].episodes[0];
                          Get.to(() => VideoPlayerScreen(fileUuid: episode.fileUuid), transition: Transition.rightToLeftWithFade);
                        } else {
                          toastification.show(title: const Text('Error'), description: Text('no_episodes'.tr), style: ToastificationStyle.fillColored, type: ToastificationType.error, autoCloseDuration: const Duration(seconds: 3));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(color: AppColor.vividAmber, shape: BoxShape.circle),
                        child: Icon(Icons.play_arrow, color: Colors.black, size: 40.sp),
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
                    series.name.isEmpty ? 'untitled_movie'.tr : series.name,
                    style: AppTextStyles.montserratSemiBold.copyWith(color: AppColor.translucentWhite, fontSize: 25.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    '${series.updatedAt.isEmpty ? 'unknown_year'.tr : series.updatedAt} • ${series.formattedSeasons}',
                    style: AppTextStyles.montserratSemiBold.copyWith(color: AppColor.customGray, fontSize: 14.sp),
                  ),
                  SizedBox(height: 3.h),
                  Text(series.formattedGenres, style: AppTextStyles.montserratSemiBold.copyWith(color: AppColor.customGray, fontSize: 13.sp)),
                  SizedBox(height: 18.h),

                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _actionItem(icon: Icons.add, label: 'my_list'.tr, onTap: () => homeController.addToWatchLater(series.id, series.aliasType)),
                      SizedBox(width: 25.w),
                      _actionItem(
                        icon: homeController.SeriesDetails.value?.liked ?? false ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                        label: '${'like'.tr} (${homeController.SeriesDetails.value?.likes ?? 0})',
                        color: homeController.SeriesDetails.value?.liked ?? false ? AppColor.vividAmber : AppColor.customDarkGray2,
                        onTap: () => homeController.likeSeries(series.id, series.aliasType),
                      ),
                      SizedBox(width: 25.w),
                      _actionItem(
                        icon: homeController.SeriesDetails.value?.disliked ?? false ? Icons.thumb_down_alt : Icons.thumb_down_alt_outlined,
                        label: '${'dislike'.tr} (${homeController.SeriesDetails.value?.dislikes ?? 0})',
                        color: homeController.SeriesDetails.value?.disliked ?? false ? AppColor.vividAmber : AppColor.customDarkGray2,
                        onTap: () => homeController.dislikeSeries(series.id, series.aliasType),
                      ),
                      SizedBox(width: 25.w),
                      _actionItem(icon: Icons.share, label: 'share'.tr, onTap: () => Share.share('Check out ${series.name}: ${series.description}')),
                    ],
                  )),
                  SizedBox(height: 18.h),

                  Text('description_title'.tr, style: AppTextStyles.montserratSemiBold.copyWith(color: AppColor.translucentWhite, fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  SizedBox(height: 7.h),
                  Text(series.description.isEmpty ? 'no_description'.tr : series.description, style: AppTextStyles.montserratSemiBold.copyWith(color: AppColor.customGray, fontSize: 13.sp, height: 1.4)),

                  SizedBox(height: 20.h),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('episodes'.tr, style: AppTextStyles.montserratBold.copyWith(color: AppColor.white, fontSize: 18.sp)),
                      Divider(color: AppColor.sunnyYellow, endIndent: 240.w),
                    ],
                  ),
                  SizedBox(height: 5.h),

                  Obx(() => Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                        decoration: BoxDecoration(color: AppColor.customDarkGray2, borderRadius: BorderRadius.circular(20.r)),
                        child: DropdownButton<int>(
                          value: homeController.selectedSeasonIndex.value,
                          items: series.seasons.isNotEmpty
                              ? series.seasons.asMap().entries.map((entry) {
                            final index = entry.key;
                            final season = entry.value;
                            return DropdownMenuItem<int>(
                              value: index,
                              child: Text(
                                season.seasonName.isEmpty ? 'Season ${index + 1}' : season.seasonName,
                                style: AppTextStyles.montserratMedium.copyWith(color: AppColor.white, fontSize: 14.sp),
                              ),
                            );
                          }).toList()
                              : [
                            DropdownMenuItem<int>(
                              value: 0,
                              child: Text('No Seasons', style: AppTextStyles.montserratMedium.copyWith(color: AppColor.white, fontSize: 14.sp)),
                            ),
                          ],
                          onChanged: series.seasons.isNotEmpty
                              ? (int? newIndex) {
                            if (newIndex != null) homeController.selectedSeasonIndex.value = newIndex;
                          }
                              : null,
                          dropdownColor: AppColor.customDarkGray2,
                          underline: const SizedBox(),
                          icon: Icon(Icons.keyboard_arrow_down, color: AppColor.white),
                        ),
                      ),
                    ],
                  )),
                  SizedBox(height: 18.h),

                  Column(
                    children: series.seasons.isNotEmpty && series.seasons[homeController.selectedSeasonIndex.value].episodes.isNotEmpty
                        ? series.seasons[homeController.selectedSeasonIndex.value].episodes.asMap().entries.map((entry) {
                      final episode = entry.value;
                      return GestureDetector(
                        onTap: (!series.isPremium || series.isCollection == true)
                            ? () => Get.to(() => VideoPlayerScreen(fileUuid: episode.fileUuid), transition: Transition.rightToLeftWithFade)
                            : () => _showPaymentBottomSheet(context, series, settingController),
                        child: ShowEpisode(
                          imageUrl: series.firstPosterUrl,
                          title: episode.title.isEmpty ? 'Episode ${entry.key + 1}' : episode.title,
                        ),
                      );
                    }).toList()
                        : [
                      Text('no_episodes'.tr, style: AppTextStyles.montserratSemiBold.copyWith(color: AppColor.customGray, fontSize: 14.sp)),
                    ],
                  ),

                  if (series.relatedSeries.isNotEmpty)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('related_series'.tr, style: AppTextStyles.montserratSemiBold.copyWith(color: AppColor.translucentWhite, fontSize: 16.sp, fontWeight: FontWeight.w600)),
                            TextButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Text('see_all'.tr, style: AppTextStyles.montserratSemiBold.copyWith(color: Colors.white, fontSize: 13.sp)),
                                  SizedBox(width: 5.w),
                                  Icon(Icons.arrow_forward, color: Colors.red),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 11.h),
                        SizedBox(
                          height: 150.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: series.relatedSeries.length,
                            itemBuilder: (context, index) {
                              final related = series.relatedSeries[index];
                              return GestureDetector(
                                onTap: () => homeController.fetchSeriesDetails(related.id, related.aliasType),
                                child: Container(
                                  width: 100.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  child: related.postersUrl.isNotEmpty
                                      ? Image.network(related.postersUrl.first, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported, size: 50.sp))
                                      : Icon(Icons.image_not_supported, size: 50.sp),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionItem({required IconData icon, required String label, Color? color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color ?? AppColor.customDarkGray2, size: 24.sp),
          SizedBox(height: 4.h),
          Text(label, style: AppTextStyles.montserratSemiBold.copyWith(color: color ?? AppColor.customDarkGray2, fontSize: 11.sp)),
        ],
      ),
    );
  }

  void _showPaymentBottomSheet(BuildContext context, Series series, Settingcontroller controller) {
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
            Text('choose_payment_method'.tr, style: AppTextStyles.montserratSemiBold.copyWith(color: Colors.white, fontSize: 18.sp)),
            SizedBox(height: 20.h),
            ...paymentMethods.map((method) {
              bool isSelected = selectedMethod.value == method;
              return GestureDetector(
                onTap: () => selectedMethod.value = method,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(color: isSelected ? Colors.white12 : Colors.transparent, borderRadius: BorderRadius.circular(10.r)),
                  child: Row(
                    children: [
                      Container(
                        width: 18.w,
                        height: 18.w,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white)),
                        child: isSelected
                            ? Center(child: Container(width: 10.w, height: 10.w, decoration: BoxDecoration(color: AppColor.vividAmber, shape: BoxShape.circle)))
                            : null,
                      ),
                      SizedBox(width: 12.w),
                      Text(method, style: AppTextStyles.montserratSemiBold.copyWith(color: Colors.white, fontSize: 14.sp)),
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
                  id: series.id,
                  aliasType: series.aliasType,
                  isMonCash: selectedMethod.value == 'local_moncash'.tr,
                );
              },
              gradient: LinearGradient(colors: [Colors.orange, Colors.yellowAccent]),
              width: double.infinity,
              height: 30.h,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 15.h),
          ],
        )),
      ),
    );
  }
}

class ShowEpisode extends StatelessWidget {
  final String imageUrl;
  final String title;

  const ShowEpisode({Key? key, required this.imageUrl, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      color: AppColor.darkGray2,
      child: Row(
        children: [
          ClipRRect(
            child: Container(
              width: 120.w,
              height: 68.h,
              color: Colors.black,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) => loadingProgress == null ? child : Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.w)),
                errorBuilder: (context, error, stackTrace) => Icon(Icons.image, color: AppColor.vividAmber, size: 30.sp),
              )
                  : Icon(Icons.image, color: AppColor.vividAmber, size: 30.sp),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.montserratSemiBold.copyWith(color: Colors.white, fontSize: 14.sp)),
              ],
            ),
          ),
          Container(padding: EdgeInsets.all(8.w), child: Icon(Icons.play_circle_outline, color: Colors.white, size: 32.sp)),
        ],
      ),
    );
  }
}