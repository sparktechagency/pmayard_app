import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmayard_app/feature/home/notification/notification_card_widget.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Notification',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: ListView.separated(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: 15,
          itemBuilder: (context, index) => NotificationCardWidget(),
          separatorBuilder: (context, index) => SizedBox(height: 15.h),
        ),
      ),
    );
  }
}
