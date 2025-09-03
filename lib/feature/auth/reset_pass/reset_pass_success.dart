import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../widgets/widgets.dart';
import '../widgets/app_logo.dart';

class ResetPassSuccess extends StatefulWidget {
  const ResetPassSuccess({super.key});

  @override
  State<ResetPassSuccess> createState() => _ResetPassSuccessState();
}

class _ResetPassSuccessState extends State<ResetPassSuccess> {

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppLogo(),
            SizedBox(height: 24.h),
            //Assets.icons.success.svg(),
            SizedBox(height: 44.h),
            CustomText(
              text: 'Password Changed!',
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              top: 6.h,
              text: 'Your password has been changed successfully.',
              fontSize: 12.sp,
             // color: AppColors.textColor4D4D4D,
            ),
            SizedBox(height: 56.h),
            CustomButton(
              label: "Back to Login",
              onPressed: () {},
            ),
            SizedBox(height: 18.h),
          ],
        ),
      ),
    );
  }
}
