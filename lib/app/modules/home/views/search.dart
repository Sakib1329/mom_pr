import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Nuweli/app/modules/home/controllers/home_controller.dart';
import 'package:Nuweli/app/res/colors/color.dart';
import 'package:Nuweli/app/res/fonts/fonts.dart';
import '../models/movie_model.dart';
import '../models/series_model.dart';

class SearchScreen extends StatelessWidget {
  final HomeController controller=Get.find();
   SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              margin: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8.r),

              ),
              child: TextField(
                controller: textController,
                onChanged: (value) => controller.onSearchChanged(value),
                decoration: InputDecoration(
                  hintText: 'Search for a show, movie, genre, e.t.c',
                  hintStyle: AppTextStyles.montserratRegular.copyWith(
                    color: AppColor.white,
                    fontSize: 12.sp,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 22.sp),
                  suffixIcon: Obx(
                        () => controller.searchQuery.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey, size: 22.sp),
                      onPressed: () {
                        textController.clear();
                        controller.clearSearch();
                      },
                    )
                        : Container(), // Fallback widget when searchQuery is empty
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                ),
                style: AppTextStyles.montserratRegular.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),

            // Top Searches Title
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Top Searches',
                style: AppTextStyles.montserratBold.copyWith(
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Shows List
            Expanded(
              child: Obx(
                    () => controller.isLoading.value
                    ? Center(child: CircularProgressIndicator(color: Colors.white))
                    : controller.errorMessage.isNotEmpty
                    ? Center(
                  child: Text(
                    controller.errorMessage.value,
                    style: AppTextStyles.montserratRegular.copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                )
                    : controller.items.isEmpty
                    ? Center(
                  child: Text(
                    'No results found',
                    style: AppTextStyles.montserratRegular.copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    final title = item is Movie ? item.title : item.name;
                    final imageUrl = (item is Movie ? item.postersUrl : item.postersUrl).isNotEmpty
                        ? (item is Movie ? item.postersUrl.first : item.postersUrl.first)
                        : '';

                    return ShowItemNetwork(
                      imageUrl: imageUrl,
                      title: title,
                      onTap: () async {
                        final item = controller.items[index];
                        final alias = (item is Movie)
                            ? (item.aliasType.isNotEmpty ? item.aliasType : 'movie')
                            : (item is Series && item.aliasType.isNotEmpty ? item.aliasType : 'series');

                        if (alias.toLowerCase() == 'movie') {
                          await controller.fetchMovieDetails(item.id, alias);
                        } else {
                          await controller.fetchSeriesDetails(item.id, alias);
                        }
                      },

                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowItemNetwork extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onTap; // ✅ Added callback

  const ShowItemNetwork({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.onTap, // ✅ Required in constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // ✅ Detect tap anywhere on the row
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        color: AppColor.darkGray2,
        child: Row(
          children: [
            // Thumbnail Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r), // Optional rounded corners
              child: Container(
                width: 120.w,
                height: 68.h,
                color: Colors.black,
                child: imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[800],
                      child: Center(
                        child: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.w,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.black,
                      child: Icon(
                        Icons.image,
                        color: AppColor.vividAmber,
                        size: 30.sp,
                      ),
                    );
                  },
                )
                    : Container(
                  color: Colors.black,
                  child: Icon(
                    Icons.image,
                    color: AppColor.vividAmber,
                    size: 30.sp,
                  ),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // Title
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.montserratSemiBold.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),

            // Play Button
            Container(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 32.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
