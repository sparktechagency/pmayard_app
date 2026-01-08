import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/custom_assets/assets.gen.dart';
import 'package:pmayard_app/feature/five_zero_screen.dart';
import 'package:pmayard_app/widgets/widgets.dart';

class NoInterNetScreen extends StatelessWidget {
  final bool? isToast;
  final bool? isAppBar;
  final Widget child;

  const NoInterNetScreen({
    super.key,
    required this.child,
    this.isToast = false,
    this.isAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final ConnectivityService connectivityService = Get.put(
      ConnectivityService(),
    );
    return Stack(
      children: [
        Obx(() {
          if (!connectivityService.isConnected.value) {
            return isToast == false
                ? Container(
                    color: AppColors.grayShade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 30.h),
                        Padding(
                          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                          child: Column(
                            children: [
                              Assets.lotties.noInternet.lottie(),
                              Text(
                                "Oops!",
                                style: TextStyle(
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.w800,
                                  foreground: Paint()
                                    ..shader =
                                        const LinearGradient(
                                          colors: [
                                            Colors.red,
                                            Colors.redAccent,
                                            Colors.deepOrange,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ).createShader(
                                          Rect.fromLTWH(0, 0, 200, 70),
                                        ),
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2.w, 2.h),
                                      blurRadius: 1,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    Shadow(
                                      offset: Offset(4.w, 4.h),
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                    Shadow(
                                      offset: Offset(6.w, 6.h),
                                      blurRadius: 3,
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomText(
                          text:
                              "There was some problem, Check your connection and try again",
                          maxline: 3,
                          left: 30.w,
                          right: 30.w,
                          fontWeight: FontWeight.w700,
                          fontsize: 18.sp,
                        ),
                      ],
                    ),
                  )
                : Positioned(
                    top: isAppBar == true ? 50 : -5,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22.w,
                        vertical: 6.h,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.red,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.wifi_off, color: Colors.white),
                              SizedBox(width: 8.w),
                              const Text(
                                'No Internet Connection',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
          }
          else {
            return child;
          }
        }),
      ],
    );
  }
}

class ConnectivityService extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;

  ConnectivityService() {
    _initializeConnectivity();
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateConnectionStatus(results);
    });
  }

  Future<void> _initializeConnectivity() async {
    final List<ConnectivityResult> statuses = await _connectivity
        .checkConnectivity();
    _updateConnectionStatus(statuses);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    isConnected.value = !results.every(
      (result) => result == ConnectivityResult.none,
    );
  }
}
