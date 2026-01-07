import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/simmer_helper.dart';
import 'package:pmayard_app/app/helpers/time_format.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/assigned/assigned_controller.dart';
import 'package:pmayard_app/controllers/sessions/sessions_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/custom_assets/assets.gen.dart';
import 'package:pmayard_app/feature/home/widgets/assign_professional_popup_modal.dart';
import 'package:pmayard_app/feature/home/widgets/assigned_card_widget.dart';
import 'package:pmayard_app/feature/home/widgets/showUserDataPopUpModal.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/widgets/widgets.dart';

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
    if (_assignedController.assignModel.isEmpty) {
      _assignedController.getAssigned();
      _sessionsController.getSessions();
    }
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
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.notificationScreen),
            icon: Assets.icons.notification.svg(),
          ),
        ],
        toolbarHeight: 90.h,
        backgroundColor: AppColors.secondaryColor,
      ),
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: () async {
          await _assignedController.getAssigned();
          await _sessionsController.getSessions();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: GetBuilder<UserController>(
            builder: (userController) {
              final role = userController.user?.role ?? '';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// =================== Assign New Professional Button are here ======================
                  if(role == 'parent')
                      Padding(
                          padding: EdgeInsets.only(
                            top: 30.h,
                            left: 25.h,
                            right: 25.h,
                            bottom: 10.h,
                          ),
                          child: CustomButton(
                            width: double.maxFinite,
                            height: 52.h,
                            fontSize: 10.sp,
                            backgroundColor: AppColors.primaryColor,
                            onPressed: () => assignProfessionalPopupModal(context),
                            title: Text(
                              'Assign New Professional',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0XFF0D0D0D),
                              ),
                            ),
                          ),
                        ),

                  /// ===================>>>> Assigned Section <<<================== ///
                  GetBuilder<UserController>(
                      builder: (controller){
                        return CustomText(
                          top: 24.h,
                          bottom: 24.h,
                          left: 16.w,
                          right: 16.w,
                          text:
                          'Assigned ${controller.user?.role == 'professional' ? 'Parents' : 'Professionals'}',
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        );
                      }
                  ),

                  // Assign Related Work
                  GetBuilder<AssignedController>(builder: (controller) {
                    if (_assignedController.isLoadingAssigned) {
                      return SizedBox(
                        height: 180.h,
                        child: ShimmerHelper.assignedCardsShimmer(),
                      );
                    }

                    final assignedList = _assignedController.assignModel;

                    if (assignedList.isEmpty) {
                      return SizedBox(
                        height: 180.h,
                        child: Center(
                          child: CustomText(
                            text:
                                'No assigned ${role == 'professional' ? 'parents' : 'professionals'}',
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 198.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: assignedList.length,
                        itemBuilder: (context, index) {
                          final item = assignedList[index];
                          final professionalItem = assignedList[index].professional;
                          final parentItem = assignedList[index].parent;

                          String name = '';
                          String imageUrl = '';
                          String userRole = '';

                          if (role == 'professional') {
                            name = parentItem?.name ?? '';
                            imageUrl = parentItem?.profileImage ?? '';
                            userRole = parentItem?.user?.role ?? '';
                          } else if (role == 'parent') {
                            name = professionalItem?.name ?? '';
                            imageUrl = professionalItem?.profileImage ?? '';
                            userRole = professionalItem?.user?.role ?? '';
                          }

                          return AssignedCardWidget(
                            index: index,
                            name: name,
                            role: userRole,
                            imageUrl: imageUrl,
                            sub: role == 'parent' ? item.subject : null,
                            sessionID: item.sId ?? '', chatID: item.conversationId ?? '',
                          );
                        },
                      ),
                    );
                  }),

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
                  Obx(() {
                    if (_sessionsController.isLoadingSession.value) {
                      return ShimmerHelper.upcomingSessionsShimmer();
                    }
                    final sessionData = role == 'professional'
                        ? _sessionsController.upComingSessionParentList
                        : _sessionsController.upComingSessionProfessionalList;

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

                        final session = sessionData[index];

                        if (role == 'professional') {
                          final session = sessionData[index];
                          name = session.parent?.name ?? 'Unknown';
                          imageUrl = session.parent?.profileImage ?? '';
                          day = session.day ?? '';
                          date = session.date ?? '';
                        } else {
                          final session = sessionData[index];
                          name = session.professional?.name ?? 'Unknown';
                          imageUrl = session.professional?.profileImage ?? '';
                          day = session.day ?? '';
                          date = session.date ?? '';
                        }
                        final hasDateTime =
                            (day.isNotEmpty) && (date.isNotEmpty);

                        // Format the subtitle
                        final subtitle = hasDateTime
                            ? '${TimeFormatHelper.formatDate(DateTime.parse(date))} at $day'
                            : 'Waiting';

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
                                    onPressed: () =>
                                        showUserData(context, session, role),
                                    label: 'View Detail',
                                  )
                                : null,
                          ),
                        );
                      },
                    );
                  }),
                  SizedBox(height: 44.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
