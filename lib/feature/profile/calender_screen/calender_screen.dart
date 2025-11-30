import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Calender', borderColor: Color(0XFF305CDE)),
      body: Column(
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
                print("Selected date: $selectedDate");
              },
            ),
          ),
          SizedBox(height: 30.h),
          Text('Events', style: TextStyle(fontSize: 18.sp)),
          SizedBox(height: 15.h),
          Flexible(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: storeEvents.map((e) {
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
                            e['eventName'] ?? '',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            e['time'] ?? '',
                            style: TextStyle(
                              fontSize: 12.h,
                              color: Color(0XFF5C5C5C),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 5.h),
              itemCount: storeEvents.length,
            ),
          ),
        ],
      ),
    );
  }
}
