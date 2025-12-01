import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/assigned/assigned_controller.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/models/availability_model.dart';
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
    // for (var day in weekDays) {
    //   final availability = controller.availabilityData.firstWhere(
    //         (e) => e.day == day,
    //     orElse: () => AvailabilityModel(day: this.controller.availabilityData.?day, timeSlots: []),
    //   );

    // weekTimeSlots[day] = availability.timeSlots.cast<String>();
    // for (var day in weekDays) {
    //   weekTimeSlots[day] = [
    //     "9:00",
    //     "11:00",
    //     "1:00",
    //     "3:00",
    //     "5:00",
    //     "7:00",
    //     "2:00",
    //   ];
    // }
  }

  List<String> getSelectedDaySlots() {
    return weekTimeSlots[selectedDate] ?? [];
  }

  bool get allSlotsSelected => selectedSlots.length == 7;

  final scheduleID = Get.arguments['scheduleID'];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      generateWeekTimeSlots(selectedDate);
      controller.fetchAvailabilityData(scheduleID);
      print('Maruf Char =================>>>>> ${controller.availabilityData}');
    });
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Set Schedule'),
      body: GetBuilder<AssignedController>(
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Set Your Schedule',
                  style: TextStyle(
                    color: Color(0XFF0D0D0D),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 13.h),

              // CustomContainer(
              //   color: Colors.white,
              //   child: TableCalendar(
              //     firstDay: DateTime.utc(2020, 1, 1),
              //     lastDay: DateTime.utc(2030, 12, 31),
              //     focusedDay: _focusedDay,
              //     selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              //     onDaySelected: (selectedDay, focusedDay) {
              //       setState(() {
              //         _selectedDay = selectedDay;
              //         _focusedDay = focusedDay;
              //       });
              //     },
              //
              //     headerStyle: HeaderStyle(
              //       formatButtonVisible: false,
              //       titleTextFormatter: (date, locale) =>
              //           DateFormat('MMMM yyyy').format(date),
              //       titleTextStyle: TextStyle(fontSize: 20.sp),
              //       leftChevronVisible: false,
              //       rightChevronVisible: false,
              //     ),
              //     daysOfWeekStyle: DaysOfWeekStyle(
              //       dowTextFormatter: (date, locale) {
              //         return DateFormat.E(locale).format(date)[0];
              //       },
              //       weekdayStyle: TextStyle(fontSize: 14),
              //       weekendStyle: TextStyle(fontSize: 14),
              //     ),
              //
              //     calendarFormat: CalendarFormat.week,
              //     availableGestures: AvailableGestures.horizontalSwipe,
              //     calendarStyle: CalendarStyle(
              //       todayDecoration: BoxDecoration(
              //         color: AppColors.primaryColor,
              //         shape: BoxShape.circle,
              //       ),
              //       selectedDecoration: const BoxDecoration(
              //         color: AppColors.primaryColor,
              //         shape: BoxShape.circle,
              //       ),
              //       selectedTextStyle: const TextStyle(color: Colors.white),
              //       defaultTextStyle: TextStyle(fontSize: 12.sp),
              //     ),
              //   ),
              // ),
              CustomContainer(
                color: Colors.white,
                child: TableCalendar(
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: false,
                    rightChevronVisible: false,
                    leftChevronVisible: false,
                  ),

                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2022, 1, 1),
                  lastDay: DateTime.utc(2030, 1, 1),

                  onDaySelected: (selectedDay, focusedDay) {
                    print('===========> Selected Day $selectedDay');
                    print('===========> Selected Day $focusedDay');
                    controller.scheduleDate = selectedDay;
                    controller.dataOnchangeHandler();
                    // setState(() {
                    //   controller.scheduleDate = selectedDay;
                    // });
                    _focusedDay = focusedDay;
                  },
                  calendarFormat: CalendarFormat.week,
                  currentDay: controller.scheduleDate,
                  selectedDayPredicate: (day) =>
                      isSameDay(controller.scheduleDate, day),
                  availableGestures: AvailableGestures.verticalSwipe,
                ),
              ),

              SizedBox(height: 15.h),
              Text(
                'Set Time Slot',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: Color(0XFF0D0D0D),
                ),
              ),
              SizedBox(height: 15.h),
              Row(
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
              ),
              SizedBox(height: 15.h),

              // Expanded(
              //   child: GetBuilder<AssignedController>(builder: (controller) {
              //
              //     if (controller.isScheduleLoading) {
              //       return Center(child: CircularProgressIndicator());
              //     }
              //
              //     if (controller.availabilityData.isEmpty) {
              //       return Center(
              //         child: Text(
              //           'No availability data found',
              //           style: TextStyle(fontSize: 16.sp),
              //         ),
              //       );
              //     }
              //     final selectedDayName = DateFormat('EEEE').format(_selectedDay ?? _focusedDay);
              //
              //     print('Looking for day: $selectedDayName');
              //     final dayAvailability = controller.availabilityData.firstWhere(
              //           (availability) => availability.day == selectedDayName,
              //       orElse: () => AvailabilityModel(day: selectedDayName, timeSlots: []),
              //     );
              //
              //     final timeSlots = dayAvailability.timeSlots ?? [];
              //
              //     if (timeSlots.isEmpty) {
              //       return Center(
              //         child: Text(
              //           'No time slots available for $selectedDayName',
              //           style: TextStyle(fontSize: 16.sp),
              //         ),
              //       );
              //     }
              //
              //     int crossAxisCount = timeSlots.length.clamp(1, 3);
              //
              //     return GridView.builder(
              //       itemCount: timeSlots.length,
              //       padding: EdgeInsets.zero,
              //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: crossAxisCount,
              //         childAspectRatio: 109.w / 38.h,
              //         crossAxisSpacing: 8,
              //         mainAxisSpacing: 8,
              //       ),
              //       itemBuilder: (context, index) {
              //         final slot = timeSlots[index];
              //
              //         // Determine colors based on status
              //         Color backgroundColor;
              //         Color textColor = Colors.white;
              //
              //         switch (slot.status?.toLowerCase()) {
              //           case 'available':
              //             backgroundColor = Color(0XFF305CDE); // Blue for available
              //             break;
              //           case 'booked':
              //             backgroundColor = Color(0XFFC2B067); // Gold for booked
              //             break;
              //           case 'disabled':
              //             backgroundColor = Colors.grey; // Grey for disabled
              //             break;
              //           default:
              //             backgroundColor = Colors.grey;
              //         }
              //
              //         return GestureDetector(
              //           onTap: slot.status?.toLowerCase() == 'available' ? () {
              //             setState(() {
              //               selectedSlots[_selectedDay ?? _focusedDay] =
              //               '${slot.startTime} - ${slot.endTime}';
              //             });
              //           } : null,
              //           child: AnimatedContainer(
              //             decoration: BoxDecoration(
              //               color: backgroundColor,
              //               borderRadius: BorderRadius.circular(8.r),
              //               border: Border.all(
              //                 color: Colors.black.withOpacity(0.06),
              //               ),
              //               boxShadow: [
              //                 BoxShadow(
              //                   color: Colors.black.withOpacity(0.02),
              //                   offset: Offset(0, 0),
              //                   blurRadius: 3,
              //                 ),
              //               ],
              //             ),
              //             alignment: Alignment.center,
              //             duration: Duration(milliseconds: 300),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 CustomText(
              //                   text: '${slot.startTime} - ${slot.endTime}',
              //                   color: textColor,
              //                   fontSize: 12.sp,
              //                   fontWeight: FontWeight.w600,
              //                 ),
              //                 SizedBox(height: 2.h),
              //                 CustomText(
              //                   text: slot.status ?? '',
              //                   color: textColor.withOpacity(0.8),
              //                   fontSize: 10.sp,
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   }),
              // ),
              Expanded(
                child: GetBuilder<AssignedController>(

                  builder: (controller) {

                    // final allSlots = controller.timeSlot;

                    final selectedDayName = DateFormat(
                      'EEEE',
                    ).format(_selectedDay ?? _focusedDay);

                    return GridView.builder(
                      itemCount: controller.timeSlotDatas.length,
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 109.w / 38.h,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        print('=====================================>>>>>>>>>>>>>>>>>>> ${controller
                            .timeSlotDatas[index]}');
                        // final slot = allSlots[index];
                        // final status = slot['status']?.toLowerCase() ?? '';


                        // controller
                        //     .availabilityData.map((e)=> print('349 ${e}')).toList();
                        // print('this is 348 no line data ${controller
                        //     .availabilityData[index].timeSlots}');

                         String? slot = controller.timeSlotDatas[index].status;
                        // Determine colors based on status
                        Color backgroundColor;
                        Color textColor = Colors.white;

                        switch (slot?.toLowerCase()) {
                          case 'available':
                            backgroundColor = Color(
                              0XFF305CDE,
                            ); // Blue for available
                            break;
                          case 'booked':
                            backgroundColor = Color(
                              0XFFC2B067,
                            ); // Gold for booked
                            break;
                          case 'disabled':
                            backgroundColor = Colors.grey; // Grey for disabled
                            break;
                          default:
                            backgroundColor = Colors.grey;
                        }

                        return GestureDetector(

                          onTap: controller.timeSlotDatas[index].status == 'available' ? (){
                            // controller.timeSlot = slot as Map<String, String>?;

                          } : SizedBox.shrink,
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                              // color: Colors.red,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  // text: '10-10.30',
                                  text: '${
                                      controller.timeSlotDatas[index].startTime
                                  } - ${controller.timeSlotDatas[index].endTime}',
                                  color: textColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                SizedBox(height: 2.h),
                                CustomText(
                                  // text: 'Block',
                                  text: '${
                                      controller.timeSlotDatas[index].status
                                  }',
                                  color: textColor.withOpacity(0.8),
                                  fontSize: 10.sp,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              CustomButton(
                onPressed: () => controller.confirmSchedule(scheduleID),
                title: controller.isConfirmScheduleLoading == true
                    ? Center(child: CustomLoader())
                    : Text(
                        'Confirm',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
              SizedBox(height: 5.h),
            ],
          );
        },
      ),
    );
  }
}
