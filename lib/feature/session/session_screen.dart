import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/simmer_helper.dart';
import 'package:pmayard_app/app/helpers/time_format.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/sessions/sessions_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/custom_assets/assets.gen.dart';
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

    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchMySection('');
      },
      child: CustomScaffold(
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

                      String stringDate = selectedDay.toIso8601String().split(
                        'T',
                      )[0];
                      controller.onHandle(stringDate);

                      print('=============> String Dtate $stringDate');

                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        // You can implement date filtering here if needed
                        // String formattedDate = "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";
                        // controller.fetchMySection(formattedDate);
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
                      return ShimmerHelper.upcomingSessionsShimmer();
                    }

                    if (sessionController.mySessionData.isEmpty) {
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
                        itemCount: sessionController.mySessionData.length,
                        itemBuilder: (context, index) {
                          final session = sessionController.mySessionData[index];

                          // Extract data based on user role
                          String name = '';
                          String imageUrl = '';

                          if (userRole == 'professional') {
                            final parentData = session['parent'];
                            if (parentData is Map<String, dynamic>) {
                              name = parentData['name']?.toString() ?? 'Unknown';
                              imageUrl = parentData['profileImage']?.toString() ?? '';
                            } else if (parentData is String) {
                              name = 'Parent';
                              imageUrl = '';
                            }
                          } else {
                            // For parent role
                            final professionalData = session['professional'];
                            if (professionalData is Map<String, dynamic>) {
                              name = professionalData['name']?.toString() ?? 'Unknown';
                              imageUrl = professionalData['profileImage']?.toString() ?? '';
                            } else if (professionalData is String) {
                              name = 'Professional';
                              imageUrl = '';
                            }
                          }

                          final String day = session['day']?.toString() ?? '';
                          final String date = session['date']?.toString() ?? '';
                          final String status = session['status']?.toString() ?? 'Pending';
                          final String sessionId = session['_id']?.toString() ?? '';

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 6.h,
                            ),
                            child: GetBuilder<SessionsController>(
                              builder: (controller) {
                                // Parse date safely
                                String timeString = 'Waiting';
                                if (date.isNotEmpty) {
                                  try {
                                    final parsedDate = DateTime.parse(date);
                                    timeString = TimeFormatHelper.timeWithAMPM(parsedDate) ?? 'Waiting';
                                  } catch (e) {
                                    debugPrint('Error parsing date: $e');
                                  }
                                }

                                return CustomListTile(
                                  contentPaddingVertical: 6.h,
                                  borderRadius: 8.r,
                                  borderColor: AppColors.borderColor,
                                  image: imageUrl,
                                  imageRadius: 24.r,
                                  title: name,
                                  subTitle: timeString,
                                  titleFontSize: 16.sp,
                                  trailing: status == 'Confirmed'
                                      ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => CustomDialog(
                                                title: "You sure you want to cancel the session?",
                                                confirmButtonColor: const Color(0xffF40000),
                                                confirmButtonText: 'Yes',
                                                onCancel: () => Get.back(),
                                                onConfirm: () => controller.completeSessionDBHandler(
                                                  sessionId,
                                                  'Canceled',
                                                ),
                                              ),
                                            );
                                          },
                                          child: Assets.icons.cleanIcon.svg(),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => CustomDialog(
                                                title: "Do you want to mark this session as completed?",
                                                confirmButtonText: 'Yes',
                                                onCancel: () => Get.back(),
                                                onConfirm: () => controller.completeSessionDBHandler(
                                                  sessionId,
                                                  'Completed',
                                                ),
                                              ),
                                            );
                                          },
                                          child: Assets.icons.success.svg(),
                                        ),
                                      ),
                                    ],
                                  )
                                      : _buildSessionStatus(status),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );                  },
                ),
              ],
            );
          },
        ),
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
      case 'Cancelled':
        value = status;
        bgColor = const Color(0xFFF40000);
        break;
      default:
        value = status;
        bgColor = const Color(0xFF0ABAB5);
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
