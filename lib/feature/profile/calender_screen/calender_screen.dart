import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pmayard_app/app/helpers/simmer_helper.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/event_controller.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';
import 'package:pmayard_app/widgets/custom_text.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  final EventController _eventController = Get.find<EventController>();

  @override
  void initState() {
    _eventController.eventGet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Calender',
        borderColor: AppColors.secondaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _eventController.eventGet();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(),
                child: GetBuilder<EventController>(
                  builder: (controller) {
                    return CalendarDatePicker(
                      initialDate: null,
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                      onDateChanged: (selectedDate) =>
                          controller.onDateChanged(selectedDate),
                    );
                  },
                ),
              ),
              Text('Events', style: TextStyle(fontSize: 18.sp)),
              SizedBox(height: 15.h),
              GetBuilder<EventController>(
                builder: (controller) {
                  if (controller.isLoadingEvent) {
                    return ShimmerHelper.upcomingSessionsShimmer();
                  } else if (controller.eventData.isEmpty) {
                    return Center(
                      child: CustomText(top: 24.h, text: 'Event not yet'),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.eventData.length,
                    itemBuilder: (context, index) {
                      final eventData = controller.eventData[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.w,
                            color: Colors.black.withOpacity(0.1),
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.all(12.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eventData.name ?? 'N/A',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              '${eventData.startTime} - ${eventData.endTime}',
                              style: TextStyle(
                                fontSize: 12.h,
                                color: Color(0XFF5C5C5C),
                              ),
                            ),
                            Text(
                              'Date - ${DateFormat('MMMM d, yyyy').format(DateTime.parse(eventData.eventDate.toString()))}',
                              style: TextStyle(
                                fontSize: 12.h,
                                color: Color(0XFF5C5C5C),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 5.h),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
