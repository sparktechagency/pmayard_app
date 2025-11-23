import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/assigned/assigned_controller.dart';
import 'package:pmayard_app/controllers/sessions/sessions_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/feature/home/widgets/assigned_card_widget.dart';
import 'package:pmayard_app/models/assigned/assigned_professional_model_data.dart';
import 'package:pmayard_app/models/assigned/assigned_response_data.dart';
import 'package:pmayard_app/models/session/session_professional_model_data.dart';
import 'package:pmayard_app/models/session/session_response_data.dart';
import 'package:pmayard_app/widgets/widgets.dart';
import '../../custom_assets/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AssignedController _assignedController = Get.find<AssignedController>();
  final SessionsController _sessionsController = Get.find<SessionsController>();

  @override
  void initState() {
    super.initState();

    _assignedController.getAssigned();
    _sessionsController.getSessions();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      paddingSide: 0,
      appBar: CustomAppBar(
        titleWidget: GetBuilder<UserController>(
          builder: (controller) {
            final userData = controller.user;
            return CustomListTile(
              image: userData?.roleId?.profileImage,
              imageRadius: 24.r,
              contentPaddingHorizontal: 16.w,
              titleColor: Colors.white,
              title: 'Welcome!',
              titleFontSize: 12.sp,
              subTitle: userData?.roleId?.name ?? 'Enter Your Name',
              subtitleFontSize: 14.sp,
              statusColor: Colors.white,
            );
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Assets.icons.notification.svg()),
        ],
        toolbarHeight: 90.h,
        backgroundColor: AppColors.secondaryColor,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<UserController>(
          builder: (userController) {
            final role = userController.user?.role ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ===================>>>> Assigned Section <<<================== ///
                CustomText(
                  top: 24.h,
                  bottom: 24.h,
                  left: 16.w,
                  right: 16.w,
                  text: 'Assigned ${userController.user?.roleId?.name == 'parent' ? 'Professionals' : 'Parents'}',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),

                GetBuilder<AssignedController>(
                  builder: (assignedController) {
                    if (assignedController.isLoadingAssigned) {
                      return SizedBox(
                        height: 180.h,
                        child: Center(child: CustomLoader()),
                      );
                    }

                    final assignedData = role == 'professional'
                        ? assignedController.assignedProfessionalData
                        : assignedController.assignedParentData;

                    if (assignedData.isEmpty) {
                      return SizedBox(
                        height: 180.h,
                        child: Center(
                          child: CustomText(
                            text: 'No assigned ${role == 'professional' ? 'parents' : 'professionals'}',
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 180.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: assignedData.length,
                        itemBuilder: (context, index) {
                          String name = '';
                          String imageUrl = '';

                          if (role == 'professional') {
                            final item = assignedData[index] as AssignedProfessionalModelData;
                            name = item.parent?.name ?? '';
                            imageUrl = item.parent?.profileImage ?? '';
                          } else {
                            final item = assignedData[index] as AssignedParentModelData;
                            name = item.professional?.name ?? '';
                            imageUrl = item.professional?.profileImage ?? '';
                          }

                          return AssignedCardWidget(
                            index: index,
                            name: name,
                            role: role,
                            imageUrl: imageUrl,
                          );
                        },
                      ),
                    );
                  },
                ),

                /// ===================>>>> Upcoming Sessions Section <<<================== ///
                CustomText(
                  top: 24.h,
                  bottom: 10.h,
                  left: 16.w,
                  right: 16.w,
                  text: 'Upcoming Sessions',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),

                GetBuilder<SessionsController>(
                  builder: (sessionsController) {
                    if (sessionsController.isLoadingSession) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: CustomLoader(),
                        ),
                      );
                    }

                    final sessionData = role == 'professional'
                        ? sessionsController.sessionProfessionalData
                        : sessionsController.sessionParentData;

                    if (sessionData.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: CustomText(
                            text: 'No upcoming sessions',
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: sessionData.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        String name = '';
                        String imageUrl = '';
                        String? day;
                        String? date;

                        if (role == 'professional') {
                          final session = sessionData[index] as SessionProfessionalModelData;
                          name = session.parent?.name ?? 'Unknown';
                          imageUrl = session.parent?.profileImage ?? '';
                          day = session.day;
                          date = session.date;
                        } else {
                          final session = sessionData[index] as SessionParentModelData;
                          name = session.professional?.name ?? 'Unknown';
                          imageUrl = session.professional?.profileImage ?? '';
                          day = session.day;
                          date = session.date;
                        }

                        final hasDateTime = (day != null && day.isNotEmpty) &&
                            (date != null && date.isNotEmpty);

                        // Format the subtitle
                        final subtitle = hasDateTime ? '$date at $day' : 'Waiting';

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 6.h,
                          ),
                          child: CustomListTile(
                            contentPaddingVertical: 6.h,
                            borderRadius: 8.r,
                            borderColor: AppColors.borderColor,
                            image: imageUrl,
                            title: name,
                            subTitle: subtitle,
                            titleFontSize: 16.sp,
                            trailing: hasDateTime
                                ? CustomButton(
                              radius: 8.r,
                              height: 25.h,
                              fontSize: 10.sp,
                              onPressed: () {
                                // Navigate to session detail
                              },
                              label: 'View Detail',
                            )
                                : null,
                          ),
                        );
                      },
                    );
                  },
                ),

                SizedBox(height: 44.h),
              ],
            );
          },
        ),
      ),
    );
  }
}