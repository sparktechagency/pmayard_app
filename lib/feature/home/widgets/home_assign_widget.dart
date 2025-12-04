import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pmayard_app/controllers/assigned/assigned_controller.dart';
import 'package:pmayard_app/feature/home/widgets/assigned_card_widget.dart';
import 'package:pmayard_app/widgets/custom_loader.dart';
import 'package:pmayard_app/widgets/custom_text.dart';

class HomeAssignWidget extends StatelessWidget {
  const HomeAssignWidget({
    super.key,
    required AssignedController assignedController,
    required this.role,
  }) : _assignedController = assignedController;

  final AssignedController _assignedController;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_assignedController.isLoadingAssigned.value) {
        return SizedBox(
          height: 180.h,
          child: Center(child: CustomLoader()),
        );
      }

      final assignedList = _assignedController.assignModel;

      if (assignedList.isEmpty) {
        return SizedBox(
          height: 180.h,
          child: Center(
            child: CustomText(
              text:
              'No assigned ${role == 'professional' ? 'parents' : 'professionals'} Datas',
              fontSize: 14.sp,
            ),
          ),
        );
      }
      return SizedBox(
        height: 180.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: assignedList.length,
          itemBuilder: (context, index) {

            final item = assignedList[index];

            String name = '';
            String imageUrl = '';
            String id = '';
            String chatId = '';
            String userRole = '';

            if (role == 'professional') {
              name = item.parent.name;
              imageUrl = item.parent.profileImage;
              id = item.parent.id;
              chatId = item.conversationId;
              userRole = 'Parent';

            } else if (role == 'parent'){
              name = item.professional.name;
              imageUrl = item.professional.profileImage;
              id = item.professional.id;
              chatId = item.conversationId;
              userRole = 'Professional';
            }

            return AssignedCardWidget(
              chatId: chatId,
              id: id,
              index: index,
              name: name,
              role: userRole,
              imageUrl: imageUrl,
              professionalId: item.parent.id,
            );
          },
        ),
      );
    });
  }
}