import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pmayard_app/app/helpers/time_format.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/profile_confirm_controller.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/widgets/widgets.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final profileController = Get.find<ProfileConfirmController>();

  DateTime selectedDate = DateTime.now();

  // Changed to store multiple slots per date
  Map<DateTime, List<String>> selectedSlots = {};
  Map<DateTime, List<String>> weekTimeSlots = {};

  List<DateTime> getWeekDates(DateTime date) {
    int currentWeekDay = date.weekday;
    DateTime sunday = date.subtract(Duration(days: currentWeekDay % 7));
    return List.generate(7, (i) => sunday.add(Duration(days: i)));
  }

  void generateWeekTimeSlots(DateTime date) {
    final weekDays = getWeekDates(date);

    for (var day in weekDays) {
      weekTimeSlots[day] = [
        "10:00 - 10:30",
        "11:00 - 11:30",
        "12:00 - 12:30",
        "01:00 - 01:30",
        "02:00 - 02:30",
        "03:00 - 03:30",
        "04:00 - 04:30",
        "05:00 - 05:30",
        "06:00 - 06:30",
      ];
    }
  }

  List<String> getSelectedDaySlots() {
    return weekTimeSlots[selectedDate] ?? [];
  }

  // Check if at least one slot is selected for all 7 days
  bool get allDaysHaveSlots {
    final weekDays = getWeekDates(selectedDate);
    for (var day in weekDays) {
      if (!selectedSlots.containsKey(day) || selectedSlots[day]!.isEmpty) {
        return false;
      }
    }
    return true;
  }

  // Convert time format from "10:00 - 10:30" to "10:00 AM" and "10:30 AM"
  Map<String, String> parseTimeSlot(String slot) {
    final parts = slot.split(' - ');
    final startTime = parts[0].trim();
    final endTime = parts[1].trim();

    return {
      'startTime': convertTo12Hour(startTime),
      'endTime': convertTo12Hour(endTime),
    };
  }

  String convertTo12Hour(String time24) {
    final parts = time24.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    final period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    return '$hour:$minute $period';
  }

  // Format data for backend
  List<Map<String, dynamic>> formatAvailabilityForBackend() {
    List<Map<String, dynamic>> availability = [];

    selectedSlots.forEach((date, slots) {
      List<Map<String, dynamic>> timeSlots = [];

      for (var slot in slots) {
        final parsedTime = parseTimeSlot(slot);
        timeSlots.add({
          "startTime": parsedTime['startTime'],
          "endTime": parsedTime['endTime'],
          "status": "available"
        });
      }

      availability.add({
        "day": DateFormat.EEEE().format(date), // Full day name (Monday, Tuesday, etc.)
        "timeSlots": timeSlots
      });
    });

    return availability;
  }

  @override
  void initState() {
    super.initState();
    generateWeekTimeSlots(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = getWeekDates(selectedDate);

    return CustomScaffold(
      appBar: CustomAppBar(title: "Set Schedule"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CustomText(
              text: "Set Your Schedule",
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              bottom: 16.h,
            ),
          ),

          CustomText(
            bottom: 16.h,
            text: TimeFormatHelper.formatMonthOrDate(DateTime.now()),
            fontSize: 12.sp,
          ),

          // Week Calendar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDays.map((date) {
              bool isSelected = date.day == selectedDate.day &&
                  date.month == selectedDate.month &&
                  date.year == selectedDate.year;

              // Show dot if any slot selected for that day
              bool hasSlotSelected = selectedSlots.containsKey(date) &&
                  selectedSlots[date]!.isNotEmpty;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                    profileController.selectedDate = date;
                  });
                },
                child: Column(
                  children: [
                    CustomText(
                      text: DateFormat.E().format(date),
                      bottom: 6.h,
                      color: isSelected ? null : AppColors.appGreyColor,
                    ),
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: isSelected
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomText(
                            text: "${date.day}",
                            color: isSelected
                                ? Colors.white
                                : AppColors.appGreyColor,
                          ),
                          Positioned(
                            bottom: 2.h,
                            child: hasSlotSelected
                                ? CustomContainer(
                              height: 5.h,
                              width: 5.w,
                              color: AppColors.secondaryColor,
                              shape: BoxShape.circle,
                            )
                                : SizedBox.shrink(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          CustomText(
            text: "Set Time Slot",
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            top: 20.h,
            bottom: 10.h,
          ),

          // Show selected slots count for current day
          if (selectedSlots.containsKey(selectedDate) &&
              selectedSlots[selectedDate]!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: CustomText(
                text: "${selectedSlots[selectedDate]!.length} slot(s) selected",
                fontSize: 12.sp,
                color: AppColors.primaryColor,
              ),
            ),

          Expanded(
            child: GridView.builder(
              itemCount: getSelectedDaySlots().length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 109.w / 38.h,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final slot = getSelectedDaySlots()[index];

                // Check if this slot is selected for current date
                bool isSlotSelected = selectedSlots.containsKey(selectedDate) &&
                    selectedSlots[selectedDate]!.contains(slot);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!selectedSlots.containsKey(selectedDate)) {
                        selectedSlots[selectedDate] = [];
                      }

                      if (isSlotSelected) {
                        // Remove slot if already selected
                        selectedSlots[selectedDate]!.remove(slot);
                        if (selectedSlots[selectedDate]!.isEmpty) {
                          selectedSlots.remove(selectedDate);
                        }
                      } else {
                        // Add slot to selected list
                        selectedSlots[selectedDate]!.add(slot);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      color: isSlotSelected
                          ? AppColors.secondaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.06),
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
                    duration: Duration(milliseconds: 300),
                    child: CustomText(
                      text: slot,
                      color: isSlotSelected
                          ? Colors.white
                          : AppColors.secondaryColor,
                      fontSize: 12.sp,
                    ),
                  ),
                );
              },
            ),
          ),

          GetBuilder<ProfileConfirmController>(
            builder: (controller) {
              return controller.isLoading ? CustomLoader() : CustomButton(
                onPressed: () {
                  if (allDaysHaveSlots) {
                    debugPrint("Weekly Schedule:");
                    final availability = formatAvailabilityForBackend();
                    debugPrint(jsonEncode(availability));

                    controller.availability = availability;
                    controller.profileConfirm();
                  } else {
                    showToast("Please select at least one slot for all days");
                  }
                },
                label: "Confirm",
              );
            }
          ),
        ],
      ),
    );
  }
}