import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/custom_assets/assets.gen.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_button.dart';
import 'package:pmayard_app/widgets/custom_dialog.dart';
import 'package:pmayard_app/widgets/custom_list_tile.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';
import 'package:table_calendar/table_calendar.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      paddingSide: 0,
      appBar: CustomAppBar(
        title: 'Session',
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
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
                titleTextStyle: TextStyle(fontSize: 12.sp),
                formatButtonVisible: false,
                titleCentered: false,
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
                defaultTextStyle: TextStyle(
                  fontSize: 12.sp,
                ),
              ),
            ),

        
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 6.h),
                  child: CustomListTile(
                    contentPaddingVertical: 6.h,
                    borderRadius: 8.r,
                    borderColor: AppColors.borderColor,
                    image: '',
                    imageRadius: 24.r,
                    title: 'Annette Black',
                    subTitle: '08/08/25 at 4:30 PM',
                    titleFontSize: 16.sp,
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => CustomDialog(
                                  title: "You sure you want to cancel the session?",
                                  confirmButtonColor: Color(0xffF40000),
                                  confirmButtonText: 'Yes',
                                  onCancel: () {
                                    Get.back();
                                  },
                                  onConfirm: () {
                                    Get.back();
                                    //Get.offAllNamed(AppRoutes.loginScreen);
                                  },
                                ),
                              );
                            },

                            child: Assets.icons.cleanIcon.svg())),
                        SizedBox(width: 12.w),
                        Flexible(child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => CustomDialog(
                                  title: "Do you want to mark this session as completed?",
                                  confirmButtonText: 'Yes',
                                  onCancel: () {
                                    Get.back();
                                  },
                                  onConfirm: () {
                                    Get.back();
                                    //Get.offAllNamed(AppRoutes.loginScreen);
                                  },
                                ),
                              );
                            },
                            child: Assets.icons.success.svg())),
                      ],
                    ),
                  ),
                );
              },),
          ],
        ),
      ),
    );
  }
}
