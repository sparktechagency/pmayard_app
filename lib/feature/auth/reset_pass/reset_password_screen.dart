import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/feature/auth/widgets/app_logo.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../../widgets/widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});


  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final AuthController _authController = Get.find<AuthController>();


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar:  CustomAppBar(title: 'Reset Password',),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),
              AppLogo(
                title: 'Reset Your Password.',
                subtitle: 'Password  must have 6-8 characters',
              ),


              SizedBox(height: 40.h),
              CustomTextField(
                controller: _authController.resetPasswordController,
                hintText: "New Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (_authController.resetPasswordController.text.length < 8) {
                    return 'Password must be 8+ chars';
                  }
                  return null;
                },
        
              ),
        
        
        
              SizedBox(height: 16.h),
        
              CustomTextField(
                controller: _authController.newResetPasswordController,
                hintText: "Confirm Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm password is required';
                  } else if (value != _authController.resetPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
        
              ),
        
        
              SizedBox(height: 36.h),
              GetBuilder<AuthController>(
                builder: (controller) {
                  return controller.isLoadingReset ? CustomLoader() : CustomButton(
                    label: "Reset",
                    onPressed: _onResetPassword,
                  );
                }
              ),


              SizedBox(height: 44.h),
        
            ],
          ),
        ),
      ),
    );
  }



  void _onResetPassword(){
    if(!_globalKey.currentState!.validate()) return;
    _authController.resetPassword();
  }

}
