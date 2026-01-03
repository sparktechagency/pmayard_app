import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/assigned/assigned_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_button.dart';
import 'package:pmayard_app/widgets/custom_container.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';
import 'package:pmayard_app/widgets/custom_text.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../models/assigned/assign_view_profile_model.dart';

class SetScheduleScreen extends StatefulWidget {
  const SetScheduleScreen({super.key});

  @override
  State<SetScheduleScreen> createState() => _SetScheduleScreenState();
}

class _SetScheduleScreenState extends State<SetScheduleScreen> {
  final AssignViewProfileModel? profileData = Get.arguments as AssignViewProfileModel?;

  final controller = Get.find<AssignedController>();

  final String role = Get.find<UserController>().user?.role ?? '';

  @override
  void initState() {
    super.initState();
    // Call after frame is built to avoid setState during build error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initScheduleScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: role == 'parent' ? 'Availability' : 'Set Schedule',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              role == 'parent' ? 'View Availability' : 'Set Your Schedule',
              style: TextStyle(
                color: Color(0XFF0D0D0D),
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 13.h),

          // Calendar
          GetBuilder<AssignedController>(
              builder: (ctrl) {
                return CustomContainer(
                  color: Colors.white,
                  child: TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(Duration(days: 365)),
                    focusedDay: ctrl.focusedDay,
                    selectedDayPredicate: (day) => isSameDay(ctrl.selectedDay, day),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: false,
                      rightChevronVisible: false,
                      leftChevronVisible: false,
                      titleTextStyle: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onDaySelected: (selected, focused) {
                      ctrl.onDaySelected(selected, focused);
                    },
                    calendarFormat: CalendarFormat.week,
                    availableGestures: AvailableGestures.all,
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      todayDecoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }
          ),
          SizedBox(height: 20.h),

          CustomText(
            text: "See Time Slot",
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),

          SizedBox(height: 10.h),

          Row(
            children: [
              CustomContainer(
                radiusAll: 4.r,
                paddingAll: 7.r,
                color: AppColors.secondaryColor,
              ),
              CustomText(
                left: 4.w,
                text: "Available",
              ),
              SizedBox(width: 24.w),
              CustomContainer(
                radiusAll: 4.r,
                paddingAll: 7.r,
                color: AppColors.bookedColor,
              ),
              CustomText(
                left: 4.w,
                text: "Booked",
              ),
            ],
          ),
          SizedBox(height: 10.h),

          Expanded(
            child: GetBuilder<AssignedController>(
                builder: (ctrl) {
                  // Get all slots for all days
                  final allSlots = ctrl.getAllTimeSlotsForAllDays(profileData);

                  if (allSlots.isEmpty) {
                    return Center(
                      child: Text(
                        'No slots available',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    itemCount: allSlots.length,
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 100.w / 45.h,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.h,
                    ),
                    itemBuilder: (context, index) {
                      final slotData = allSlots[index];
                      final slot = slotData['slot'] as TimeSlots;
                      final dayName = slotData['day'] as String;

                      // Check if slot is booked (case-insensitive)
                      final isBooked = slot.status?.toLowerCase() == 'booked';
                      final isSelected = ctrl.selectedTimeSlot?.sId == slot.sId;

                      Color backgroundColor;
                      Color borderColor;
                      Color textColor;

                      if (isBooked) {
                        // Booked slot styling
                        backgroundColor = AppColors.bookedColor;
                        borderColor = Colors.transparent;
                        textColor = Colors.white;
                      } else if (isSelected) {
                        // Selected slot styling
                        backgroundColor = AppColors.primaryColor;
                        borderColor = AppColors.primaryColor;
                        textColor = Colors.white;
                      } else {
                        // Available slot styling
                        backgroundColor = AppColors.secondaryColor;
                        borderColor = Colors.transparent;
                        textColor = Colors.white;
                      }

                      return GestureDetector(
                        onTap: () {
                          // Only allow selection if not parent and not booked
                          if (role != 'parent' && !isBooked) {
                            ctrl.onTimeSlotSelected(slot, dayName);
                          }
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: borderColor,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: '${slot.startTime ?? ''}-${slot.endTime ?? ''}',
                                fontSize: 12.sp,
                                color: textColor,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                              // Show "Booked" label if slot is booked
                              if (isBooked) ...[
                                SizedBox(height: 2.h),
                                CustomText(
                                  text: 'Booked',
                                  fontSize: 9.sp,
                                  color: textColor.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
            ),
          ),
        ],
      ),
      bottomNavigationBar: role == 'parent'
          ? SizedBox.shrink()
          : SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: GetBuilder<AssignedController>(
            builder: (ctrl) {
              return CustomButton(
                onPressed: () {
                  if (ctrl.selectedTimeSlot != null) {
                    ctrl.confirmSchedule(
                      sessionID: profileData?.sId ?? '',
                    );
                  } else {
                    showToast(
                      'Please select a time slot',
                    );
                  }
                },
                label: ctrl.isConfirmScheduleLoading ? "Please wait.." : 'Confirm',
              );
            },
          ),
        ),
      ),
    );
  }
}