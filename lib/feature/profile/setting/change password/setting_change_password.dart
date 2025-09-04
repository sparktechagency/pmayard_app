import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';

import '../../../../widgets/widgets.dart';


class SettingChangePassword extends StatefulWidget {
  const SettingChangePassword({super.key});

  @override
  State<SettingChangePassword> createState() => _SettingChangePasswordState();
}

class _SettingChangePasswordState extends State<SettingChangePassword> {


  final TextEditingController _oldPassTEController = TextEditingController();
  final TextEditingController _passTEController = TextEditingController();
  final TextEditingController _rePassTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Change Password',
        borderColor: AppColors.secondaryColor,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            spacing: 10.h,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50.h,
              ),
              CustomTextField(
                labelText: 'Old Password',
                controller: _oldPassTEController,
                hintText: "Old Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (_oldPassTEController.text.length < 8) {
                    return 'Password must be 8+ chars';
                  }
                  return null;
                },
              ),
              CustomTextField(
                labelText: 'New Password',
                controller: _passTEController,
                hintText: "New Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (_passTEController.text.length < 8) {
                    return 'Password must be 8+ chars';
                  }
                  return null;
                },
              ),
              CustomTextField(
                labelText: 'Confirm Password',
                controller: _rePassTEController,
                hintText: "Confirm Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm password is required';
                  } else if (value != _passTEController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

        SizedBox(height: 32.h,),
              CustomButton(
                  label: "Update",
                  onPressed: _onChangePassword,
                  ),
              SizedBox(
                height:32.h,
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _onChangePassword(){
    if(!_globalKey.currentState!.validate()) return;
   // Get.offAllNamed(AppRoutes.resetPasswordSuccess);
  }


  @override
  void dispose() {
    _oldPassTEController.dispose();
    _passTEController.dispose();
    _rePassTEController.dispose();
    super.dispose();
  }
}
