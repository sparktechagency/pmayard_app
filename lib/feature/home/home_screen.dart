import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AssignedController _assignedController = Get.find<AssignedController>();
  final SessionsController _sessionsController = Get.find<SessionsController>();
  final userRole = Get.find<UserController>().user?.role ?? '';

  late String formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate =DateTime.now().toIso8601String().split('T')[0];
    // formattedDate = '2026-01-16';

    if (_assignedController.assignModel.isEmpty) {
      _assignedController.getAssigned();
    }

    if (userRole == 'professional') {
      _sessionsController.getSessions();
    } else if (userRole == 'parent') {
      _sessionsController.fetchTodaySessions(formattedDate);
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
              image: '${ApiUrls.imageBaseUrl}${userData?.roleId?.profileImage!.url}',
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

          if (userRole == 'professional') {
            await _sessionsController.getSessions();
          } else if (userRole == 'parent') {
            _sessionsController.todaySessionData.clear();
            await _sessionsController.fetchTodaySessions(formattedDate);
          }
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: GetBuilder<UserController>(
            builder: (userController) {
              final role = userController.user?.role ?? '';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// =================== Assign New Professional Button ======================
                  if (role == 'parent')
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
                    builder: (controller) {
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
                    },
                  ),

                  // Assigned Cards
                  GetBuilder<AssignedController>(
                    builder: (controller) {
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
                              imageUrl = '${ApiUrls.imageBaseUrl}${parentItem?.profileImage!.url}';
                              userRole = parentItem?.user?.role ?? '';
                            } else if (role == 'parent') {
                              name = professionalItem?.name ?? '';
                              imageUrl = '${ApiUrls.imageBaseUrl}${professionalItem?.profileImage!.url}';
                              userRole = professionalItem?.user?.role ?? '';
                            }

                            return AssignedCardWidget(
                              index: index,
                              name: name,
                              role: userRole,
                              imageUrl: imageUrl,
                              sub: role == 'parent' ? item.subject : null,
                              sessionID: item.sId ?? '',
                              chatID: item.conversationId ?? '',
                            );
                          },
                        ),
                      );
                    },
                  ),

                  /// ===================>>>> Sessions Section <<<================== ///
                  CustomText(
                    top: 24.h,
                    bottom: 10.h,
                    left: 16.w,
                    right: 16.w,
                    text: role == 'professional'
                        ? 'Upcoming Sessions'
                        : 'Today\'s Schedule',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),

                  // ============= PROFESSIONAL: Upcoming Sessions =============
                  if (role == 'professional')
                    Obx(() {
                      if (_sessionsController.isLoadingSession.value) {
                        return ShimmerHelper.upcomingSessionsShimmer();
                      }

                      final sessionData = _sessionsController.upComingSessionParentList;

                      if (sessionData.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Center(
                            child: CustomText(
                              text: 'No upcoming sessions',
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: sessionData.length,
                        itemBuilder: (context, index) {
                          final session = sessionData[index];

                          String name = session.parent?.name ?? 'Unknown';
                          String imageUrl = '${ApiUrls.imageBaseUrl}${session.parent?.profileImage?.url ?? ''}';
                          String? day = session.day ?? '';
                          String? date = session.date ?? '';

                          final hasDateTime = day.isNotEmpty && date.isNotEmpty;
                          final DateTime? dateTime = date.isNotEmpty ? DateTime.tryParse(date) : null;

                          final datePart = dateTime != null
                              ? DateFormat('dd/MM/yy').format(dateTime)
                              : '';

                          final formattedTime = dateTime != null
                              ? DateFormat('h:mm a').format(dateTime)
                              : '';

                          final subtitle = hasDateTime && dateTime != null
                              ? '$datePart at $formattedTime'
                              : 'Waiting';

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
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
                                onPressed: () => showUserData(context, session, role),
                                label: 'View Detail',
                              )
                                  : null,
                            ),
                          );
                        },
                      );
                    }),

                  // ============= PARENT: Today's Schedule =============
                  // FIXED: Changed Obx to GetBuilder since isLoadingTodaySessions is not RxBool
                  if (role == 'parent')
                    GetBuilder<SessionsController>(
                      builder: (sessionController) {
                        // Show shimmer while loading
                        if (sessionController.isLoadingTodaySessions) {
                          return ShimmerHelper.upcomingSessionsShimmer();
                        }

                        final todaySessions = sessionController.todaySessionData;

                        // Show empty state
                        if (todaySessions.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: Center(
                              child: CustomText(
                                text: 'No sessions scheduled for today',
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }

                        // Display today's sessions
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: todaySessions.length,
                          itemBuilder: (context, index) {
                            final session = todaySessions[index];

                            // Extract session data
                            String professionalName = session.professional?.name ?? 'Unknown';
                            String imageUrl = '${ApiUrls.imageBaseUrl}${session.professional?.profileImage?.url ?? ''}';
                            String subject = session.subject ?? 'N/A';
                            String status = session.status ?? 'Pending';
                            String sessionId = session.sId ?? '';
                            String? date = session.date ?? '';

                            // Format time
                            String timeString = 'Waiting';
                            if (date.isNotEmpty) {
                              try {
                                final parsedDate = DateTime.parse(date);
                                final startTime = session.time?.startTime ?? '';
                                final endTime = session.time?.endTime ?? '';

                                if (startTime.isNotEmpty && endTime.isNotEmpty) {
                                  timeString = '$startTime - $endTime';
                                } else {
                                  timeString = TimeFormatHelper.timeWithAMPM(parsedDate) ?? 'Waiting';
                                }
                              } catch (e) {
                                debugPrint('Error parsing date: $e');
                              }
                            }

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 6.h,
                              ),
                              child: CustomListTile(
                                subject: subject,
                                contentPaddingVertical: 6.h,
                                borderRadius: 8.r,
                                borderColor: AppColors.borderColor,
                                image: imageUrl,
                                imageRadius: 24.r,
                                title: professionalName,
                                subTitle: timeString,
                                titleFontSize: 16.sp,
                                trailing: status == 'Confirmed'
                                    ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Cancel Button
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => CustomDialog(
                                            title: "Are you sure you want to cancel this session?",
                                            confirmButtonColor: const Color(0xffF40000),
                                            confirmButtonText: 'Yes, Cancel',
                                            onCancel: () => Get.back(),
                                            onConfirm: () {
                                              _sessionsController.completeSessionDBHandler(
                                                sessionId,
                                                'Canceled',
                                              );
                                              Get.back();
                                            },
                                          ),
                                        );
                                      },
                                      child: Assets.icons.cleanIcon.svg(),
                                    ),
                                    SizedBox(width: 12.w),
                                    // Complete Button
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => CustomDialog(
                                            title: "Do you want to mark this session as completed?",
                                            confirmButtonText: 'Yes, Complete',
                                            onCancel: () => Get.back(),
                                            onConfirm: () {
                                              _sessionsController.completeSessionDBHandler(
                                                sessionId,
                                                'Completed',
                                              );
                                              Get.back();
                                            },
                                          ),
                                        );
                                      },
                                      child: Assets.icons.success.svg(),
                                    ),
                                  ],
                                )
                                    : _buildSessionStatus(status),
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
      ),
    );
  }

  /// Build Session Status Badge
  Widget _buildSessionStatus(String status) {
    String value = status;
    Color bgColor = Color(0xFF0ABAB5);

    switch (status) {
      case 'Completed':
        value = 'Completed';
        bgColor = const Color(0xFFC2B067);
        break;
      case 'Canceled':
      case 'Cancelled':
        value = 'Cancelled';
        bgColor = const Color(0xFFF40000);
        break;
      case 'Pending':
        value = 'Pending';
        bgColor = const Color(0xFF0ABAB5);
        break;
      default:
        value = status;
        bgColor = const Color(0xFF0ABAB5);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.18),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: bgColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}