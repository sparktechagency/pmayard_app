// Show User Data via Model
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pmayard_app/widgets/custom_button.dart';

void showUserData(BuildContext context, dynamic sessionData, String userRole) {
  String name = '';
  String imageUrl = '';
  String? day;
  String? date;
  String? role = '';
  String? subject;
  if (userRole == 'professional') {
    name = sessionData.parent?.name ?? 'Unknown';
    imageUrl = sessionData.parent?.profileImage ?? '';
    day = sessionData.day;
    date = sessionData.date;
    role = 'Professional';
    subject = sessionData.subject;
  } else if (userRole == 'parent') {
    name = sessionData.professional?.name ?? 'Unknown';
    imageUrl = sessionData.professional?.profileImage ?? '';
    day = sessionData.day;
    date = sessionData.date;
    role = 'Parent';
    subject = sessionData.subject;
  }
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'View Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            if (imageUrl.isNotEmpty)
              Center(
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
            SizedBox(height: 16.h),
            Text(
              '$role Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            // Name
            Text(name, style: TextStyle(fontSize: 14)),
            SizedBox(height: 16.h),
            Text(
              'Subjects',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text('$subject'),
            SizedBox(height: 16.h),
            Text(
              'Session Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            if (day != null && date != null)
              Text(
                '${DateFormat('M/d/yyyy').format(DateTime.parse(date.toString()))} at ${DateFormat('h:mm a').format(DateTime.parse(date.toString()))}',
              ),
            SizedBox(height: 16.h),
            // Close button
            CustomButton(
              onPressed: () => Navigator.pop(context),
              title: Text(
                'Close',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
