import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/auth/auth_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/feature/profile/widgets/profile_list_tile.dart';
import 'package:pmayard_app/services/api_urls.dart';

import '../../custom_assets/assets.gen.dart';
import '../../routes/app_routes.dart';
import '../../widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<UserController>(
          builder: (controller) {
            final userData = controller.user;
            final userDataRole = controller.user?.roleId;
            return Column(
              children: [
                CustomContainer(
                  alignment: Alignment.bottomCenter,
                  bottomLeft: 70.r,
                  bottomRight: 70.r,
                  height: 257.h,
                  width: double.infinity,
                  color: AppColors.secondaryColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      userDataRole?.profileImage != null
                          ? CustomNetworkImage(
                              imageUrl: '${ApiUrls.imageBaseUrl}${userDataRole?.profileImage!.url}' ?? '',
                              height: 80.h,
                              width: 80.w,
                              borderRadius: 44.r,
                            )
                          : CustomImageAvatar(radius: 44.r, image: ''),
                      CustomText(
                        text: userDataRole?.name.toString() ?? 'Enter Your Name',
                        fontSize: 18.h,
                        fontWeight: FontWeight.w500,
                        top: 4.h,
                        bottom: 8.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(userData?.role ?? '', style: TextStyle(
                      fontSize: 12.sp,

                    ),)
                  ],
                ),
                SizedBox(height: 20.h),
                // List of Options
                ProfileListTile(
                  icon: Assets.icons.profile.svg(),
                  title: Get.find<UserController>().user?.role == 'parent'  ? 'General Information' : "Personal Info",
                  onTap: () {
                    Get.toNamed(AppRoutes.personalInfoScreen);
                  },
                ),
                if(controller.user?.role == 'professional')...[
                  ProfileListTile(
                    icon: Assets.icons.date.svg(),
                    title: "Edit Schedule",
                    onTap: () {
                      Get.toNamed(AppRoutes.editScheduleScreen);
                    },
                  ),
                  ProfileListTile(
                    icon: Assets.icons.terms.svg(),
                    title: "Resources",
                    onTap: () {
                      Get.toNamed(AppRoutes.resourcesScreen);
                    },
                  ),
                  ProfileListTile(
                    icon: Assets.icons.date.svg(),
                    title: "Calender",
                    onTap: () {
                      Get.toNamed(AppRoutes.calenderScreen);
                    },
                  ),
                ],

                ProfileListTile(
                  icon: Assets.icons.setting.svg(),
                  title: "Settings",
                  onTap: () {
                    Get.toNamed(AppRoutes.settingScreen);
                  },
                ),

                // Log Out Button
                ProfileListTile(
                  icon: Assets.icons.logout.svg(),
                  title: "log out",
                  noIcon: true,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        title: "Do you want to log out your profile?",
                        onCancel: () {
                          Get.back();
                        },
                        // onConfirm: () {
                        //   //Get.offAllNamed(AppRoutes.loginScreen);
                        // },
                        onConfirm: () => Get.find<AuthController>().logOut(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
