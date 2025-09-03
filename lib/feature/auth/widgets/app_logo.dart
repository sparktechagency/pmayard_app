import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/utils/app_colors.dart';
import '../../../widgets/widgets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.title,
    this.subtitle,
    this.height = 41,
    this.spacing,
  });

  final String? title, subtitle;
  final double height;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Assets.icons.logo.svg(height: height.h),
        SizedBox(height: spacing ?? 30.h),
        if (title != null) ...[
          CustomText(
            text: title ?? '',
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 6.h),
        ],

        if (subtitle != null)
          CustomText(
            text: subtitle ?? '',
            fontSize: 12.sp,
           // color: AppColors.textColor4D4D4D,
          ),
      ],
    );
  }
}
