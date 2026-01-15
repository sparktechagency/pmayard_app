import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/simmer_helper.dart';
import 'package:pmayard_app/app/helpers/time_format.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/sessions/sessions_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/services/api_urls.dart';

import '../../widgets/widgets.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {

  final String sessionID = Get.arguments as String;

  final controller = Get.find<SessionsController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchAssignViewProfile(sessionID);
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(backgroundColor: AppColors.secondaryColor),
      body: GetBuilder<SessionsController>(
        builder: (controller) {
          if (controller.isLoadingAssignViewProfile) {
            return ShimmerHelper.profileViewShimmer();
          }
          final profile = controller.assignViewProfileData;
          final parentProfile = controller.assignViewProfileData?.parent;
          final professionalProfile = controller.assignViewProfileData?.professional;


          String name = '';
          String imageUrl = '';
          String userRole = '';

          if (Get.find<UserController>().user?.role == 'professional') {
            name = parentProfile?.name ?? '';
            imageUrl = '${ApiUrls.imageBaseUrl}${parentProfile?.profileImage!.url}';
            userRole =  'parent';
          } else if (Get.find<UserController>().user?.role == 'parent') {
            name = professionalProfile?.name ?? '';
            imageUrl = '${ApiUrls.imageBaseUrl}${professionalProfile?.profileImage!.url}';
            userRole = 'professional';
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
                        image: imageUrl,
                      ),
                      CustomText(
                        text: name,
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
                    text: userRole,
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
                    if(Get.find<UserController>().user?.role == 'professional')...[
                      _buildListTile(
                        title: "Child's Name",
                        subtitle: parentProfile?.childsName ?? ''
                      ),
                      _buildListTile(
                        title: "Child's Grade",
                        subtitle: parentProfile?.childsGrade ?? '',
                      ),

                      _buildListTile(
                        title: 'Subjects',
                        subtitle: profile?.subject ?? '',
                      ),
                      _buildListTile(
                        title: 'Phone Number',
                        subtitle: parentProfile?.phoneNumber ?? '',
                      ),
                      _buildListTile(
                        title: 'Confirmed Session',
                        subtitle: TimeFormatHelper.formatCustom(DateTime.parse(profile?.date ?? DateTime.now().toString())) ,
                      ),
                    ],
                    if(Get.find<UserController>().user?.role == 'parent')...[

                      _buildListTile(
                        title: 'Subjects',
                        subtitle: profile?.subject ?? '',
                      ),
                      _buildListTile(
                        title: 'Bio',
                        subtitle: professionalProfile?.bio ?? '',
                      ),

                    ],


                  ],
                ),

              ],
            ),
          );
        },
      ),

      bottomNavigationBar: GetBuilder<SessionsController>(
        builder: (controller) {
          final profile = controller.assignViewProfileData;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
              if(Get.find<UserController>().user?.role == 'parent')...[
                CustomButton(
                  onPressed: () => Get.toNamed(
                    AppRoutes.setScheduleScreen,
                    arguments: profile,
                  ),
                  label: 'View Availability',
                ),
                SizedBox(height: 10.h),
                CustomButton(

                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.black,
                  onPressed: () =>   Get.toNamed(
                    AppRoutes.inboxScreen,
                    arguments: {'chatId': profile?.conversationId ?? ''},
                  ),
                  label: 'Send Message',
                ),
              ]else

              CustomButton(
                onPressed: () => Get.toNamed(
                  AppRoutes.setScheduleScreen,
                  arguments: profile,
                ),
                    label: 'Set Schedule',
                  ),
                ],
              ),
            ),
          );
        }
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
