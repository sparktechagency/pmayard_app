import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pmayard_app/app/helpers/time_format.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/widgets/widgets.dart';

class EditScheduleScreen extends StatefulWidget {
  const EditScheduleScreen({super.key});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
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

  @override
  void initState() {
    super.initState();
    generateWeekTimeSlots(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = getWeekDates(selectedDate);

    return CustomScaffold(
      appBar: CustomAppBar(title: "Edit Schedule"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CustomText(
              text: "Edit Your Schedule",
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
              bool isSelected =
                  date.day == selectedDate.day &&
                      date.month == selectedDate.month &&
                      date.year == selectedDate.year;

              // show dot if slot already selected for that day
              bool hasSlotSelected = selectedSlots.containsKey(date);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
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
                            color: isSelected ? Colors.white : AppColors.appGreyColor,
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



          CustomButton(
            onPressed: () {
              if(allSlotsSelected){
                debugPrint("Weekly Schedule:");
                selectedSlots.forEach((date, slot) {
                  debugPrint("${DateFormat.E().format(date)}: $slot");
                });
              }
              Get.back();

            },
            label: "Confirm",
          ),
        ],
      ),
    );
  }
}
