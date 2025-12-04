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
  const SetScheduleScreen({super.key, this.professionalId});

  final String? professionalId;

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
  }

  List<String> getSelectedDaySlots() {
    return weekTimeSlots[selectedDate] ?? [];
  }

  bool get allSlotsSelected => selectedSlots.length == 7;
  String? professionalId;
  String? role;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      generateWeekTimeSlots(selectedDate);
      professionalId = Get.arguments['professionalId'] as String?;
      role = Get.arguments['role'] as String?;
      controller.fetchAvailabilityData(professionalId ?? '');
    });
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Set Schedule'),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchAvailabilityData(professionalId ?? "");
        },
        child: Column(
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
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(2030, 1, 1),

                onDaySelected: (selectedDay, focusedDay) {
                  print('===========> Selected Day $selectedDay');
                  print('===========> Selected Day $focusedDay');

                  controller.dataOnchangeHandler();
                  controller.scheduleDate = selectedDay;
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
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                    color: Colors.white, // Change the text color
                    fontWeight: FontWeight.bold,
                  ),
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
              child: GetBuilder<AssignedController>(
                builder: (_) {
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
                      String? slot = controller.timeSlotDatas[index].status;

                      Color backgroundColor;
                      Color textColor = Colors.white;
                      Color borderColor = Colors.black;

                      switch (slot?.toLowerCase()) {
                        case 'available':
                          backgroundColor = Color(0XFF305CDE);
                          borderColor = Colors.transparent;
                          break;
                        case 'booked':
                          backgroundColor = Color(0XFFC2B067);
                          borderColor = Colors.transparent;
                          break;
                        case 'disabled':
                          backgroundColor = Colors.white;
                          textColor = Colors.black;
                          borderColor = Colors.black;
                          break;
                        default:
                          backgroundColor = Colors.green;
                      }

                      return GestureDetector(
                        onTap: slot == 'available'
                            ? () {
                                controller.startTime!.value =
                                    controller.timeSlotDatas[index].startTime!;
                                controller.endTime!.value =
                                    controller.timeSlotDatas[index].endTime!;

                                controller.update();

                                print(controller.startTime!.value);
                                print(controller.endTime!.value);

                                controller.dataOnchangeHandler();
                              }
                            : null,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            border: Border.all(
                              color: borderColor
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text:
                                    '${controller.timeSlotDatas[index].startTime} - ${controller.timeSlotDatas[index].endTime}',
                                color: textColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: 2.h),
                              // CustomText(
                              //   text:
                              //       '${controller.timeSlotDatas[index].status}',
                              //   color: textColor.withOpacity(0.8),
                              //   fontSize: 10.sp,
                              // ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            role == 'professional' ? CustomButton(
              onPressed: () => controller.confirmSchedule(professionalId ?? ''),
              title: controller.isConfirmScheduleLoading == true
                  ? Center(child: CustomLoader())
                  : Text(
                'Confirm',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ) : SizedBox.shrink(),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }
}
