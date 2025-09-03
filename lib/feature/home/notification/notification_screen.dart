// import 'package:fitness_app/core/utils/app_colors.dart';
// import 'package:fitness_app/core/widgets/custom_container.dart';
// import 'package:fitness_app/core/widgets/custom_scaffold.dart';
// import 'package:fitness_app/core/widgets/custom_text.dart';
// import 'package:fitness_app/global/custom_assets/assets.gen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});
//
//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<NotificationScreen> {
//
//
//   final List<Map<String,dynamic>> _notifications = [
//     {
//       "title": "Your Plan is Ready!",
//       "message": "Your coach has assigned your meal and workout plans. Start now and achieve your goals!",
//       "timestamp": "16 minutes ago",
//       "type": "info",
//     },
//     {
//       "title": "Follow-Up Form Due Soon!",
//       "message": "Your cycle is ending soon! Please fill out the follow-up form to help us improve your next plan.",
//       "timestamp": "16 Jun, 2025",
//       "type": "reminder",
//     }
//   ];
//
//
//
//   bool isNotification = true;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       appBar: AppBar(title: Text('Notification')),
//       body: isNotification ? ListView.builder(
//         itemCount: _notifications.length,
//           itemBuilder: (context,index){
//         return CustomContainer(
//           horizontalPadding: 4.w,
//           linearColors: [
//             if(index == 0)...[
//               Color(0xff282828),
//               Color(0xff0E0E0E),
//             ],
//             Colors.transparent,
//             Colors.transparent,
//           ],
//           child: ListTile(
//             contentPadding: EdgeInsets.zero,
//             leading: Assets.icons.notificationIcon.svg(),
//             title: CustomText(
//               bottom: 4.h,
//               fontWeight: FontWeight.w500,
//               fontsize: 12.sp,
//               textAlign: TextAlign.start,
//               text: _notifications[index]['title'],),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText(
//                   fontsize: 10.sp,
//                   textAlign: TextAlign.start,
//                   text: _notifications[index]['message'],),
//                 CustomText(
//                   top: 4.h,
//                   color: AppColors.textColor4D4D4D,
//                   fontsize: 8.sp,
//                   textAlign: TextAlign.start,
//                   text: _notifications[index]['timestamp'],),
//               ],
//             ),
//           ),
//         );
//       }) : _buildEmptyScreenValue(),
//     );
//   }
//
//   Widget _buildEmptyScreenValue() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Assets.images.notification.image(
//           height: 200.h,
//           width: 200.h,
//         ),
//         CustomText(
//           top: 24.h,
//           text: 'There Are No Notifications Available',
//           fontsize: 22.sp,
//           fontWeight: FontWeight.w500,
//         ),
//         CustomText(
//           top: 16.h,
//           text:
//               'No notifications available at the moment, once it’s available, it will appear here.',
//           fontsize: 12.sp,
//           color: AppColors.textColor4D4D4D,
//         ),
//       ],
//     );
//   }
// }
