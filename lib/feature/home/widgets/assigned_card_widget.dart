import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/widgets/widgets.dart';

class AssignedCardWidget extends StatelessWidget {
  const AssignedCardWidget({
    super.key,
    required this.index,
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.id,
    required this.chatId,
    required this.professionalId,
  });

  final String id, chatId, professionalId;
  final int index;
  final String name, role, imageUrl;

  @override
  Widget build(BuildContext context) {

    return CustomContainer(
      paddingVertical: 10.h,
      paddingHorizontal: 10.w,
      marginRight: 14.w,
      marginLeft: index == 0 ? 14.w : 0,
      marginTop: 8.h,
      marginBottom: 8.h,
      radiusAll: 8.r,
      height: 170.h,
      width: 170.w,
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          offset: Offset(0, 4),
          blurRadius: 4,
        ),
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageAvatar(image: imageUrl, radius: 26.r),
          SizedBox(height: 8.h),
          CustomText(text: name, fontWeight: FontWeight.w500, fontSize: 16.sp),
          CustomText(bottom: 8.h, text: role, color: AppColors.appGreyColor),

          Row(
            children: [
              Expanded(
                child: CustomButton(
                  height: 28.h,
                  fontSize: 10.sp,
                  backgroundColor: AppColors.primaryColor,
                  onPressed: () {
                    Get.toNamed(
                      AppRoutes.profileViewScreen,
                      arguments: {'id': id, 'professionalId' : professionalId, 'role' : role},
                    );
                    debugPrint('schedule ID=================================$professionalId');
                    debugPrint('schedule ID=================================$id');
                  },
                  label: 'View Profile',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: CustomButton(
                  height: 28.h,
                  fontSize: 10.sp,
                  backgroundColor: AppColors.primaryColor,
                  onPressed: () {
                    Get.toNamed(
                      AppRoutes.inboxScreen,
                      arguments: {'chatId': chatId},
                    );
                  },
                  label: 'Message',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
