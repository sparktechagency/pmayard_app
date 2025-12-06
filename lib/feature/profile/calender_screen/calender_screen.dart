import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/event_controller.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  // Store Events are here
  List<Map<String, String>> storeEvents = [
    {'eventName': 'Meeting', 'time': '3:30AM - 5:00AM'},
    {'eventName': 'John’s Birthday', 'time': '3:30AM - 5:00AM'},
    {'eventName': 'Football Match', 'time': '3:30AM - 5:00AM'},
    {'eventName': 'John’s Birthday', 'time': '3:30AM - 5:00AM'},
    {'eventName': 'Football Match', 'time': '3:30AM - 5:00AM'},
    {'eventName': 'John’s Birthday', 'time': '3:30AM - 5:00AM'},
    {'eventName': 'Football Match', 'time': '3:30AM - 5:00AM'},
    {'eventName': 'John’s Birthday', 'time': '3:30AM - 5:00AM'},
    {'eventName': 'Football Match', 'time': '3:30AM - 5:00AM'},
    {'eventName': 'John’s Birthday', 'time': '3:30AM - 5:00AM'},
    {'eventName': 'Football Match', 'time': '3:30AM - 5:00AM'},
    {'eventName': 'John’s Birthday', 'time': '3:30AM - 5:00AM'},
    {'eventName': 'Football Match', 'time': '3:30AM - 5:00AM'},
  ];


  final EventController _eventController = Get.find<EventController>();



  @override
  void initState() {
    _eventController.eventGet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    debugPrint('++++++++++++++++++++ date ${DateTime.now().toString()}');
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Calender', borderColor: AppColors.secondaryColor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                // color: Colors.red,
              ),
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(1990),
                lastDate: DateTime(2050),
                onDateChanged: (selectedDate) {
        
                },
              ),
            ),
            Text('Events', style: TextStyle(fontSize: 18.sp)),
            SizedBox(height: 15.h),
            GetBuilder<EventController>(
              builder: (controller) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.eventData.length,
                  itemBuilder: (context, index) {
                    final eventData = controller.eventData[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 5.h
                      ),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.w,
                            color: Colors.black.withOpacity(0.1)
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
                             '${eventData.startTime} - ${eventData.startTime}',
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
              }
            ),
          ],
        ),
      ),
    );
  }
}
