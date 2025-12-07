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
  String? sessionID;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        generateWeekTimeSlots(selectedDate);
        professionalId = Get.arguments['professionalId'] as String?;
        sessionID = Get.arguments['sessionID'] as String?;
        controller.fetchAvailabilityData(professionalId ?? '');
      });
      print('==========Set Schedule page ===========>>>>>>>> 56 no line $professionalId');
    });
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    print('Set Schedule page =====================>>>>>>>> 64 no line $professionalId');
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
                      String currentStartTime =
                          controller.timeSlotDatas[index].startTime ?? '';
                      String currentEndTime =
                          controller.timeSlotDatas[index].endTime ?? '';

                      // Check if this slot is selected
                      bool isSelected =
                          controller.startTime?.value == currentStartTime &&
                          controller.endTime?.value == currentEndTime;

                      Color backgroundColor;
                      Color textColor = isSelected
                          ? AppColors.primaryColor
                          : Colors.white;
                      Color borderColor = Colors.transparent;

                      switch (slot?.toLowerCase()) {
                        case 'available':
                          backgroundColor = AppColors.secondaryColor;
                          borderColor = isSelected
                              ? AppColors.primaryColor
                              : Colors.transparent;
                          break;
                        case 'booked':
                          backgroundColor = Color(0XFFC2B067);
                          borderColor = Colors.transparent;
                          break;
                        case 'disabled':
                          backgroundColor = Colors.grey.shade400;
                          textColor = Colors.grey.shade300;
                          borderColor = Colors.transparent;
                          break;
                        default:
                          backgroundColor = Colors.green;
                      }

                      return GestureDetector(
                        onTap: slot == 'available'
                            ? () {
                                controller.startTime!.value = currentStartTime;
                                controller.endTime!.value = currentEndTime;

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
                              color: borderColor,
                              width: isSelected ? 1 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: '$currentStartTime - $currentEndTime',
                                color: textColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: 2.h),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10.h,),
            GetBuilder<AssignedController>(
              builder: (controller) {
                return Get.find<UserController>().user?.role == 'professional'
                    ? CustomButton(
                        onPressed: () => controller.confirmSchedule(
                          sessionID: professionalId ?? '',
                        ),
                        title: controller.isConfirmScheduleLoading == true
                            ? Center(child: CustomLoader())
                            : Text(
                                'Confirm',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      )
                    : SizedBox.shrink();
              },
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }
}
