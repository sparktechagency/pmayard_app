import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/helper_data.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/custom_assets/assets.gen.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_button.dart';
import 'package:pmayard_app/widgets/custom_container.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';
import 'package:pmayard_app/widgets/custom_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _pageController = PageController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      paddingSide: 0,
      appBar: CustomAppBar(
        actions: [
          TextButton(onPressed: (){
            Get.offAllNamed(AppRoutes.loginScreen);
          }, child: CustomText(text: 'Skip',fontWeight: FontWeight.w500,color: AppColors.secondaryColor,),)
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            physics: const ClampingScrollPhysics(),
            controller: _pageController,
            itemCount: HelperData.onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final data = HelperData.onboardingData[index];
            return Column(
             children: [
                SizedBox(height: 44.h),
                data['image'],
                CustomText(
                  right: 24.w,
                  left: 24.w,
                  top: 32.h,
                    text: data['title'],fontSize: 20.sp,fontWeight: FontWeight.w600,color: AppColors.secondaryColor),
                CustomText(
                    right: 30.w,
                    left: 30.w,
                  top: 16.h,
                    text: data['subtitle']),
              ],
            );
          },),

          Positioned(
            bottom: 44.h,
            left: 24.w,
            right: 24.w,
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: HelperData.onboardingData.length,
                    effect:  ExpandingDotsEffect(
                      dotColor: AppColors.grayShade100,
                      activeDotColor: AppColors.secondaryColor,
                      dotHeight: 8.h,
                      dotWidth: 8.w,
                    ),
                  ),

                  if(!(currentIndex == HelperData.onboardingData.length - 1))
                    CustomContainer(
                    onTap: (){
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                    },
                    paddingAll: 14.r,
                    shape: BoxShape.circle,
                    color: AppColors.secondaryColor,
                    child: Assets.icons.arrowOnboarding.svg(),
                  ),

                  if(currentIndex == HelperData.onboardingData.length - 1)
                  CustomButton(
                    width: 160.w,
                    //height: 60.h,
                    radius: 100.r,
                    onPressed: (){
                      Get.offAllNamed(AppRoutes.loginScreen);

                    },label: '   Get Started',suffixIcon: CustomContainer(
                    paddingAll: 10.r,
                    shape: BoxShape.circle,
                    color: Colors.white,
                    child: Assets.icons.arrowOnboarding.svg(color: AppColors.secondaryColor,height: 16.h),
                  ),
                      )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
