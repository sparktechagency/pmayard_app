import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/sessions/sessions_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/custom_assets/assets.gen.dart';
import 'package:pmayard_app/models/session/my_session_parent_model.dart';
import 'package:pmayard_app/models/session/my_session_professional_model.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_container.dart';
import 'package:pmayard_app/widgets/custom_dialog.dart';
import 'package:pmayard_app/widgets/custom_list_tile.dart';
import 'package:pmayard_app/widgets/custom_loader.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';
import 'package:pmayard_app/widgets/custom_text.dart';
import 'package:table_calendar/table_calendar.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final controller = Get.find<SessionsController>();

  @override
  void initState() {
    controller.fetchMySection('');
    super.initState();
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final userRole = Get.find<UserController>().user?.role ?? '';

    return CustomScaffold(
      paddingSide: 0,
      appBar: CustomAppBar(title: 'Session'),
      body: GetBuilder<SessionsController>(
        builder: (controller) {
          return Column(
            children: [
              CustomContainer(
                color: Colors.white,
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      // controller.fetchSelectedSession(_focusedDay);
                      // controller.fetchMySection();
                    });
                  },
                  headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(fontSize: 12.sp),
                    formatButtonVisible: false,
                    titleCentered: false,
                  ),
                  calendarFormat: CalendarFormat.week,
                  availableGestures: AvailableGestures.horizontalSwipe,
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    defaultTextStyle: TextStyle(fontSize: 12.sp),
                  ),
                ),
              ),

              // Session Related work are here
              GetBuilder<SessionsController>(
                builder: (sessionController) {
                  if (sessionController.isLoadingMySection.value) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: CustomLoader(),
                      ),
                    );
                  }

                  final sessionData = userRole == 'professional'
                      ? sessionController.mySessionProfessionalData
                      : sessionController.mySessionParentData;

                  if (sessionData.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: CustomText(
                          text: 'No sessions are Available yet',
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: userRole == 'professional'
                          ? sessionController.mySessionProfessionalData.length
                          : sessionController.mySessionParentData.length,

                      itemBuilder: (context, index) {
                        String name = '';
                        String imageUrl = '';
                        String? day;
                        String? date;
                        String? status;
                        String? userID;

                        if (userRole == 'professional') {
                          final session =
                              sessionData[index]
                                  as MySessionProfessionalModelData;

                          print(
                            '=================> Maruf Profession Data $session',
                          );

                          name = session.parent?.name ?? 'Unknown';
                          imageUrl = session.parent?.profileImage ?? 'Unknown';
                          day = session.day;
                          date = session.date;
                          status = session.status;
                          userID = session.sId;
                        } else {
                          final session =
                              sessionData[index] as MySessionParentModelData;

                          print(
                            '=================> Maruf Parent Data $session',
                          );

                          name = session.professional?.name ?? 'Unknown';
                          imageUrl =
                              session.professional?.profileImage ?? 'Unknown';
                          day = session.day;
                          date = session.date;
                          status = session.status;
                          userID = session.sId;
                        }

                        final hasDateTime =
                            (day != null && day.isNotEmpty) &&
                            (date != null && date.isNotEmpty);

                        final subTitle = hasDateTime
                            ? '$date at $day'
                            : 'Waiting';

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 6.h,
                          ),
                          child: GetBuilder<SessionsController>(
                            builder: (controller) {
                              return CustomListTile(
                                contentPaddingVertical: 6.h,
                                borderRadius: 8.r,
                                borderColor: AppColors.borderColor,
                                image: imageUrl,
                                imageRadius: 24.r,
                                title: name,
                                subTitle: subTitle,
                                titleFontSize: 16.sp,
                                trailing: status == 'Confirmed'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => CustomDialog(
                                                    title:
                                                        "You sure you want to cancel the session?",
                                                    confirmButtonColor: Color(
                                                      0xffF40000,
                                                    ),
                                                    confirmButtonText: 'Yes',
                                                    onCancel: (){
                                                      Get.back();
                                                      //Get.offAllNamed(AppRoutes.loginScreen);
                                                    },
                                                    onConfirm: () => controller
                                                        .completeSessionDBHandler(
                                                      userID!,
                                                      status!,
                                                    )
                                                  ),
                                                );
                                              },

                                              child: Assets.icons.cleanIcon
                                            .svg(),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CustomDialog(
                                                  title:
                                                  "Do you want to mark this session as completed?",
                                                  confirmButtonText: 'Yes',
                                                  onCancel: () {
                                                    Get.back();
                                                    //Get.offAllNamed(AppRoutes.loginScreen);
                                                  },
                                                  onConfirm: () =>
                                                      controller
                                                          .completeSessionDBHandler(
                                                        userID!,
                                                        status!,
                                                      ),
                                                ),
                                          );
                                        },
                                        child: Assets.icons.success.svg(),
                                      ),
                                    ),
                                  ],
                                )
                                    : _buildSessionStatus(status!),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),

    );
  }

  Widget _buildSessionStatus(String status) {
    String value = status;
    Color bgColor = Color(0xFF0ABAB5);

    switch (status) {
      case 'Completed':
        value = status;
        bgColor = const Color(0xFFC2B067);
        break;

      default: // Check spelling!
        value = status;
        bgColor = const Color(0xFFF40000);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.18),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: bgColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
