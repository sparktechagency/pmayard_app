import 'package:flutter/cupertino.dart';
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
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/widgets/widgets.dart';
import '../../custom_assets/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final  controller = Get.find<UserController>();
  final AssignedController _assignedController = Get.find<AssignedController>();
  final SessionsController _sessionsController = Get.find<SessionsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _assignedController.getAssigned();
      _sessionsController.getSessions();
    });
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
          await _sessionsController.getSessions();
          await _assignedController.getAssigned();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
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
                    text:
                        'Assigned ${userController.user?.roleId?.name == 'parent' ? 'Professionals' : 'Parents'}',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),

                  Obx(() {
                    final assignedController = Get.find<AssignedController>();
                    if (assignedController.isLoadingAssigned.value) {
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
                            text:
                                'No assigned ${role == 'professional' ? 'parents' : 'professionals'}',
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
                          String id;
                          String chatId;
                          String scheduleUserID;

                          if (role == 'professional') {
                            final item =
                                assignedData[index]
                                    as AssignedProfessionalModelData;
                            name = item.parent?.name ?? '';
                            imageUrl = item.parent?.profileImage ?? '';
                            id = item.parent?.sId ?? '';
                            chatId = item.conversationId ?? '';
                            scheduleUserID = item.professional ?? '';
                          } else {
                            final item =
                                assignedData[index]
                                    as AssignedParentModelData;
                            name = item.professional?.name ?? '';
                            imageUrl = item.professional?.profileImage ?? '';
                            id = item.professional?.sId ?? '';
                            chatId = item.conversationId ?? '';
                            scheduleUserID = '';
                          }
                          return AssignedCardWidget(
                            chatId: chatId,
                            id: id,
                            index: index,
                            name: name,
                            role: role,
                            imageUrl: imageUrl,
                            scheduleUserID: scheduleUserID,
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
                    final sessionsController = Get.find<SessionsController>();
                    if (sessionsController.isLoadingSession.value) {
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
                        final session = sessionData[index];

                        String name = '';
                        String imageUrl = '';
                        String? day;
                        String? date;
                        if (role == 'professional') {
                          final session =
                              sessionData[index]
                                  as SessionProfessionalModelData;

                          name = session.parent?.name ?? 'Unknown';
                          imageUrl = session.parent?.profileImage ?? '';
                          day = session.day;
                          date = session.date;
                        } else {
                          final session =
                              sessionData[index] as SessionParentModelData;
                          name = session.professional?.name ?? 'Unknown';
                          imageUrl = session.professional?.profileImage ?? '';
                          day = session.day;
                          date = session.date;
                        }

                        final hasDateTime =
                            (day != null && day.isNotEmpty) &&
                            (date != null && date.isNotEmpty);

                        // Format the subtitle
                        final subtitle = hasDateTime
                            ? '$date at $day'
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
                                    onPressed: () => showUserData(session),
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

  // Show User Data via Model
  void showUserData(dynamic sessionData) {
    String name = '';
    String imageUrl = '';
    String? day;
    String? date;
    String? role = '';
    String? subject;
    if (sessionData is SessionProfessionalModelData) {
      name = sessionData.parent?.name ?? 'Unknown';
      imageUrl = sessionData.parent?.profileImage ?? '';
      day = sessionData.day;
      date = sessionData.date;
      role = 'Professional';
      subject = sessionData.subject;
    } else if (sessionData is SessionParentModelData) {
      name = sessionData.professional?.name ?? 'Unknown';
      imageUrl = sessionData.professional?.profileImage ?? '';
      day = sessionData.day;
      date = sessionData.date;
      role = 'Parent';
      subject = sessionData.subject;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'View Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              if (imageUrl.isNotEmpty)
                Center(
                  child: CircleAvatar(
                    radius: 30.r,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                ),

              SizedBox(height: 16.h),
              Text(
                '$role Name',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              // Name
              Text(name, style: TextStyle(fontSize: 14)),

              SizedBox(height: 16.h),
              Text(
                'Subjects',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text('$subject'),

              SizedBox(height: 16.h),
              Text(
                'Session Time',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              if (day != null && date != null) Text('$date at $day'),

              SizedBox(height: 16.h),

              // Close button
              CustomButton(
                onPressed: () => Navigator.pop(context),
                title: Text(
                  'Close',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
