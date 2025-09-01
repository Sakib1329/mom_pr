import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mompr_em/app/res/assets/imageassets.dart';

import '../widgets/movie_details.widget.dart';

class MovieDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data
    final relatedMovies = [
      MovieItem(title: "Avengers: Infinity War", posterUrl: ImageAssets.img_9),
      MovieItem(title: "Panther", posterUrl:ImageAssets.img_6),
      MovieItem(title: "Spider-Man", posterUrl: ImageAssets.img_7),
      MovieItem(title: "Thor", posterUrl: ImageAssets.img_10),
    ];

    final recentReleases = [
      MovieItem(title: "Money Heist",
          posterUrl: ImageAssets.img_11
      ),
      MovieItem(title: "Stranger Things",
          posterUrl: ImageAssets.img_13
      ),
      MovieItem(title: "Peaky Blinders",
          posterUrl: ImageAssets.img_12
      ),
    ];

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,
leading:BackButton(
  color: Colors.white,
onPressed: (){
  Get.back();
},
),
        centerTitle: true,
        title: SvgPicture.asset('assets/icons/svg1.svg', height: 30.h),
      ),
      body: MovieDetailsWidget(
        title: "Money Heist",
        year: "2018",
        duration: "2h 36m",
        genre: "Bangladeshi Superhero Movie",
        posterUrl: ImageAssets.img_6,
        description: "Bijli is a 2018 Bangladeshi Superhero film directed by Tuhin Chowdhury and produced by Bobital Films. Faria Piash is the protagonist and Topu is the deuteragonist. Sabyasachi Roy as the antagonist. The film was released countrywide on 1st a long established but non-electric Bangladeshi superhero.",
        relatedMovies: relatedMovies,
        recentReleases: recentReleases,
      ),
    );
  }
}