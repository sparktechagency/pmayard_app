import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationCardWidget extends StatelessWidget {
  const NotificationCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.notifications, color: Color(0XFF305CDE)),
          Text(
            'New tutor just got assigned to you',
            style: TextStyle(color: Color(0XFF333333), fontSize: 12.sp),
          ),
          Text(
            '4:30 PM ',
            style: TextStyle(color: Color(0XFF767676), fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
