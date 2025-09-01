import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mompr_em/app/res/assets/imageassets.dart';

import '../../../res/fonts/fonts.dart';
import '../widgets/moviecard_widget.dart';
import '../widgets/notification_card.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                  SvgPicture.asset(ImageAssets.svg19,height: 30.h,),
                    SizedBox(width: 10.w,),
                    Text(
                      "Notifications",
                      style: AppTextStyles.montserratSemiBold.copyWith(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              NetflixStyleCard(
                imageUrl: ImageAssets.img_15,
                title: 'El Chapo',
                subtitle: 'Crime Drama',
                time: 'Nov 6',
              ),
              NetflixStyleCard(
                imageUrl: ImageAssets.img_14,
                title: 'El Chapo',
                subtitle: 'Crime Drama',
                time: 'Nov 6',
              ),
              MovieCardWidget(
                title: "Tiny Pretty Things",
                subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sit quam dui, vivamus bibendum et. Ut mollit lorem dolor felis non accumsan accumsan quis. Massa, id ut ipsum aliquam enim non posuere pulvinar diam.",
                imageUrl: ImageAssets.img_14, // Replace with actual image URL
                genres: ["Steamy", "Soapy", "Slow Burn", "Suspenseful", "Teen", "Mystery"],
                seasonInfo: "Season 1 Coming December 14",
                onRemindMeTap: () {
                  print("Remind me tapped");
                },
                onShareTap: () {
                  print("Share tapped");
                },
              ),
              MovieCardWidget(
                title: "Tiny Pretty Things",
                subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sit quam dui, vivamus bibendum et. Ut mollit lorem dolor felis non accumsan accumsan quis. Massa, id ut ipsum aliquam enim non posuere pulvinar diam.",
                imageUrl: ImageAssets.img_15, // Replace with actual image URL
                genres: ["Steamy", "Soapy", "Slow Burn", "Suspenseful", "Teen", "Mystery"],
                seasonInfo: "Season 1 Coming December 14",
                onRemindMeTap: () {
                  print("Remind me tapped");
                },
                onShareTap: () {
                  print("Share tapped");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
