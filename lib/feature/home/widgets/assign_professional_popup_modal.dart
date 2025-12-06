// Assign Code Related Modal
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmayard_app/widgets/custom_button.dart';
import 'package:pmayard_app/widgets/custom_text_field.dart';

void assignProfessionalPopupModal(BuildContext context ) {
  final TextEditingController professionalAssignController =
  TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Container(
        padding: EdgeInsets.symmetric(
            vertical: 40.h
        ),
        child: Column(
          children: [
            CustomTextField(
              controller: professionalAssignController,
              hintText: 'Type Code',
            ),
            SizedBox(height: 20.h,),
            CustomButton(
              onPressed: () {},
              title: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}