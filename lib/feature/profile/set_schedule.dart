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
      body: Column(
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
                  });
                },

                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleTextFormatter: (date, locale) =>
                      DateFormat('MMMM yyyy').format(date),
                  titleTextStyle: TextStyle(fontSize: 20.sp),
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  dowTextFormatter: (date, locale) {
                    return DateFormat.E(locale).format(date)[0];
                  },
                  weekdayStyle: TextStyle(fontSize: 14),
                  weekendStyle: TextStyle(fontSize: 14),
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
            Expanded(
              child: GetBuilder<AssignedController>(builder: (controller)
              {
                int cntLen = controller.availabilityData.length;

                return GridView.builder(
                  itemCount: 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,

                    // crossAxisCount: cntLen >= 3 ? cntLen : cntLen == 2 ? 2 : cntLen == 1 ? 1 : 0,

                    childAspectRatio: 109.w / 38.h,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    // final slot = getSelectedDaySlots()[index];
                    // bool isSlotSelected = selectedSlots[selectedDate] == slot;
                    // final data = controller.availabilityData[index];
                    // final timeSlot = data.timeSlots?[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // selectedSlots[selectedDate] = slot;
                        });
                      },
                      child: AnimatedContainer(
                        decoration: BoxDecoration(
                          // color: isSlotSelected
                          color: Colors.red == Colors.red ? AppColors.secondaryColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                              color: Colors.black.withOpacity(0.06)),
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
                          text: 'tex',
                          color: Colors.red == Colors.red
                              ? Colors.white
                              : AppColors.secondaryColor,
                          fontSize: 12.sp,

                          // text: '${timeSlot?.startTime?.split(' ')}-${timeSlot
                          //     ?.endTime?.split(' ')}',
                          // color: isSlotSelected
                          //     ? Colors.white
                          //     : AppColors.secondaryColor,
                          // fontSize: 12.sp,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            // Set Schedule Button are here
            CustomButton(
              onPressed: () {
                print('Due the Api Integration yet');
              },
              title: Text('Confirm',
                style: TextStyle(fontSize: 16, color: Colors.white),),
            ),
            SizedBox(height: 5.h,)
          ]
      ),
    );
  }
}
