import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/widgets.dart';

void showUserData(BuildContext context, dynamic session, String userRole) {
  String name = '';
  String imageUrl = '';
  String? day;
  String? date;
  String? roleLabel = '';
  String? subject;

  // Assign data based on user role
  if (userRole == 'professional') {
    name = session.parent?.name ?? 'Unknown';
    imageUrl = '${ApiUrls.imageBaseUrl}${session.parent?.profileImage?.url ?? ''}';
    day = session.day;
    date = session.date;
    roleLabel = 'Parent';
    subject = session.subject;
  } else if (userRole == 'parent') {
    name = session.professional?.name ?? 'Unknown';
    imageUrl = '${ApiUrls.imageBaseUrl}${session.professional?.profileImage?.url ?? ''}';
    day = session.day;
    date = session.date;
    roleLabel = 'Professional';
    subject = session.subject;
  }

  // Safe Date Parsing
  DateTime? dateTime;
  if (date != null && date.isNotEmpty) {
    try {
      dateTime = DateTime.parse(date);
    } catch (e) {
      dateTime = null;
    }
  }

  // Format date and time
  final formattedDate = dateTime != null
      ? DateFormat('dd/MM/yy').format(dateTime)
      : '';
  final formattedTime = dateTime != null
      ? DateFormat('h:mm a').format(dateTime)
      : '';

  // Combine for subtitle
  final sessionSubtitle = (day != null && dateTime != null)
      ? '$formattedDate at $formattedTime'
      : 'Waiting';

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
            SizedBox(height: 16.h),
            if (imageUrl.isNotEmpty)
              Center(
                child: CustomNetworkImage(
                  backgroundColor: AppColors.grayShade100,
                  boxShape: BoxShape.circle,
                  imageUrl: (imageUrl.isNotEmpty)
                      ? imageUrl
                      : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                ),
              ),
            SizedBox(height: 16.h),
            Text(
              '$roleLabel Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(name, style: TextStyle(fontSize: 14)),
            SizedBox(height: 16.h),
            Text(
              'Subject',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(subject ?? 'N/A'),
            SizedBox(height: 16.h),
            Text(
              'Session Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(sessionSubtitle),
            SizedBox(height: 16.h),
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