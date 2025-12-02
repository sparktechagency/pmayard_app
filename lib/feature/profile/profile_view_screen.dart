import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/sessions/sessions_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/routes/app_routes.dart';

import '../../widgets/widgets.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  final controller = Get.find<SessionsController>();
  final userController = Get.find<UserController>();

  String userId = '';
  String scheduleID = '';

  @override
  void initState() {
    super.initState();

    // Get arguments
    var argument = Get.arguments;
    if (argument != null) {
      userId = argument["id"] ?? '';
      scheduleID = argument["scheduleUserID"] ?? '';
    }

    // Fetch data after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userId.isNotEmpty) {
        controller.fetchAssignViewProfile(userId);
      }
    });

    if (userController.user == null) {
      userController.userData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backgroundColor: AppColors.secondaryColor),
      body: GetBuilder<SessionsController>(
        builder: (controller) {
          if (controller.isLoadingAssignViewProfile.value) {
            return Center(child: CustomLoader());
          }

          final profile = controller.assignViewProfileModel;

          if (profile == null) {
            return Center(
              child: CustomText(
                text: 'No profile data available',
                fontSize: 14.sp,
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer(
                  alignment: Alignment.bottomCenter,
                  bottomLeft: 70.r,
                  bottomRight: 70.r,
                  height: 150.h,
                  width: double.infinity,
                  color: AppColors.secondaryColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomImageAvatar(
                        radius: 48.r,
                        image: profile.profileImage,
                      ),
                      CustomText(
                        text: profile.name,
                        fontSize: 18.h,
                        fontWeight: FontWeight.w500,
                        top: 4.h,
                        bottom: 8.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: CustomText(
                    text: profile.user.role,
                    fontSize: 12.h,
                    fontWeight: FontWeight.w500,
                    top: 4.h,
                    color: AppColors.appGreyColor,
                  ),
                ),
                SizedBox(height: 44.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildListTile(
                      title: "Child's Name",
                    subtitle: profile.childsName.isNotEmpty
                      ? profile.childsName
                      : 'Not provided',
                    ),
                    _buildListTile(
                      title: "Child's Grade",
                    subtitle: profile.childsGrade.isNotEmpty
                      ? profile.childsGrade
                      : 'Not provided',
                    ),
                    _buildListTile(
                      title: 'Subjects',
                      subtitle: 'Data will be added later',
                    ),
                    _buildListTile(
                      title: 'Email',
                      subtitle: profile.user.email,
                    ),
                    _buildListTile(
                      title: 'Phone Number',
                      subtitle: profile.phoneNumber.isNotEmpty
                          ? profile.phoneNumber
                          : 'Not provided',
                    ),
                    _buildListTile(
                      title: 'Confirmed Session',
                      subtitle: 'Session data will be added later',
                    ),
                  ],
                ),
                SizedBox(height: 44.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CustomButton(
                    onPressed: () => Get.toNamed(
                      AppRoutes.setScheduleScreen,
                      arguments: {'scheduleID': scheduleID},
                    ),
                    label: 'Set Schedule',
                  ),
                ),
                SizedBox(height: 44.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildListTile({required String title, required String subtitle}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 16.h,
            fontWeight: FontWeight.w600,
            top: 4.h,
            color: Color(0xff333333),
          ),
          CustomText(
            text: subtitle,
            fontSize: 12.h,
            fontWeight: FontWeight.w500,
            top: 4.h,
            color: AppColors.appGreyColor,
            bottom: 8.h,
          ),
        ],
      ),
    );
  }}
