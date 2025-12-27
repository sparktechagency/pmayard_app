import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pmayard_app/app/helpers/menu_show_helper.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/profile_confirm_controller.dart';
import 'package:pmayard_app/custom_assets/assets.gen.dart';
import 'package:pmayard_app/custom_assets/fonts.gen.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/widgets/widgets.dart';

class CompleteProfileProfessional extends StatefulWidget {
  const CompleteProfileProfessional({super.key});

  @override
  State<CompleteProfileProfessional> createState() =>
      _CompleteProfileProfessionalState();
}

class _CompleteProfileProfessionalState
    extends State<CompleteProfileProfessional> {
  final ProfileConfirmController profileController =
  Get.find<ProfileConfirmController>();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  PhoneNumber number = PhoneNumber(isoCode: 'US');

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Complete Your Profile'),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            GetBuilder<ProfileConfirmController>(
              builder: (controller) {
                return Stack(
                  children: [
                    CustomImageAvatar(
                      fileImage: controller.profileProfessional,
                      radius: 60.r,
                    ),

                    Positioned(
                      bottom: 12.h,
                      right: 6.w,
                      child: GestureDetector(
                        onTap: () =>
                            controller
                                .onTapProfileProfessionalSelected(context),
                        child: Assets.icons.profileCamera.svg(),
                      ),
                    ),
                  ],
                );
              },
            ),
            CustomText(
              text: 'Upload Photo',
              color: AppColors.secondaryColor,
              fontSize: 12.sp,
              top: 4.h,
            ),
            Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.h),
                  CustomTextField(
                    labelText: 'Name',
                    controller: profileController.nameController,
                    hintText: "Enter Name",
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: 'Phone',
                      color: AppColors.darkColor,
                      bottom: 4.h,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber num) {},
                    textStyle: TextStyle(
                      color: AppColors.appGreyColor,
                      fontSize: 12.sp,
                    ),
                    selectorTextStyle: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.appGreyColor
                    ),
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DROPDOWN,
                      setSelectorButtonAsPrefixIcon: true,
                      leadingPadding: 0,
                      trailingSpace: false,
                    ),
                    cursorColor: AppColors.appGreyColor,
                    textFieldController: profileController.numberController,
                    initialValue: number,
                    formatInput: true,
                    inputDecoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: AppColors.grayShade100,
                        fontSize: 12.sp,
                        fontFamily: FontFamily.inter,
                      ),
                      hintText: "Enter your phone no.",
                      focusedBorder: focusedBorder(),
                      enabledBorder: enabledBorder(),
                      errorBorder: errorBorder(),
                      border: focusedBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    selectorButtonOnErrorPadding: 0,
                    spaceBetweenSelectorAndTextField: 0,
                  ),

                  SizedBox(height: 8.h),

                  CustomTextField(
                    labelText: 'Bio',
                    controller: profileController.bioController,
                    hintText: "Enter Bio",
                  ),
                  CustomTextField(
                    labelText: 'Qualification',
                    controller: profileController.qualificationController,
                    hintText: "Enter qualification",
                  ),

                  SizedBox(height: 8.h),

                  GestureDetector(
                    onTapDown: (TapDownDetails details) async {
                      final currentSubjects = profileController
                          .subjectsController
                          .text
                          .split(", ")
                          .where((s) => s.isNotEmpty)

                          .toList();
                      final selectedList =
                      await MenuShowHelper.showMultiSelectMenu(
                        context: context,
                        details: details,
                        options: MenuShowHelper.subjects,
                        preSelectedItems: currentSubjects,
                      );

                      if (selectedList != null) {
                        profileController.subjectsController.text = selectedList
                            .join(", ");

                        profileController.subjectList
                          ..clear()
                          ..addAll(selectedList);
                      }
                    },
                    child: AbsorbPointer(
                      child: CustomTextField(
                        suffixIcon: Icon(Icons.keyboard_arrow_down),
                        readOnly: true,
                        labelText: 'Subjects You Teach',
                        controller: profileController.subjectsController,
                        hintText: "Subjects You Teach",
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                  CustomButton(
                    label: "Next",
                    onPressed: () {
                      if (!_globalKey.currentState!.validate()) return;
                      Get.toNamed(AppRoutes.scheduleScreen);
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        width: 0.8,
        color: AppColors.grayShade100,
      ),
    );
  }

  OutlineInputBorder enabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        width: 1,
        color: AppColors.grayShade100,
      ),
    );
  }

  OutlineInputBorder errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular( 8.r),
      borderSide: BorderSide(color:Colors.red, width: 1),
    );
  }

}
