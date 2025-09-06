import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmayard_app/custom_assets/assets.gen.dart';
import '../../../widgets/widgets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.title,
    this.subtitle,
    this.size = 62,
    this.spacing, this.showLogo = false,
  });

  final String? title, subtitle;
  final double size;
  final double? spacing;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if(showLogo)
        Assets.icons.splashLogo.svg(height: size.h,width: size.w),
        SizedBox(height: spacing ?? 20.h),
        if (title != null) ...[
          CustomText(
            text: title ?? '',
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 6.h),
        ],

        if (subtitle != null)
          CustomText(
            text: subtitle ?? '',
            fontSize: 12.sp,
           color: Color(0xff5C5C5C),
          ),
      ],
    );
  }
}
