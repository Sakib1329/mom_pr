import 'package:Nuweli/app/modules/settings/views/termsandcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
    controller.fetchSubscriptionPrices();
    controller.fetchSubscriptionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.7),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 21.6.w),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator(color: AppColor.vividAmber));
                }

                final bool isSubscribed = controller.isSubscribed.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 36.h),
                    Center(
                      child: Text(
                        isSubscribed ? 'your_subscription'.tr : 'choose_plan'.tr,
                        style: AppTextStyles.montserratSemiBold.copyWith(
                          color: AppColor.translucentWhite,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.8.h),

                    if (!isSubscribed) ...[
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
                    ],

                    if (isSubscribed)
                      _buildSubscribedPlanCard()
                    else ...[
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
                            onTap: () => Get.snackbar("Redeem", "Redeem code feature is temporarily unavailable. Please try again later.",backgroundColor: Colors.white),
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
                      const Spacer(),
                    ],

                    SizedBox(height: isSubscribed ? 40.h : 0.h),

                    if (isSubscribed)
                      CustomButton(
                        onPress: () async => _showCancelConfirmation(context),
                        title: 'cancel_subscription'.tr,
                        textColor: AppColor.lightSkyBlue,
                        gradient: null,
                        buttonColor: AppColor.crimsonRed,
                        borderColor: Colors.transparent,
                        width: double.infinity,
                        height: 35.h,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      )
                    else
                      CustomButton(
                        onPress: () async => _showPaymentBottomSheet(context, controller),
                        title: 'subscribe_btn'.tr,
                        textColor: Colors.black,
                        gradient: LinearGradient(
                          colors: [AppColor.vividAmber, AppColor.sunnyYellow],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        width: double.infinity,
                        height: 35.h,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),

                    SizedBox(height: 21.6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildFooterLink('privacy_policy'),
                        Text(" | ", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                        _buildFooterLink('terms_of_use'),

                      ],
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
        Icon(Icons.check_circle_outline, color: AppColor.vividAmber, size: 18.sp),
        SizedBox(width: 5.w),
        Flexible(
          child: Text(
            text.tr,
            style: AppTextStyles.montserratSemiBold.copyWith(
              color: AppColor.translucentWhite,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
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
          borderRadius: BorderRadius.circular(15.r),

          gradient: isSelected
              ? LinearGradient(
              colors: [AppColor.vividAmber, AppColor.sunnyYellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)
              : null,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white24,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.montserratSemiBold.copyWith(
                    color: isSelected ? Colors.black87 : Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: AppTextStyles.montserratSemiBold.copyWith(
                    color: isSelected ? Colors.black54 : Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  price,
                  style: AppTextStyles.montserratSemiBold.copyWith(
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 12.w),
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? Colors.black : Colors.white38,
                  size: 20.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscribedPlanCard() {
    final period = controller.subPeriod.value.toLowerCase();
    final bool isMonthly = period == 'monthly';
    final String displayPeriod = isMonthly ? 'monthly_sub'.tr : 'yearly_sub'.tr;

    String nextDate = '—';
    if (controller.nextBilling.value.isNotEmpty) {
      try {
        nextDate = controller.nextBilling.value.substring(0, 10);
      } catch (_) {}
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.vividAmber.withOpacity(0.35), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isMonthly ? "Subscription" : "Premium",
                style: AppTextStyles.montserratSemiBold.copyWith(
                  color: AppColor.vividAmber,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.green.shade700.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'active'.tr,
                  style: TextStyle(color: Colors.white, fontSize: 13.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            displayPeriod,
            style: AppTextStyles.montserratSemiBold.copyWith(
              color: AppColor.translucentWhite,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            isMonthly
                ? "\$${controller.moncashMonthly.value.toStringAsFixed(2)}"
                : "\$${controller.moncashYearly.value.toStringAsFixed(2)}",
            style: AppTextStyles.montserratSemiBold.copyWith(
              color: AppColor.vividAmber,
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                '${'next_billing'.tr}: $nextDate',
                style: AppTextStyles.montserratSemiBold.copyWith(
                  color: Colors.white70,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return GestureDetector(
      onTap: () => Get.to(Privacypolicy()),
      child: Text(
        text.tr,
        style: AppTextStyles.montserratSemiBold.copyWith(
          color: Colors.grey,
          fontSize: 12.sp,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          border: Border.all(color: Colors.white10, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 24.h),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.sentiment_dissatisfied_rounded,
                  color: Colors.redAccent, size: 42.sp),
            ),
            SizedBox(height: 20.h),
            Text(
              'confirm_cancel'.tr,
              textAlign: TextAlign.center,
              style: AppTextStyles.montserratSemiBold.copyWith(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                'cancel_subscription_message'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.montserratSemiBold.copyWith(
                  color: Colors.white70,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 32.h),
            CustomButton(
              onPress: () async => Get.back(),
              title: 'keep_subscription'.tr, // Or "Keep My Benefits"
              textColor: Colors.white,
           buttonColor: Colors.transparent,
              width: double.infinity,
              height: 35.h,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () async{
                Get.back();
              await controller.cancelCurrentSubscription();
              },
              child: Text(
                'yes_cancel'.tr,
                style: TextStyle(
                  color: Colors.redAccent.withOpacity(0.8),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
            Text(
              'choose_payment_method'.tr,
              style: AppTextStyles.montserratSemiBold.copyWith(color: Colors.white, fontSize: 18.sp),
            ),
            SizedBox(height: 20.h),
            ...paymentMethods.map((method) {
              bool isSelected = selectedMethod.value == method;
              return GestureDetector(
                onTap: () => selectedMethod.value = method,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white12 : Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? AppColor.vividAmber : Colors.white38,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        method,
                        style: AppTextStyles.montserratSemiBold.copyWith(color: Colors.white, fontSize: 14.sp),
                      ),
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
                await controller.paySubscription(
                  period: period,
                  isMonCash: selectedMethod.value == 'local_moncash'.tr,
                );
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