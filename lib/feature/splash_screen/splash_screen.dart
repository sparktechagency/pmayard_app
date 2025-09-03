import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/feature/splash_screen/widgets/splash_loading.dart';
import '../../custom_assets/assets.gen.dart';
import '../../widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  void _goNextScreen() {
    Future.delayed(const Duration(seconds: 2), () async {

    });
  }

  @override
  void initState() {
   //_goNextScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Stack(
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
      ),
    );
  }
}
