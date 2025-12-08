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

class SetScheduleScreen extends StatefulWidget {
  const SetScheduleScreen({super.key});

  @override
  State<SetScheduleScreen> createState() => _SetScheduleScreenState();
}

class _SetScheduleScreenState extends State<SetScheduleScreen> {
  final controller = Get.find<AssignedController>();
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: isParent() ? 'Availability' : 'Set Schedule',
        backAction: () => Get.back(),
      ),
      body: GetBuilder<AssignedController>(
        builder: (ctrl) {
          return Column(
            children: [
              Center(
                child: CustomText(
                  text: isParent() ? 'View Availability' : 'Set Your Schedule',
                  color: Color(0XFF0D0D0D),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 13.h),

              // Calendar শুধু ডেট সিলেক্ট করার জন্য
              CustomContainer(
                color: Colors.white,
                child: TableCalendar(
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
                  focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2022, 1, 1),
                  lastDay: DateTime.utc(2030, 1, 1),
                  onDaySelected: (selectedDay, focusedDay) {
                    // শুধু ডেট সেট করো, স্লট ফিল্টার করো না
                    ctrl.setSelectedDate(selectedDay);
                  },
                  calendarFormat: CalendarFormat.week,
                  selectedDayPredicate: (day) {
                    return ctrl.selectedDate != null && isSameDay(ctrl.selectedDate, day);
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Available Time Slots',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: Color(0XFF0D0D0D),
                  ),
                ),
              ),

              SizedBox(height: 15.h),

              // Legend
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10.w,
                          height: 10.h,
                          decoration: BoxDecoration(color: Color(0XFF305CDE)),
                        ),
                        SizedBox(width: 5.w),
                        Text('Available'),
                      ],
                    ),
                    if (isParent()) ...[
                      SizedBox(width: 24.w),
                      Row(
                        children: [
                          Container(
                            width: 10.w,
                            height: 10.h,
                            decoration: BoxDecoration(color: Color(0XFFC2B067)),
                          ),
                          SizedBox(width: 5.w),
                          Text('Booked'),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 15.h),

              // সব টাইম স্লট একসাথে দেখাবে
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildAllTimeSlots(ctrl),
                ),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: isProfessional() ? _buildBottomButton() : SizedBox.shrink(),
    );
  }

  Widget _buildAllTimeSlots(AssignedController ctrl) {
    if (ctrl.allTimeSlots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_outlined, size: 60.sp, color: Colors.grey.shade400),
            SizedBox(height: 16.h),
            CustomText(
              text: 'No time slots available',
              fontSize: 16.sp,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      );
    }

    // Professional হলে শুধু available স্লট দেখাবে, parent হলে সব দেখাবে
    final displaySlots = isProfessional()
        ? ctrl.allTimeSlots.where((slot) => slot.status?.toLowerCase() == 'available').toList()
        : ctrl.allTimeSlots.where((slot) => slot.status?.toLowerCase() == 'available' ||
        slot.status?.toLowerCase() == 'booked').toList();

    if (displaySlots.isEmpty) {
      return Center(
        child: CustomText(
          text: isProfessional() ? 'No available slots' : 'No slots',
          fontSize: 16.sp,
          color: Colors.grey.shade600,
        ),
      );
    }

    return GridView.builder(
      itemCount: displaySlots.length,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 109.w / 38.h,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final slot = displaySlots[index];
        final start = slot.startTime ?? '';
        final end = slot.endTime ?? '';
        final status = slot.status?.toLowerCase() ?? '';

        final isSelected = isProfessional() && ctrl.isTimeSlotSelected(start, end);

        Color bgColor;
        Color txtColor;
        Color borderColor = Colors.transparent;

        if (status == 'available') {
          bgColor = AppColors.secondaryColor;
          txtColor = isSelected ? AppColors.primaryColor : Colors.white;
          borderColor = isSelected ? AppColors.primaryColor : Colors.transparent;
        } else if (status == 'booked') {
          bgColor = Color(0XFFC2B067);
          txtColor = Colors.white;
        } else {
          bgColor = Colors.grey.shade400;
          txtColor = Colors.grey.shade300;
        }

        return GestureDetector(
          onTap: status == 'available' && isProfessional()
              ? () => ctrl.selectTimeSlot(start, end)
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: CustomText(
              text: '$start - $end',
              color: txtColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: GetBuilder<AssignedController>(
          builder: (ctrl) {
            if (ctrl.isConfirmScheduleLoading) return CustomLoader();

            return CustomButton(
              onPressed: ctrl.hasSelectedDate && ctrl.hasSelectedTimeSlot
                  ? () {
                final sessionId = ctrl.profileData?.sId ?? '';
                ctrl.confirmSchedule(sessionID: sessionId);
              }
                  : null,
              label: 'Confirm Schedule',
            );
          },
        ),
      ),
    );
  }

  bool isProfessional() {
    final role = userController.user?.role?.toLowerCase() ?? '';
    return role == 'professional';
  }

  bool isParent() {
    final role = userController.user?.role?.toLowerCase() ?? '';
    return role == 'parent';
  }
}