import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pmayard_app/app/helpers/menu_show_helper.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/profile_confirm_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
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
  bool isProfileEmpty = false;

  // Add FocusNode for phone number field
  final FocusNode phoneFocusNode = FocusNode();
  bool hasPhoneBlurred = false;

  @override
  void initState() {
    super.initState();
    // Listen to focus changes
    phoneFocusNode.addListener(() {
      if (!phoneFocusNode.hasFocus) {
        setState(() {
          hasPhoneBlurred = true;
        });
      }
    });
  }

  @override
  void dispose() {
    phoneFocusNode.dispose();
    super.dispose();
  }

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
                return Column(
                  children: [
                    Stack(
                      children: [
                        CustomImageAvatar(
                          fileImage: controller.profileParent,
                          radius: 60.r,
                        ),
                        Positioned(
                          bottom: 12.h,
                          right: 6.w,
                          child: GestureDetector(
                            onTap: () {
                              controller.onTapImageParentSelected(context);
                              setState(() {
                                isProfileEmpty = false;
                              });
                            },
                            child: Assets.icons.profileCamera.svg(),
                          ),
                        ),
                      ],
                    ),
                    if (isProfileEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          'Please Set your Profile',
                          style: TextStyle(
                            color: AppColors.errorColor,
                            fontSize: 12.sp,
                          ),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
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
                  GetBuilder<ProfileConfirmController>(
                    builder: (controller) {
                      return InternationalPhoneNumberInput(
                        focusNode: phoneFocusNode,
                        textStyle: TextStyle(
                          color: AppColors.appGreyColor,
                          fontSize: 12.sp,
                        ),
                        selectorTextStyle: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.appGreyColor,
                        ),
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.DROPDOWN,
                          setSelectorButtonAsPrefixIcon: true,
                          leadingPadding: 0,
                          trailingSpace: false,
                        ),
                        onInputChanged: (PhoneNumber num) {
                          controller.updatePhoneNumberParent(num);
                        },
                        onInputValidated: (bool isValid) {
                          controller.updatePhoneValidationParent(isValid);
                        },
                        cursorColor: AppColors.appGreyColor,
                        textFieldController:
                        profileController.numberParentController,
                        initialValue: number,
                        formatInput: true,
                        inputDecoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: AppColors.grayShade100,
                            fontSize: 12.sp,
                            fontFamily: FontFamily.inter,
                          ),
                          hintText: "Enter your phone no.",
                          focusedBorder: controller.isPhoneValidParent == true
                              ? focusedBorder()
                              : errorBorder(),
                          enabledBorder: hasPhoneBlurred &&
                              !controller.isPhoneValidParent.value
                              ? errorBorder()
                              : enabledBorder(),
                          errorBorder: errorBorder(),
                          border: focusedBorder(),
                          focusedErrorBorder: errorBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        selectorButtonOnErrorPadding: 0,
                        spaceBetweenSelectorAndTextField: 0,
                      );
                    },
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    labelText: "Child's Name",
                    controller: profileController.childNameController,
                    hintText: "enter child's name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter child's name";
                      }
                      return null;
                    },
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
                        setState(() {});
                      }
                    },
                    child: AbsorbPointer(
                      child: CustomTextField(
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        readOnly: true,
                        labelText: "Child's Grade",
                        controller: profileController.childGradeController,
                        hintText: "enter child's grade",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select child's grade";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    labelText: 'Relationship with Child',
                    controller: profileController.relationshipController,
                    hintText: "enter relationship with child",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter relationship with child';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  GetBuilder<ProfileConfirmController>(
                    builder: (controller) {
                      if (controller.isLoadingParent) {
                        return CustomLoader();
                      }

                      bool canSubmit = controller.profileParent != null &&
                          controller.isPhoneValidParent.value &&
                          controller.nameParentController.text.isNotEmpty &&
                          controller.childNameController.text.isNotEmpty &&
                          controller.childGradeController.text.isNotEmpty &&
                          controller.relationshipController.text.isNotEmpty;

                      return Opacity(
                        opacity: canSubmit ? 1.0 : 0.6,
                        child: CustomButton(
                          label: Get.find<UserController>().user?.role ==
                              'parent'
                              ? 'Save & Continue'
                              : "Next",
                          onPressed: () {
                            // Check profile image first
                            if (controller.profileParent == null) {
                              setState(() {
                                isProfileEmpty = true;
                              });
                              return;
                            }

                            // Check phone validation
                            if (!controller.isPhoneValidParent.value) {
                              setState(() {
                                hasPhoneBlurred = true;
                              });
                              return;
                            }

                            // Validate form
                            if (!_globalKey.currentState!.validate()) {
                              return;
                            }

                            // All validations passed, submit
                            controller.profileConfirmParent();
                          },
                        ),
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

  OutlineInputBorder focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(width: 0.8, color: AppColors.grayShade100),
    );
  }

  OutlineInputBorder enabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(width: 1, color: AppColors.grayShade100),
    );
  }

  OutlineInputBorder errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: Colors.red, width: 1),
    );
  }
}