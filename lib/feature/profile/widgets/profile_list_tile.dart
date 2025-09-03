import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/widgets.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile(
      {super.key,
      this.color,
      this.textColor,
      this.noIcon,
      required this.title,
      required this.onTap, required this.icon});

  final Color? color;
  final Color? textColor;
  final bool? noIcon;
  final String title;
  final VoidCallback onTap;
   final Widget icon;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: onTap,
      verticalMargin: 7.h,
      paddingHorizontal: 16.w ,
      paddingVertical: 10.h,
     // color: color ?? AppColors.textColor171717,
      radiusAll: 12.r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 12.w),
          Expanded(
            child: CustomText(
              text: title,
              textAlign: TextAlign.start,
              color: textColor ?? Colors.white,
              fontSize: 14.sp,
            ),
          ),
          if (noIcon != true)
            Icon(
              Icons.arrow_right,
              size: 20.h,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}
