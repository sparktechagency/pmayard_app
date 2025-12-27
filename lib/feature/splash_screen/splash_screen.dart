import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/prefs_helper.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/app/utils/app_constants.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/feature/bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';
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
  @override
  void initState() {
    super.initState();
    _goNextScreen();
  }

  void _goNextScreen() async {
    // Get access token first
    final accessToken = await PrefsHelper.getString(AppConstants.bearerToken);

    // Wait for splash screen duration
    await Future.delayed(const Duration(seconds: 2));

    // If no token, go to onboarding
    if (accessToken.isEmpty) {
      Get.offAllNamed(AppRoutes.onboardingScreen);
      return;
    }

    try {
      final userController = Get.find<UserController>();
      await userController.userData();
      final user = userController.user;

      // If user data is still null after API call, go to login
      if (user == null) {
        Get.offAllNamed(AppRoutes.loginScreen);
        return;
      }

      // Check if user is not verified
      if (user.isVerified == false) {
        Get.offAllNamed(AppRoutes.loginScreen);
        return;
      }

      // Check if profile is incomplete
      if ((user.roleId == null || user.roleId?.toString().isEmpty == true)) {
        if (user.role == 'professional') {
          Get.offAllNamed(AppRoutes.completeProfileProfessional);
        } else if (user.role == 'parent') {
          Get.offAllNamed(AppRoutes.completeProfileParent);
        } else {
          Get.offAllNamed(AppRoutes.onboardingScreen);
        }
        return;
      }

      // User is verified and profile is complete
      if (user.roleId != null) {
        Get.offAllNamed(AppRoutes.customBottomNavBar);
        Get.find<CustomBottomNavBarController>().onChange(0);
        return;
      }
      Get.offAllNamed(AppRoutes.customBottomNavBar);
    } catch (e) {
      debugPrint('Error in splash screen: $e');
      Get.offAllNamed(AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Assets.icons.splashLogo.svg(width: 149.w, height: 149.h),
          ),
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
            child: Center(child: const SemiCircleLoader()),
          ),
        ],
      ),
    );
  }
}
