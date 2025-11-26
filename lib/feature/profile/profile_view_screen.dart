import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/sessions/sessions_controller.dart';

import '../../widgets/widgets.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  final String userId = Get.arguments['id'];
  final controller = Get.find<SessionsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAssignViewProfile(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backgroundColor: AppColors.secondaryColor),
      body: SingleChildScrollView(
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
              child: GetBuilder<SessionsController>(
                  builder: (controller) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomImageAvatar(radius: 48.r,
                            image: controller.assignViewProfileModel?.profileImage?? ''),
                        CustomText(
                          text: controller.assignViewProfileModel?.name ?? '',
                          fontSize: 18.h,
                          fontWeight: FontWeight.w500,
                          top: 4.h,
                          bottom: 8.h,
                          color: Colors.white,
                        ),
                      ],
                    );
                  }
              ),
            ),
            Center(
              child: CustomText(
                text: controller.assignViewProfileModel?.user.role ?? "",
                fontSize: 12.h,
                fontWeight: FontWeight.w500,
                top: 4.h,
                color: AppColors.appGreyColor,
              ),
            ),
            SizedBox(height: 44.h),
            GetBuilder<SessionsController>(
                builder: (controller){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListTile(title: 'Child’s Name', subtitle: controller.assignViewProfileModel?.childsName ?? ''),
                      _buildListTile(title: 'Child’s Grade', subtitle: controller.assignViewProfileModel?.childsGrade ?? ''),
                      _buildListTile(title: 'Subjects', subtitle: 'Data Dibo pore'),
                      _buildListTile(title: 'Email', subtitle: controller.assignViewProfileModel?.user.email ?? ''),
                      _buildListTile(title: 'Phone Number', subtitle: controller.assignViewProfileModel?.phoneNumber ?? ''),
                      _buildListTile(
                        title: 'Confirmed Session data dibo pore',
                        subtitle: '08/08/25 at 4:30 PM',
                      ),
                    ],
                  );
                }
            ),
            SizedBox(height: 44.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomButton(onPressed: () {}, label: 'Set Schedule'),
            ),

            SizedBox(height: 44.h),
          ],
        ),
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
  }
}
