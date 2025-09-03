import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/feature/profile/widgets/profile_list_tile.dart';
import '../../widgets/widgets.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(title: Text('My Profile',)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Center(
              child: Column(
                children: [
                  // Profile Picture with Outer Border and Shadow
                  CustomImageAvatar(
                    radius: 50.r,
                    image: '',
                  ),
                  SizedBox(height: 16.h),
                  CustomText(text: "Rakibul Hasan", fontSize: 18.h,fontWeight: FontWeight.w500,),
                  CustomText(text: "rakibul@example.com", fontSize: 12.h),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // List of Options
            ProfileListTile(
              icon: Icon(Icons.abc),
              title: "Edit Profile",
              onTap: () {
             //   Get.toNamed(AppRoutes.editProfile);
              },
            ),
            ProfileListTile(
              icon: Icon(Icons.abc),
              title: "Settings",
              onTap: () {
               // Get.toNamed(AppRoutes.settingScreen);
              },
            ),
            ProfileListTile(
              icon: Icon(Icons.abc),
              title: "Contact with couch",
              onTap: () {
               // Get.toNamed(AppRoutes.contactCouchScreen);
              },
            ), ProfileListTile(
              icon: Icon(Icons.abc),
              title: "Admin Support",
              onTap: () {
               // Get.toNamed(AppRoutes.adminSupportScreen);
              },
            ),

            SizedBox(height: 44.h),

            // Log Out Button
            ProfileListTile(
              icon: Icon(Icons.abc),
              textColor: Colors.white,
              title: "Log Out",
              color: Colors.red,
              noIcon: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    title: "Do you want to log out your profile?",
                    onCancel: () {
                      Get.back();
                    },
                    onConfirm: () {
                      //Get.offAllNamed(AppRoutes.loginScreen);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}