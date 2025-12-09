import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Nuweli/app/res/assets/imageassets.dart';
import '../../../res/fonts/fonts.dart';
import '../controllers/comingsoon_controller.dart';
import '../widgets/moviecard_widget.dart';
import '../widgets/notification_card.dart';


class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    final ComingSoonController controller = Get.find();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    SvgPicture.asset(ImageAssets.svg19, height: 30.h),
                    SizedBox(width: 10.w),
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
              SizedBox(height: 10.h,),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (controller.error.value.isNotEmpty) {
                  return Center(child: Text(controller.error.value));
                }
                if (controller.items.isEmpty) {
                  return Center(child: Text('No upcoming content'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    return item.isSeries
                        ? NetflixStyleCard(
                      imageUrl: item.imageUrl ?? ImageAssets.img_14,
                      title: item.title,
                      subtitle: item.subtitle ?? 'Series',
                      time: item.releaseInfo,
                    )
                        : MovieCardWidget(
                      isNotify: item.isNotify,
                      title: item.title,
                      subtitle: item.subtitle ?? '',
                      imageUrl: item.imageUrl ?? ImageAssets.img_14,
                      genres: item.genres,
                      seasonInfo: item.releaseInfo,
                      onRemindMeTap: (){
                        controller.remindMe(item.id);
                      },
                      onShareTap: () => print('Share: ${item.title}'), fileUuid: item.fileUuid??"",
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}