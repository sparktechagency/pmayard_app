import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../widgets/widgets.dart';
import '../widgets/profile_list_tile.dart';


class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(title:Text("Settings")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          children: [
            ProfileListTile(
              icon: const Icon(Icons.lock,color: Colors.white),
              title: "Change Password",
              onTap: () {
                //Get.toNamed(AppRoutes.changePassword);
              },
            ),
            ProfileListTile(
              icon: const Icon(Icons.lock,color: Colors.white),
              title: "Terms & Conditions",
              onTap: () {
               // Get.toNamed(AppRoutes.termsScreen);
              },
            ),
            ProfileListTile(
              icon: const Icon(Icons.lock,color: Colors.white),
              title: "Privacy Policy",
              onTap: () {
               // Get.toNamed(AppRoutes.privacyPolicyScreen);
              },
            ),
          ProfileListTile(
            icon: const Icon(Icons.lock,color: Colors.white),
              title: "About Us",
              onTap: () {
               // Get.toNamed(AppRoutes.aboutScreen);
              },
            ),

            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child: ProfileListTile(
                icon: const Icon(Icons.delete_outline,color: Colors.red),
                  title: 'Delete Account',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        title: "Do you want to delete your account?",
                        confirmButtonText: 'Delete',
                        onCancel: () {
                          Get.back();
                        },
                        onConfirm: () {
                          //Get.offAllNamed(AppRoutes.signUpScreen);
                        },
                      ),
                    );
                  },
                  noIcon: true,
                  color: Colors.red.withOpacity(0.2),
                  textColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}