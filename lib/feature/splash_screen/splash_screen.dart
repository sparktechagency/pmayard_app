import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/prefs_helper.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/app/utils/app_constants.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/feature/splash_screen/widgets/splash_loading.dart';
import 'package:pmayard_app/routes/app_routes.dart';

import '../../custom_assets/assets.gen.dart';
import '../../widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _goNextScreen() async {
    final accessToken = await PrefsHelper.getString(AppConstants.bearerToken);
    final role = await PrefsHelper.getString(AppConstants.role);
    final completed = await PrefsHelper.getBool(AppConstants.completed);

    Future.delayed(const Duration(seconds: 2), () {
      if (accessToken.isEmpty) {
        Get.offAllNamed(AppRoutes.onboardingScreen);
        return;
      }

      if (completed == false) {
        if (role == 'parent') {
          Get.toNamed(AppRoutes.completeProfileParent);
        } else {
          Get.toNamed(AppRoutes.completeProfileProfessional);
        }
        return;
      }

      // Otherwise, go to main app
      Get.offAllNamed(AppRoutes.customBottomNavBar);
    });
  }
  // void _goNextScreen() async {
  //   Future.delayed(const Duration(seconds: 2), () {
  //       Get.offAllNamed(AppRoutes.completeProfileParent);
  //   });
  // }

  @override
  void initState() {
   _goNextScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(child: Assets.icons.splashLogo.svg(width: 149.w, height: 149.h)),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Assets.images.splashBottom.image(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomContainer(
              height: 278.h,
              width: double.infinity,
              linearColors: AppColors.splashLinearColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

          Positioned(
            bottom: 70.h,
            left: 0,
            right: 0,
            child: Center(
              child: const SemiCircleLoader(),
            ),
          ),

        ],
      ),
    );
  }
}
