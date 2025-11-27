import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pmayard_app/app/helpers/menu_show_helper.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/profile_confirm_controller.dart';
import 'package:pmayard_app/custom_assets/assets.gen.dart';
import 'package:pmayard_app/custom_assets/fonts.gen.dart';
import 'package:pmayard_app/widgets/widgets.dart';

class CompleteProfileParent extends StatefulWidget {
  const CompleteProfileParent({super.key});

  @override
  State<CompleteProfileParent> createState() => _CompleteProfileParentState();
}

class _CompleteProfileParentState extends State<CompleteProfileParent> {
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
                      fileImage: controller.profileParent,
                      radius: 60.r,
                    ),

                    Positioned(
                      bottom: 12.h,
                      right: 6.w,
                      child: GestureDetector(
                        onTap: () =>
                            controller.onTapImageParentSelected(context),
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
                    controller: profileController.nameParentController,
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
                    selectorTextStyle: TextStyle(fontSize: 12.sp),
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DROPDOWN,
                      setSelectorButtonAsPrefixIcon: true,
                      leadingPadding: 0,
                      trailingSpace: false,
                    ),
                    onInputChanged: (PhoneNumber num) {},
                    cursorColor: Colors.black,
                    textFieldController:
                        profileController.numberParentController,
                    initialValue: number,
                    formatInput: true,
                    inputDecoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: AppColors.appGreyColor,
                        fontSize: 12.sp,
                        fontFamily: FontFamily.inter,
                      ),
                      hintText: "enter your phone no.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: AppColors.grayShade100.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    selectorButtonOnErrorPadding: 0,
                    spaceBetweenSelectorAndTextField: 0,
                  ),

                  SizedBox(height: 8.h),
                  CustomTextField(
                    labelText: 'Child’s Name',
                    controller: profileController.childNameController,
                    hintText: "enter child’s name",
                  ),
                  SizedBox(height: 8.h),

                  GestureDetector(
                    onTapDown: (details) async {
                      final options = [
                        'First',
                        'Second',
                        'Third',
                        'Fourth',
                        'Fifth',
                        'Sixth',
                        'Seventh',
                        'Eighth',
                        'Ninth',
                        'Tenth',
                      ];
                      final selected = await MenuShowHelper.showCustomMenu(
                        context: context,
                        details: details,
                        options: options,
                      );

                      if (selected != null) {
                        profileController.childGradeController.text = selected;
                      }
                    },
                    child: AbsorbPointer(
                      child: CustomTextField(
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        readOnly: true,
                        labelText: 'Child’s Grade',
                        controller: profileController.childGradeController,
                        hintText: "enter child’s grade",
                      ),
                    ),
                  ),

                  SizedBox(height: 8.h),
                  CustomTextField(
                    labelText: 'Relationship with Child',
                    controller: profileController.relationshipController,
                    hintText: "enter relationship with child",
                  ),

                  SizedBox(height: 20.h),
                  GetBuilder<ProfileConfirmController>(
                    builder: (controller) {
                      return controller.isLoadingParent
                          ? CustomLoader()
                          : CustomButton(
                              label: "Next",
                              onPressed: () {
                                if (!_globalKey.currentState!.validate())
                                  return;
                                controller.profileConfirmParent();
                              },
                            );
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
}
