import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import '../controllers/home_controller.dart';
import '../widgets/streaming_wdiget.dart';

class Seriespage extends StatelessWidget {
  const Seriespage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Obx(() {
      final bannerMovies = <String, List<String>>{};
      final popularSeries = homeController.allSeriesResponse.value?.popular ?? [];
      for (var series in popularSeries) {
        if (series.postersUrl.isNotEmpty && series.postersUrl.first.isNotEmpty) {
          bannerMovies[series.postersUrl.first] = series.genres.map((g) => g.name).toList().cast<String>();
        }
      }

      final List<Map<String, dynamic>> previewItems = popularSeries
          .where((series) => series.postersUrl.isNotEmpty && series.postersUrl.first.isNotEmpty)
          .take(8)
          .map((series) => {
        'id': series.id,
        'alias': series.aliasType,
        'poster': series.postersUrl.first,
      })
          .toList();

      final categoryImages = <String, List<Map<String, dynamic>>>{};

      final categories = {
        'popular_series'.tr: homeController.allSeriesResponse.value?.popular,
        'watch_later_series'.tr: homeController.allSeriesResponse.value?.watchLater,
        'previous_year_series'.tr: homeController.allSeriesResponse.value?.previousYear,
        'animated_series'.tr: homeController.allSeriesResponse.value?.animation,
        'action_series'.tr: homeController.allSeriesResponse.value?.action,
        'drama_series'.tr: homeController.allSeriesResponse.value?.drama,
        'horror_series'.tr: homeController.allSeriesResponse.value?.horror,
        'sci_fi_series'.tr: homeController.allSeriesResponse.value?.scienceFiction,
        'mystery_series'.tr: homeController.allSeriesResponse.value?.mystery,
      };

      categories.forEach((title, list) {
        if (list != null && list.isNotEmpty) {
          final items = list
              .where((series) => series.postersUrl.isNotEmpty && series.postersUrl.first.isNotEmpty)
              .map((series) => {
            'id': series.id,
            'alias': series.aliasType,
            'poster': series.postersUrl.first,
          })
              .toList();
          if (items.isNotEmpty) categoryImages[title] = items;
        }
      });

      return Scaffold(
        body: CategoryHomeWidget(
          bannerMovies: bannerMovies,
          previewItems: previewItems,
          categoryImages: categoryImages,
          homeController: homeController,
        ),
      );
    });
  }
}