import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Nuweli/app/res/assets/imageassets.dart';
import '../controllers/home_controller.dart';
import '../widgets/streaming_wdiget.dart';

class CategoryHome extends StatelessWidget {
  const CategoryHome({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Obx(() {
      if (homeController.isAllContentLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }
      if (homeController.allContentErrorMessage.isNotEmpty) {
        return Center(
          child: Text(
            homeController.allContentErrorMessage.value,
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
        );
      }
      if (homeController.allContentResponse.value == null) {
        return const Center(
          child: Text(
            'No content available',
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      final data = homeController.allContentResponse.value!;
      final movies = data.movies;
      final series = data.series;

      // Use popularItems instead of mixedPopular
      final bannerMovies = <String, List<String>>{};
      for (var item in homeController.popularItems) {
        if (item.postersUrl.isNotEmpty && item.postersUrl.first.isNotEmpty) {
          bannerMovies[item.postersUrl.first] = item.genres
              .map((g) => g.name)
              .toList()
              .cast<String>();
        }
      }

      // Map popularItems to previewItems (limit to 8)
      final List<Map<String, dynamic>> previewItems = homeController.popularItems
          .where(
            (item) =>
        item.postersUrl.isNotEmpty && item.postersUrl.first.isNotEmpty,
      )
          .take(8)
          .map((item) => {
        'id': item.id,
        'alias': item.aliasType,
        'poster': item.firstPosterUrl as String,
      })
          .toList();

      final categoryImages = <String, List<Map<String, dynamic>>>{};
      for (var category in homeController.movieTypes) {
        final categoryName = _getCategoryTitle(category);
        final movieCategory = _getCategoryField(movies, category);
        final seriesCategory = _getCategoryField(series, category);
        final mixedCategory = _alternateMoviesAndSeries(
          movieCategory,
          seriesCategory,
        );
        final categoryList = mixedCategory
            .where(
              (item) =>
          item.postersUrl.isNotEmpty &&
              item.postersUrl.first.isNotEmpty,
        )
            .map(
              (item) => {
            'id': item.id,
            'alias': item.aliasType,
            'poster': item.firstPosterUrl,
          },
        )
            .toList();
        if (categoryList.isNotEmpty) {
          categoryImages[categoryName] = categoryList;
        }
      }

      // Fallback for previewItems when empty
      final List<Map<String, dynamic>> finalPreviewItems = previewItems.isNotEmpty
          ? previewItems
          : [
        {'id': 0, 'alias': 'movie', 'poster': ImageAssets.img_5},
        {'id': 0, 'alias': 'movie', 'poster': ImageAssets.img_6},
        {'id': 0, 'alias': 'movie', 'poster': ImageAssets.img_7},
        {'id': 0, 'alias': 'movie', 'poster': ImageAssets.img_8},
        {'id': 0, 'alias': 'movie', 'poster': ImageAssets.img_9},
        {'id': 0, 'alias': 'movie', 'poster': ImageAssets.img_10},
        {'id': 0, 'alias': 'movie', 'poster': ImageAssets.img_11},
        {'id': 0, 'alias': 'movie', 'poster': ImageAssets.img_12},
        {'id': 0, 'alias': 'movie', 'poster': ImageAssets.img_13},
        {'id': 0, 'alias': 'movie', 'poster': ImageAssets.img_14},
      ];

      return CategoryHomeWidget(
        bannerMovies: bannerMovies,
        previewItems: finalPreviewItems, // Updated to use finalPreviewItems
        categoryImages: categoryImages,
        homeController: homeController,
      );
    });
  }

  List<dynamic> _getCategoryField(dynamic response, String category) {
    switch (category) {
      case 'popular':
        return response.popular;
      case 'watch_later':
        return response.watchLater;
      case 'watch_history':
        return response.watchHistory;
      case 'previous_year':
        return response.previousYear;
      case 'animation':
        return response.animation;
      case 'action':
        return response.action;
      case 'drama':
        return response.drama;
      case 'horror':
        return response.horror;
      case 'science_fiction':
        return response.scienceFiction;
      case 'mystery':
        return response.mystery;
      default:
        return [];
    }
  }

  List<dynamic> _alternateMoviesAndSeries(
      List<dynamic> movies,
      List<dynamic> series,
      ) {
    final mixed = <dynamic>[];
    final maxLength = movies.length > series.length
        ? movies.length
        : series.length;
    for (int i = 0; i < maxLength; i++) {
      if (i < movies.length) mixed.add(movies[i]);
      if (i < series.length) mixed.add(series[i]);
    }
    return mixed;
  }

  String _getCategoryTitle(String category) {
    final titleMap = {
      'popular': 'Trending This Week',
      'watch_later': 'Your Watchlist',
      'watch_history': 'Watch History',
      'previous_year': 'Last Year’s Favorites',
      'animation': 'Animated Classics',
      'action': 'Action Thrillers',
      'drama': 'Compelling Dramas',
      'horror': 'Horror Highlights',
      'science_fiction': 'Sci-Fi Adventures',
      'mystery': 'Mystery & Suspense',
    };
    return titleMap[category] ??
        category.replaceAll('_', ' ').capitalizeFirst! + ' Movies & Series';
  }
}