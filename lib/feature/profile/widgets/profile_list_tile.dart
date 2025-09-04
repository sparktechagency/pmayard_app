import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import '../../../custom_assets/assets.gen.dart';
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
      verticalMargin: 12.h,
      horizontalMargin: 24.w,
      paddingHorizontal: 10.w ,
      paddingVertical: 8.h,
     border: Border(bottom: BorderSide(color: AppColors.secondaryColor)),
     // color: color ?? AppColors.textColor171717,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 12.w),
          Expanded(
            child: CustomText(
              text: title,
              textAlign: TextAlign.start,
              color: textColor ?? Color(0xff111111),
              fontSize: 16.sp,
            ),
          ),
          if (noIcon != true)
            Assets.icons.arrowRight.svg(),
        ],
      ),
    );
  }
}
