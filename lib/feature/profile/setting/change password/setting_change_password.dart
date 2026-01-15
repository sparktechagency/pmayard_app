import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/auth/auth_controller.dart';

import '../../../../widgets/widgets.dart';

class SettingChangePassword extends StatefulWidget {
  const SettingChangePassword({super.key});

  @override
  State<SettingChangePassword> createState() => _SettingChangePasswordState();
}

class _SettingChangePasswordState extends State<SettingChangePassword> {
  final AuthController authController = Get.find<AuthController>();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Change Password',
        borderColor: AppColors.secondaryColor,
        backAction: (){
          authController.clearChangePasswordField();
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            spacing: 10.h,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              CustomTextField(
                labelText: 'Old Password',
                controller: authController.currentPasswordTEController,
                hintText: "Old Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (authController
                      .currentPasswordTEController
                      .text
                      .length <
                      8) {
                    return 'Password must be 8+ chars';
                  }
                  return null;
                },
              ),
              CustomTextField(
                labelText: 'New Password',
                controller: authController.newPasswordTEController,
                hintText: "New Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (authController
                      .newPasswordTEController
                      .text
                      .length <
                      8) {
                    return 'Password must be 8+ chars';
                  }
                  return null;
                },
              ),
              CustomTextField(
                labelText: 'Confirm Password',
                controller: authController.confirmPasswordTEController,
                hintText: "Confirm Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm password is required';
                  } else if (value != authController.newPasswordTEController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              SizedBox(height: 32.h),
              GetBuilder<AuthController>(
                builder: (controller) {
                  return CustomButton(
                    onPressed: _onChangePassword,
                    child: Center(
                      child: controller.isChangePassword
                          ? CustomLoader()
                          : Text('Update', style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                      ),),
                    ),
                  );
                },
              ),
              // CustomButton(
              //     label: "Update",
              //     onPressed: _onChangePassword,
              //     ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  void _onChangePassword() {
    if (!_globalKey.currentState!.validate()) return;
    authController.changePassword();
    // Get.offAllNamed(AppRoutes.resetPasswordSuccess);
  }
}
