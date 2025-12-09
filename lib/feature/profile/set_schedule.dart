import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/assigned/assigned_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_button.dart';
import 'package:pmayard_app/widgets/custom_container.dart';
import 'package:pmayard_app/widgets/custom_loader.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';
import 'package:pmayard_app/widgets/custom_text.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../models/assigned/assign_view_profile_model.dart';

class SetScheduleScreen extends StatelessWidget {
  SetScheduleScreen({super.key});

  final AssignViewProfileModel? profileData = Get.arguments as AssignViewProfileModel?;
  final controller = Get.find<AssignedController>();
  final String role = Get.find<UserController>().user?.role ?? '';

  @override
  Widget build(BuildContext context) {
    controller.initScheduleScreen();

    return CustomScaffold(
      appBar: CustomAppBar(
        title: role == 'parent' ? 'Availability' : 'Set Schedule',
      ),
      body: GetBuilder<AssignedController>(
        builder: (ctrl) {
          return Column(
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
              CustomContainer(
                color: Colors.white,
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
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
              ),
              SizedBox(height: 20.h),
              CustomText(
                text: "Set Time Slot",
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: _buildTimeSlotGrid(ctrl, profileData),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: role == 'parent'
          ? SizedBox.shrink()
          : SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: GetBuilder<AssignedController>(
            builder: (ctrl) {
              return ctrl.isConfirmScheduleLoading
                  ? CustomLoader()
                  : CustomButton(
                onPressed: () {
                  if (ctrl.selectedTimeSlot != null) {
                    ctrl.confirmSchedule(
                      sessionID: profileData?.sId ?? '',
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please select a time slot',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                label: 'Confirm',
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlotGrid(AssignedController ctrl, AssignViewProfileModel? profileData) {
    final dayName = ctrl.getCurrentDayName();
    final timeSlots = ctrl.getTimeSlotsForDay(dayName, profileData);

    if (timeSlots.isEmpty) {
      return Center(
        child: Text(
          'No slots available for $dayName',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey,
          ),
        ),
      );
    }

    return GridView.builder(
      itemCount: timeSlots.length,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 109.w / 38.h,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
      itemBuilder: (context, index) {
        final slot = timeSlots[index];
        final isBooked = slot.status == 'booked';
        final isSelected = ctrl.selectedTimeSlot?.sId == slot.sId;

        Color backgroundColor;
        Color borderColor;
        Color textColor;

        if (isBooked) {
          backgroundColor = Colors.grey.withOpacity(0.15);
          borderColor = Colors.transparent;
          textColor = Colors.grey.shade600;
        } else if (isSelected) {
          backgroundColor = AppColors.primaryColor.withOpacity(0.1);
          borderColor = AppColors.primaryColor;
          textColor = AppColors.primaryColor;
        } else {
          backgroundColor = Colors.white;
          borderColor = Colors.black.withOpacity(0.06);
          textColor = Colors.black87;
        }

        return GestureDetector(
          onTap: () {
            if (role != 'parent' && !isBooked) {
              ctrl.onTimeSlotSelected(slot);
            }
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: borderColor,
                width: (isSelected || isBooked) ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  offset: Offset(0, 0),
                  blurRadius: 3,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: '${slot.startTime ?? ''} - ${slot.endTime ?? ''}',
                  fontSize: 12.sp,
                  color: textColor,
                  fontWeight: (isSelected || isBooked) ? FontWeight.w600 : FontWeight.w400,
                ),
                if (isBooked) ...[
                  SizedBox(height: 2.h),
                  CustomText(
                    text: 'Booked',
                    fontSize: 9.sp,
                    color: Colors.orange.shade700,
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
}