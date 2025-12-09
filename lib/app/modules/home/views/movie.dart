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

      // Map popularMovies to bannerMovies
      final bannerMovies = <String, List<String>>{};
      for (var movie in popularMovies) {
        if (movie.postersUrl.isNotEmpty && movie.postersUrl.first.isNotEmpty) {
          bannerMovies[movie.postersUrl.first] = movie.genres
              .map((g) => g.name)
              .toList()
              .cast<String>();
        }
      }

      // Map popularMovies to previewItems (limit to 8)
      final previewItems = popularMovies
          .asMap()
          .entries
          .where(
            (entry) =>
        entry.value.postersUrl.isNotEmpty &&
            entry.value.postersUrl.first.isNotEmpty,
      )
          .take(8)
          .map((entry) =>
      {
        'id': entry.value.id,
        'alias': entry.value.aliasType,
        'poster': entry.value.postersUrl.first,
      })
          .toList();

      // Map backend data to categoryImages
      final categoryImages = {
        if (movieResponse?.watchLater.isNotEmpty ?? false)
          "My List": movieResponse!.watchLater
              .where(
                (movie) =>
            movie.postersUrl.isNotEmpty &&
                movie.postersUrl.first.isNotEmpty,
          )
              .map(
                (movie) =>
            {
              'id': movie.id,
              'alias': movie.aliasType,
              'poster': movie.postersUrl.first,
            },
          )
              .toList(),
        if (movieResponse?.previousYear.isNotEmpty ?? false)
          "Previous Year Releases": movieResponse!.previousYear
              .where(
                (movie) =>
            movie.postersUrl.isNotEmpty &&
                movie.postersUrl.first.isNotEmpty,
          )
              .map(
                (movie) =>
            {
              'id': movie.id,
              'alias': movie.aliasType,
              'poster': movie.postersUrl.first,
            },
          )
              .toList(),
        if (movieResponse?.animation.isNotEmpty ?? false)
          "Animated Movies": movieResponse!.animation
              .where(
                (movie) =>
            movie.postersUrl.isNotEmpty &&
                movie.postersUrl.first.isNotEmpty,
          )
              .map(
                (movie) =>
            {
              'id': movie.id,
              'alias': movie.aliasType,
              'poster': movie.postersUrl.first,
            },
          )
              .toList(),
        if (movieResponse?.action.isNotEmpty ?? false)
          "Action Movies": movieResponse!.action
              .where(
                (movie) =>
            movie.postersUrl.isNotEmpty &&
                movie.postersUrl.first.isNotEmpty,
          )
              .map(
                (movie) =>
            {
              'id': movie.id,
              'alias': movie.aliasType,
              'poster': movie.postersUrl.first,
            },
          )
              .toList(),
        if (movieResponse?.drama.isNotEmpty ?? false)
          "Drama Movies": movieResponse!.drama
              .where(
                (movie) =>
            movie.postersUrl.isNotEmpty &&
                movie.postersUrl.first.isNotEmpty,
          )
              .map(
                (movie) =>
            {
              'id': movie.id,
              'alias': movie.aliasType,
              'poster': movie.postersUrl.first,
            },
          )
              .toList(),
        if (movieResponse?.horror.isNotEmpty ?? false)
          "Horror Movies": movieResponse!.horror
              .where(
                (movie) =>
            movie.postersUrl.isNotEmpty &&
                movie.postersUrl.first.isNotEmpty,
          )
              .map(
                (movie) =>
            {
              'id': movie.id,
              'alias': movie.aliasType,
              'poster': movie.postersUrl.first,
            },
          )
              .toList(),
        if (movieResponse?.scienceFiction.isNotEmpty ?? false)
          "Science-Fiction Movies": movieResponse!.scienceFiction
              .where(
                (movie) =>
            movie.postersUrl.isNotEmpty &&
                movie.postersUrl.first.isNotEmpty,
          )
              .map(
                (movie) =>
            {
              'id': movie.id,
              'alias': movie.aliasType,
              'poster': movie.postersUrl.first,
            },
          )
              .toList(),
        if (movieResponse?.mystery.isNotEmpty ?? false)
          "Mystery Movies": movieResponse!.mystery
              .where(
                (movie) =>
            movie.postersUrl.isNotEmpty &&
                movie.postersUrl.first.isNotEmpty,
          )
              .map(
                (movie) =>
            {
              'id': movie.id,
              'alias': movie.aliasType,
              'poster': movie.postersUrl.first,
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
  }}