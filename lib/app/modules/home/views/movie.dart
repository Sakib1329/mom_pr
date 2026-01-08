import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/streaming_wdiget.dart';

class Moviepage extends StatelessWidget {
  const Moviepage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Obx(() {
      final movieResponse = homeController.allMoviesResponse.value;
      final popularMovies = movieResponse?.popular ?? [];

      final bannerMovies = <String, List<String>>{};
      for (var movie in popularMovies) {
        if (movie.postersUrl.isNotEmpty && movie.postersUrl.first.isNotEmpty) {
          bannerMovies[movie.postersUrl.first] = movie.genres.map((g) => g.name).toList().cast<String>();
        }
      }

      final previewItems = popularMovies
          .where((movie) => movie.postersUrl.isNotEmpty && movie.postersUrl.first.isNotEmpty)
          .take(8)
          .map((movie) => {
        'id': movie.id,
        'alias': movie.aliasType,
        'poster': movie.postersUrl.first,
      })
          .toList();

      final categoryImages = <String, List<Map<String, dynamic>>>{};

      final categories = {
        'your_watchlist'.tr: movieResponse?.watchLater,
        'last_years_favorites'.tr: movieResponse?.previousYear,
        'animated_classics'.tr: movieResponse?.animation,
        'action_thrillers'.tr: movieResponse?.action,
        'compelling_dramas'.tr: movieResponse?.drama,
        'horror_highlights'.tr: movieResponse?.horror,
        'sci_fi_adventures'.tr: movieResponse?.scienceFiction,
        'mystery_suspense'.tr: movieResponse?.mystery,
      };

      categories.forEach((title, list) {
        if (list != null && list.isNotEmpty) {
          final items = list
              .where((movie) => movie.postersUrl.isNotEmpty && movie.postersUrl.first.isNotEmpty)
              .map((movie) => {
            'id': movie.id,
            'alias': movie.aliasType,
            'poster': movie.postersUrl.first,
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