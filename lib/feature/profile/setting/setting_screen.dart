import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/auth/auth_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/routes/app_routes.dart';

import '../../../custom_assets/assets.gen.dart';
import '../../../widgets/widgets.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        borderColor: AppColors.secondaryColor,
      ),
      body: Column(
        children: [
          SizedBox(height: 32.h),

          _buildSettingTile(
            icon: Assets.icons.password.svg(),
            label: 'Change Password',
            onTap: () {
              Get.toNamed(AppRoutes.changePassScreen);
            },
          ),

          _buildSettingTile(
            icon: Assets.icons.terms.svg(),
            label: 'Terms & Condition',
            onTap: () {
              Get.toNamed(AppRoutes.legalScreen,arguments: {'title': 'Terms & Condition'});
            },
          ),

          _buildSettingTile(
            icon: Assets.icons.policy.svg(),
            label: 'Privacy Policy',
            onTap: () {
              Get.toNamed(AppRoutes.legalScreen,arguments: {'title': 'Privacy Policy'});
            },
          ),
          _buildSettingTile(
            icon: Assets.icons.about.svg(),
            label: 'About Us',
            onTap: () {
              Get.toNamed(AppRoutes.legalScreen, arguments: {'title': 'About Us'});
            },
          ),

          GetBuilder<AuthController>(
              builder: (controller){
                return _buildSettingTile(
                  icon: Assets.icons.delete.svg(),
                  label: 'Delete Account',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        title: "Do you want to delete your account?",
                        confirmButtonText: 'Delete',
                        confirmButtonColor: AppColors.errorColor,
                        onCancel: () {
                          Get.back();
                        },
                        onConfirm: () {
                          controller.deleteUser(Get.find<UserController>().user?.sId ?? '');
                          // Get.offAllNamed(AppRoutes.signUpScreen);
                        },
                      ),
                    );
                  },
                );
              }
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return CustomContainer(
      onTap: onTap,
      marginBottom: 16.h,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: Offset(0, 6),
          blurRadius: 4,
        ),

        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: Offset(0, -1),
          blurRadius: 8,
        ),
      ],
      radiusAll: 8.r,
      paddingHorizontal: 10.h,
      paddingVertical: 14.h,
      color: Colors.white,
      child: Row(
        children: [
          icon,
          SizedBox(width: 10.w),
          Expanded(
            child: CustomText(
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.start,
              text: label,
            ),
          ),
          Icon(Icons.arrow_right_sharp),
        ],
      ),
    );
  }
}
