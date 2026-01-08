import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/Get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Nuweli/app/modules/settings/controllers/settingcontroller.dart';
import 'package:Nuweli/app/res/assets/imageassets.dart';
import 'package:Nuweli/app/res/colors/color.dart';
import 'package:Nuweli/app/res/fonts/fonts.dart';
import 'package:Nuweli/app/widgets/custom_button.dart';

class Subscription extends StatefulWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  final Settingcontroller controller = Get.find<Settingcontroller>();

  @override
  void initState() {
    super.initState();
    // ✅ Safe place to fetch data
    controller.fetchSubscriptionPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: SvgPicture.asset('assets/icons/svg1.svg', height: 20.h),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageAssets.img),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(width: double.infinity, height: double.infinity, color: Colors.black.withOpacity(0.6)),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 21.6.w),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator(color: AppColor.vividAmber));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 36.h),
                    Center(
                      child: Text(
                        'choose_plan'.tr,
                        style: AppTextStyles.montserratSemiBold.copyWith(color: AppColor.translucentWhite, fontSize: 18.sp),
                      ),
                    ),
                    SizedBox(height: 28.8.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildFeatureRow('premium_content')),
                        Expanded(child: _buildFeatureRow('ad_free')),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildFeatureRow('4k_streaming')),
                        Expanded(child: _buildFeatureRow('high_quality_sound')),
                      ],
                    ),
                    SizedBox(height: 36.h),
                    _buildPlanCard(
                      title: "Subscription",
                      subtitle: 'monthly_sub'.tr,
                      price: "\$${controller.moncashMonthly.value}",
                      isSelected: controller.selectedPlan.value == 0,
                      onTap: () => controller.selectPlan(0),
                    ),
                    SizedBox(height: 14.4.h),
                    _buildPlanCard(
                      title: "Premium",
                      subtitle: 'yearly_sub'.tr,
                      price: "\$${controller.moncashYearly.value}",
                      isSelected: controller.selectedPlan.value == 1,
                      onTap: () => controller.selectPlan(1),
                    ),
                    SizedBox(height: 21.6.h),
                    Row(
                      children: [
                        SvgPicture.asset(ImageAssets.svg25),
                        SizedBox(width: 7.2.w),
                        GestureDetector(
                          onTap: () => Get.snackbar("Redeem", "Redeem code tapped"),
                          child: Text(
                            'have_redeem_code'.tr,
                            style: AppTextStyles.montserratSemiBold.copyWith(
                              color: AppColor.white,
                              fontSize: 12.sp,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildFooterLink('privacy_policy'),
                        Text(" | ", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                        _buildFooterLink('terms_of_use'),
                        Text(" | ", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                        _buildFooterLink('faq'),
                      ],
                    ),
                    SizedBox(height: 21.6.h),
                    CustomButton(
                      onPress: () async => _showPaymentBottomSheet(context, controller),
                      title: 'subscribe_btn'.tr,
                      textColor: Colors.black,
                      gradient: LinearGradient(colors: [AppColor.vividAmber, AppColor.sunnyYellow], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      width: double.infinity,
                      height: 30.h,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 21.6.h),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check, color: AppColor.white, size: 18.sp),
        SizedBox(width: 5.w),
        Flexible(
          child: Text(
            text.tr,
            style: AppTextStyles.montserratSemiBold.copyWith(color: AppColor.translucentWhite, fontSize: 12.sp, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String subtitle,
    required String price,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.8.r),
          gradient: isSelected
              ? LinearGradient(colors: [AppColor.vividAmber, AppColor.sunnyYellow], begin: Alignment.topLeft, end: Alignment.bottomRight)
              : null,
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.montserratSemiBold.copyWith(color: isSelected ? AppColor.background : AppColor.translucentWhite, fontSize: 16.2.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 3.6.h),
                Text(subtitle, style: AppTextStyles.montserratSemiBold.copyWith(color: isSelected ? AppColor.background : AppColor.translucentWhite, fontSize: 12.6.sp)),
              ],
            ),
            Row(
              children: [
                Text(price, style: AppTextStyles.montserratSemiBold.copyWith(color: isSelected ? AppColor.background : AppColor.translucentWhite, fontSize: 21.6.sp, fontWeight: FontWeight.bold)),
                SizedBox(width: 10.8.w),
                Container(
                  width: 21.6.w,
                  height: 21.6.w,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? AppColor.background : AppColor.translucentWhite, width: 2)),
                  child: isSelected ? Icon(Icons.circle, color: isSelected ? AppColor.background : AppColor.translucentWhite, size: 14.4.sp) : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return GestureDetector(
      onTap: () => Get.snackbar("Link", "$text tapped"),
      child: Text(text.tr, style: AppTextStyles.montserratSemiBold.copyWith(color: Colors.grey, fontSize: 12.sp, decoration: TextDecoration.underline)),
    );
  }

  void _showPaymentBottomSheet(BuildContext context, Settingcontroller controller) {
    final paymentMethods = ['international'.tr, 'local_moncash'.tr];
    final RxString selectedMethod = paymentMethods[0].obs;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => Padding(
        padding: EdgeInsets.all(20.w),
        child: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('choose_payment_method'.tr, style: AppTextStyles.montserratSemiBold.copyWith(color: Colors.white, fontSize: 18.sp)),
            SizedBox(height: 20.h),
            ...paymentMethods.map((method) {
              bool isSelected = selectedMethod.value == method;
              return GestureDetector(
                onTap: () => selectedMethod.value = method,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(color: isSelected ? Colors.white12 : Colors.transparent, borderRadius: BorderRadius.circular(10.r)),
                  child: Row(
                    children: [
                      Container(
                        width: 18.w,
                        height: 18.w,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white)),
                        child: isSelected
                            ? Center(child: Container(width: 10.w, height: 10.w, decoration: BoxDecoration(color: AppColor.vividAmber, shape: BoxShape.circle)))
                            : null,
                      ),
                      SizedBox(width: 12.w),
                      Text(method, style: AppTextStyles.montserratSemiBold.copyWith(color: Colors.white, fontSize: 14.sp)),
                    ],
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 20.h),
            CustomButton(
              title: 'continue'.tr,
              loading: controller.isLoading.value,
              onPress: () async {
                final period = controller.selectedPlan.value == 0 ? "monthly" : "yearly";
                await controller.paySubscription(period: period, isMonCash: selectedMethod.value == 'local_moncash'.tr);
              },
              gradient: LinearGradient(colors: [Colors.orange, Colors.yellowAccent]),
              width: double.infinity,
              height: 30.h,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 15.h),
          ],
        )),
      ),
    );
  }
}