import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pmayard_app/app/helpers/time_format.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/profile_confirm_controller.dart';
import 'package:pmayard_app/widgets/widgets.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final profileController = Get.find<ProfileConfirmController>();

  DateTime selectedDate = DateTime.now();
  Map<DateTime, String> selectedSlots = {};
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

  bool get allSlotsSelected => selectedSlots.length == 7;

  // Build availability data for backend
  List<Map<String, dynamic>> buildAvailability() {
    List<Map<String, dynamic>> availability = [];

    selectedSlots.forEach((date, slot) {
      String dayName = DateFormat.EEEE().format(date); // "Monday", "Tuesday", etc.

      // Parse the time slot (e.g., "10:00 - 10:30")
      List<String> times = slot.split(' - ');
      String startTime = times[0];
      String endTime = times[1];

      // Check if this day already exists in availability
      int existingIndex = availability.indexWhere((item) => item['day'] == dayName);

      Map<String, dynamic> timeSlotData = {
        "startTime": startTime,
        "endTime": endTime,
        "status": "available"
      };

      if (existingIndex != -1) {
        // Day exists, add time slot to existing day
        availability[existingIndex]['timeSlots'].add(timeSlotData);
      } else {
        // Day doesn't exist, create new entry
        availability.add({
          "day": dayName,
          "timeSlots": [timeSlotData]
        });
      }
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

          // Week Calendar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDays.map((date) {
              bool isSelected =
                  date.day == selectedDate.day &&
                      date.month == selectedDate.month &&
                      date.year == selectedDate.year;

              bool hasSlotSelected = selectedSlots.containsKey(date);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                    profileController.selectedDate = date;
                  });
                },
                child: Column(
                  children: [
                    CustomContainer(
                      paddingHorizontal: 10.w,
                      paddingVertical: 6.h,
                      radiusAll: 8.r,
                      color: isSelected
                          ? AppColors.primaryColor
                          : hasSlotSelected
                          ? AppColors.secondaryColor.withOpacity(0.2)
                          : Colors.transparent,
                      child: CustomText(
                        text: DateFormat.E().format(date), // Shows "Mon", "Tue", "Wed"
                        color: isSelected
                            ? Colors.white
                            : hasSlotSelected
                            ? AppColors.secondaryColor
                            : AppColors.appGreyColor,
                        fontSize: 12.sp,
                      ),
                    ),
                    if (hasSlotSelected)
                      Container(
                        margin: EdgeInsets.only(top: 4.h),
                        height: 5.h,
                        width: 5.w,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          shape: BoxShape.circle,
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
                bool isSlotSelected = selectedSlots[selectedDate] == slot;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSlots[selectedDate] = slot;
                    });
                  },
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      color: isSlotSelected
                          ? AppColors.secondaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.black.withOpacity(0.06)),
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
              return controller.isLoading
                  ? CustomLoader()
                  : CustomButton(
                onPressed: () {
                  // Build availability and pass to controller
                  List<Map<String, dynamic>> availability = buildAvailability();
                  controller.availability = availability;
                  controller.profileConfirm();
                },
                label: "Confirm",
              );
            },
          ),
        ],
      ),
    );
  }
}