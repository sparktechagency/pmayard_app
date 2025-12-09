// Assign Code Related Modal
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/controllers/assigned/assigned_controller.dart';
import 'package:pmayard_app/widgets/custom_button.dart';
import 'package:pmayard_app/widgets/custom_loader.dart';
import 'package:pmayard_app/widgets/custom_text_field.dart';

void assignProfessionalPopupModal(BuildContext context ) {

  final AssignedController controller = Get.find<AssignedController>();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Container(
        padding: EdgeInsets.symmetric(
            vertical: 40.h
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: controller.professionalAssignController,
              hintText: 'Type Code',
            ),
            SizedBox(height: 20.h,),
            GetBuilder<AssignedController>(
              builder: (controller) {
                return controller.isLoadingVerify ? CustomLoader() : CustomButton(
                  onPressed: () {
                    controller.sessionVerify();
                  },
                  title: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    ),
  );
}