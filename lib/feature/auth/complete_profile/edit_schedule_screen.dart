import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/schedule/schedule_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/widgets/widgets.dart';

class EditScheduleScreen extends StatefulWidget {
  const EditScheduleScreen({super.key});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  final UserController _userController = Get.find<UserController>();

  final Map<String, String> weekDays = {
    'Sun': 'Sunday',
    'Mon': 'Monday',
    'Tue': 'Tuesday',
    'Wed': 'Wednesday',
    'Thu': 'Thursday',
    'Fri': 'Friday',
    'Sat': 'Saturday',
  };

  final List<Map<String, String>> staticTimeSlots = [
    {"start": "09:00 AM", "end": "10:00 AM"},
    {"start": "10:00 AM", "end": "11:00 AM"},
    {"start": "11:00 AM", "end": "12:00 PM"},
    {"start": "01:00 PM", "end": "02:00 PM"},
    {"start": "02:00 PM", "end": "03:00 PM"},
    {"start": "03:00 PM", "end": "04:00 PM"},
    {"start": "04:00 PM", "end": "05:00 PM"},
    {"start": "05:00 PM", "end": "06:00 PM"},
    {"start": "06:00 PM", "end": "07:00 PM"},
  ];

  int selectedDayIndex = 0;

  // Store selected time slots for each day
  Map<String, List<Map<String, String>>> selectedTimeSlots = {};

  @override
  void initState() {
    if (_userController.user == null) {
      _userController.userData();
    }
    _initializeSelectedSlots();
    super.initState();
  }

  String normalizeTime(String time) {
    return time.trim().replaceFirst(RegExp(r'^0'), '');
  }
  void _initializeSelectedSlots() {
    if (_userController.user?.roleId?.availability != null) {
      for (var availability in _userController.user!.roleId!.availability!) {
        String day = availability.day ?? '';
        if (day.isNotEmpty && availability.timeSlots != null) {
          selectedTimeSlots[day] = [];
          for (var slot in availability.timeSlots!) {
            String startTime = slot.startTime ?? '';
            String endTime = slot.endTime ?? '';

            if (startTime.isNotEmpty && endTime.isNotEmpty) {
              selectedTimeSlots[day]!.add({
                "start": startTime,
                "end": endTime,
                "status": slot.status ?? "available",
              });
            }
          }
        }
      }
    }

    debugPrint('Initialized selectedTimeSlots: ${selectedTimeSlots.toString()}');
  }

  String formatTimeSlot(Map<String, String> slot) {
    return "${slot['start']} - ${slot['end']}";
  }
  String? getTimeSlotStatus(Map<String, String> timeSlot) {
    String selectedDay = weekDays.values.toList()[selectedDayIndex];

    if (selectedTimeSlots[selectedDay] == null) return null;

    var slot = selectedTimeSlots[selectedDay]!.firstWhere(
          (slot) {
        String slotStart = normalizeTime(slot['start'] ?? '');
        String slotEnd = slot['end']?.trim() ?? '';
        String staticStart = normalizeTime(timeSlot['start'] ?? '');
        String staticEnd = timeSlot['end']?.trim() ?? '';

        return slotStart == staticStart && slotEnd == staticEnd;
      },
      orElse: () => {},
    );

    return slot['status'];
  }

  bool isTimeSlotSelected(Map<String, String> timeSlot) {
    String selectedDay = weekDays.values.toList()[selectedDayIndex];

    if (selectedTimeSlots[selectedDay] == null) return false;

    return selectedTimeSlots[selectedDay]!.any((slot) {
      String slotStart = normalizeTime(slot['start'] ?? '');
      String slotEnd = slot['end']?.trim() ?? '';
      String staticStart = normalizeTime(timeSlot['start'] ?? '');
      String staticEnd = timeSlot['end']?.trim() ?? '';

      return slotStart == staticStart && slotEnd == staticEnd;
    });
  }

  bool isTimeSlotBooked(Map<String, String> timeSlot) {
    return getTimeSlotStatus(timeSlot) == "booked";
  }

  void toggleTimeSlot(Map<String, String> timeSlot) {
    if (isTimeSlotBooked(timeSlot)) {
      return;
    }

    String selectedDay = weekDays.values.toList()[selectedDayIndex];
    if (selectedTimeSlots[selectedDay] == null) {
      selectedTimeSlots[selectedDay] = [];
    }
    int existingIndex = selectedTimeSlots[selectedDay]!.indexWhere((slot) {
      String slotStart = normalizeTime(slot['start'] ?? '');
      String slotEnd = slot['end']?.trim() ?? '';
      String staticStart = normalizeTime(timeSlot['start'] ?? '');
      String staticEnd = timeSlot['end']?.trim() ?? '';

      return slotStart == staticStart && slotEnd == staticEnd;
    });

    setState(() {
      if (existingIndex != -1) {
        selectedTimeSlots[selectedDay]!.removeAt(existingIndex);
      } else {
        selectedTimeSlots[selectedDay]!.add({
          "start": timeSlot['start']!,
          "end": timeSlot['end']!,
          "status": "available",
        });
      }
    });

    debugPrint('Selected for $selectedDay: ${selectedTimeSlots[selectedDay].toString()}');
  }

  Map<String, dynamic> prepareApiData() {
    String selectedDay = weekDays.values.toList()[selectedDayIndex];

    List<Map<String, dynamic>> timeSlotsList = [];

    if (selectedTimeSlots[selectedDay] != null) {
      for (var slot in selectedTimeSlots[selectedDay]!) {
        timeSlotsList.add({
          "startTime": slot['start'],
          "endTime": slot['end'],
          "status": slot['status'] ?? "available",
        });
      }
    }

    return {
      "day": selectedDay,
      "timeSlots": timeSlotsList,
    };
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: "Edit Schedule"),
      body: GetBuilder<UserController>(
        builder: (controller) {
          return Column(
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
                text: 'Set you Day',
                fontSize: 16.sp,
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: weekDays.entries.toList().asMap().entries.map((entry) {
                    int index = entry.key;
                    MapEntry<String, String> day = entry.value;
                    bool isSelected = selectedDayIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDayIndex = index;
                        });
                      },
                      child: CustomContainer(
                        color: isSelected ? AppColors.primaryColor : Colors.white,
                        paddingVertical: 8.h,
                        paddingHorizontal: 12.w,
                        elevation: true,
                        marginRight: 10.w,
                        child: CustomText(
                          text: day.key,
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
                ),
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
                  itemCount: staticTimeSlots.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 109.w / 38.h,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    Map<String, String> timeSlot = staticTimeSlots[index];
                    bool isSelected = isTimeSlotSelected(timeSlot);
                    bool isBooked = isTimeSlotBooked(timeSlot);
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
                        toggleTimeSlot(timeSlot);
                      },
                      child: AnimatedContainer(
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
                        duration: Duration(milliseconds: 300),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: formatTimeSlot(timeSlot),
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
                ),
              ),

              GetBuilder<ScheduleController>(
                builder: (controller) {
                  return controller.isLoading ? CustomLoader() : CustomButton(
                    onPressed: (){
                      controller.editSchedule(_userController.user?.roleId?.sId ?? '',prepareApiData());
                    },
                    label: "Confirm",
                  );
                }
              ),
            ],
          );
        },
      ),
    );
  }
}