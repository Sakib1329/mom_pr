import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Nuweli/app/res/assets/imageassets.dart';

import 'package:Nuweli/app/res/fonts/fonts.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/models/movie_model.dart';

import '../../home/models/series_model.dart';

class Collections extends StatelessWidget {
  const Collections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: SvgPicture.asset('assets/icons/svg1.svg', height: 20.h),
        centerTitle: true,
      ),
      body: Obx(() {
        if (homeController.iscollectionLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (homeController.collectionErrorMessage.isNotEmpty) {
          return Center(
            child: Text(
              homeController.collectionErrorMessage.value,
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          );
        }
        if (homeController.collectionitems.isEmpty) {
          return Center(
            child: Text(
              'No items in Premium collection list',
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(ImageAssets.svg26),
                    SizedBox(width: 5.w,),
                    Text(
                      'Premium Collection' ,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 14.h,
                    childAspectRatio: 0.58,
                  ),
                  itemCount: homeController.collectionitems.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = homeController.collectionitems[index];
                    String imageUrl = '';
                    String title = '';
                    String aliasType = '';

                    if (item is Movie) {
                      imageUrl = item.postersUrl.isNotEmpty
                          ? item.postersUrl.first
                          : '';
                      title = item.title;
                      aliasType = 'movie';
                    } else if (item is Series) {
                      imageUrl = item.postersUrl.isNotEmpty
                          ? item.postersUrl.first
                          : '';
                      title = item.name;
                      aliasType = 'series';
                    }

                    return GestureDetector(
                      onTap: () async {
                        if (aliasType.isNotEmpty) {
                          await homeController.fetchMovieDetails(item.id, aliasType);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6.r,
                              offset: Offset(0, 3.h),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              imageUrl.isNotEmpty
                                  ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[800],
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey[400],
                                      size: 42.sp,
                                    ),
                                  );
                                },
                              )
                                  : Container(
                                color: Colors.grey[800],
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey[400],
                                  size: 42.sp,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 65.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.8),
                                      ],
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 10.h,
                                      ),
                                      child: Text(
                                        title,
                                        style: AppTextStyles.montserratMedium.copyWith(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}