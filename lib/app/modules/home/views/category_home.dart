import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mompr_em/app/res/assets/imageassets.dart';
import 'package:mompr_em/app/res/colors/color.dart';
import 'package:mompr_em/app/res/fonts/fonts.dart';

import '../widgets/streaming_wdiget.dart';

class CategoryHome extends StatelessWidget {
  CategoryHome({super.key});

  final List<String> movieTypes = [
    "Action",
    "Comedy",
    "Drama",
    "Horror",
    "Movie",
  ];

  final List<String> categories = [
    "Releases in the Past Year",
    "Continue Watching for Drashti",
    "Suspenseful TV Shows",
    "Selected for You Today",
    "My List",
    "New Releases",
    "Ensemble TV Shows",
    "Chilly Thrillers",
    "Only on Werli",
  ];

  // List of 10 images
  final List<String> previewImages = [
    ImageAssets.img_5,
    ImageAssets.img_6,
    ImageAssets.img_7,
    ImageAssets.img_8,
    ImageAssets.img_9,
    ImageAssets.img_10,
    ImageAssets.img_11,
    ImageAssets.img_12,
    ImageAssets.img_13,
    ImageAssets.img_14,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:CategoryHomeWidget(
          bannerMovies: {
            ImageAssets.img_5: ["Action", "Drama", "Thriller"],
            ImageAssets.img_jpg: ["Comedy", "Romance"],
            ImageAssets.img_jpg_1: ["Horror", "Suspense"],
            ImageAssets.img_13: ["Sci-Fi", "Adventure"],
          },
          previewImages: [
            ImageAssets.img_5,
            ImageAssets.img_6,
            ImageAssets.img_7,
            ImageAssets.img_8,
            ImageAssets.img_9,
            ImageAssets.img_10,
          ],
          categoryImages: {
            "Releases in the Past Year": [
              ImageAssets.img_5,
              ImageAssets.img_6,
              ImageAssets.img_7,
            ],
            "Continue Watching for Drashti": [
              ImageAssets.img_8,
              ImageAssets.img_9,
            ],
            "Suspenseful TV Shows": [
              ImageAssets.img_jpg_1,
              ImageAssets.img_10,
            ],
            "Selected for You Today": [
              ImageAssets.img_13,
              ImageAssets.img_6,
              ImageAssets.img_7,
            ],
            "My List": [
              ImageAssets.img_8,
              ImageAssets.img_9,
            ],
            "New Releases": [
              ImageAssets.img_5,
              ImageAssets.img_7,
              ImageAssets.img_10,
            ],
            "Ensemble TV Shows": [
              ImageAssets.img_jpg,
              ImageAssets.img_13,
            ],
            "Chilly Thrillers": [
              ImageAssets.img_7,
              ImageAssets.img_8,
            ],
            "Only on Werli": [
              ImageAssets.img_9,
              ImageAssets.img_10,
              ImageAssets.img_13,
            ],
          },
        )


    );
  }
}