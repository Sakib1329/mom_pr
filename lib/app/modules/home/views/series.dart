import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          bannerMovies[series.postersUrl.first] = series.genres
              .map((g) => g.name)
              .toList()
              .cast<String>();
        }
      }

      // Changed from List<String> to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> previewItems = popularSeries
          .asMap()
          .entries
          .where(
            (entry) =>
        entry.value.postersUrl.isNotEmpty &&
            entry.value.postersUrl.first.isNotEmpty,
      )
          .take(8)
          .map((entry) => {
        'id': entry.value.id,
        'alias': entry.value.aliasType,
        'poster': entry.value.postersUrl.first,
      })
          .toList();

      final categoryImages = {
        if (homeController.allSeriesResponse.value?.popular.isNotEmpty ?? false)
          "Popular Series": homeController.allSeriesResponse.value!.popular
              .where(
                (series) =>
            series.postersUrl.isNotEmpty &&
                series.postersUrl.first.isNotEmpty,
          )
              .map(
                (series) => {
              'id': series.id,
              'alias': series.aliasType,
              'poster': series.postersUrl.first,
            },
          )
              .toList(),
        if (homeController.allSeriesResponse.value?.watchLater.isNotEmpty ??
            false)
          "Watch Later": homeController.allSeriesResponse.value!.watchLater
              .where(
                (series) =>
            series.postersUrl.isNotEmpty &&
                series.postersUrl.first.isNotEmpty,
          )
              .map(
                (series) => {
              'id': series.id,
              'alias': series.aliasType,
              'poster': series.postersUrl.first,
            },
          )
              .toList(),
        if (homeController.allSeriesResponse.value?.previousYear.isNotEmpty ??
            false)
          "Previous Year Series": homeController
              .allSeriesResponse
              .value!
              .previousYear
              .where(
                (series) =>
            series.postersUrl.isNotEmpty &&
                series.postersUrl.first.isNotEmpty,
          )
              .map(
                (series) => {
              'id': series.id,
              'alias': series.aliasType,
              'poster': series.postersUrl.first,
            },
          )
              .toList(),
        if (homeController.allSeriesResponse.value?.animation.isNotEmpty ??
            false)
          "Animated Series": homeController.allSeriesResponse.value!.animation
              .where(
                (series) =>
            series.postersUrl.isNotEmpty &&
                series.postersUrl.first.isNotEmpty,
          )
              .map(
                (series) => {
              'id': series.id,
              'alias': series.aliasType,
              'poster': series.postersUrl.first,
            },
          )
              .toList(),
        if (homeController.allSeriesResponse.value?.action.isNotEmpty ?? false)
          "Action Series": homeController.allSeriesResponse.value!.action
              .where(
                (series) =>
            series.postersUrl.isNotEmpty &&
                series.postersUrl.first.isNotEmpty,
          )
              .map(
                (series) => {
              'id': series.id,
              'alias': series.aliasType,
              'poster': series.postersUrl.first,
            },
          )
              .toList(),
        if (homeController.allSeriesResponse.value?.drama.isNotEmpty ?? false)
          "Drama Series": homeController.allSeriesResponse.value!.drama
              .where(
                (series) =>
            series.postersUrl.isNotEmpty &&
                series.postersUrl.first.isNotEmpty,
          )
              .map(
                (series) => {
              'id': series.id,
              'alias': series.aliasType,
              'poster': series.postersUrl.first,
            },
          )
              .toList(),
        if (homeController.allSeriesResponse.value?.horror.isNotEmpty ?? false)
          "Horror Series": homeController.allSeriesResponse.value!.horror
              .where(
                (series) =>
            series.postersUrl.isNotEmpty &&
                series.postersUrl.first.isNotEmpty,
          )
              .map(
                (series) => {
              'id': series.id,
              'alias': series.aliasType,
              'poster': series.postersUrl.first,
            },
          )
              .toList(),
        if (homeController.allSeriesResponse.value?.scienceFiction.isNotEmpty ??
            false)
          "Science-Fiction Series": homeController
              .allSeriesResponse
              .value!
              .scienceFiction
              .where(
                (series) =>
            series.postersUrl.isNotEmpty &&
                series.postersUrl.first.isNotEmpty,
          )
              .map(
                (series) => {
              'id': series.id,
              'alias': series.aliasType,
              'poster': series.postersUrl.first,
            },
          )
              .toList(),
        if (homeController.allSeriesResponse.value?.mystery.isNotEmpty ?? false)
          "Mystery Series": homeController.allSeriesResponse.value!.mystery
              .where(
                (series) =>
            series.postersUrl.isNotEmpty &&
                series.postersUrl.first.isNotEmpty,
          )
              .map(
                (series) => {
              'id': series.id,
              'alias': series.aliasType,
              'poster': series.postersUrl.first,
            },
          )
              .toList(),
      };

      return Scaffold(
        body: CategoryHomeWidget(
          bannerMovies: bannerMovies,
          previewItems: previewItems, // Updated to use previewItems
          categoryImages: {
            for (var entry in categoryImages.entries)
              if (entry.value.isNotEmpty) entry.key: entry.value,
          },
          homeController: homeController,
        ),
      );
    });
  }
}