import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../app/utils/app_colors.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../../widgets/widgets.dart';
import '../widgets/app_logo.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();



  final AuthController _registerController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppLogo(
                title: 'Hello! Register to get started',
                subtitle: 'Make sure your account keep secure',
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                prefixIcon: Icon(Icons.person, color: Colors.white),
                controller: _registerController.usernameController,
                hintText: "User Name",
                keyboardType: TextInputType.text,
              ),
              CustomTextField(
                prefixIcon: Icon(Icons.email_sharp, color: Colors.white),
                controller: _registerController.emailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                isEmail: true,
              ),
              CustomTextField(
                prefixIcon: Icon(Icons.phone, color: Colors.white),
                controller: _registerController.phoneController,
                hintText: "Phone",
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                controller: _registerController.passwordController,
                hintText: "Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (_registerController.passwordController.text.length < 8) {
                    return 'Password must be 8+ chars';
                  }
                  return null;
                },
              ),
              CustomTextField(
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                controller: _registerController.confirmPassController,
                hintText: "Confirm Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm password is required';
                  } else if (value != _registerController.passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  GetBuilder<AuthController>(
                    builder: (controller) {
                      return Checkbox(
                        value: controller.isChecked,
                        onChanged: (value) => controller.onChanged(value),
                        activeColor: AppColors.primaryColor,
                      );
                    }
                  ),
                  CustomText(
                    text: "I accept the Terms & Conditions & Privacy Policy",
                    fontSize: 11.sp,
                   // color: AppColors.textColor4D4D4D,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              GetBuilder<AuthController>(
                builder: (controller) {
                  return controller.isLoadingRegister ? CustomLoader() : CustomButton(label: "Sign Up", onPressed: _onSignUp);
                }
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Already have an account?  ",
                    fontSize: 16.sp,
                  ),
                  CustomText(
                    onTap: () {
                     // Get.offAllNamed(AppRoutes.loginScreen);
                    },
                    text: "Sign In",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
              SizedBox(height: 6.h),
            ],
          ),
        ),
      ),
    );
  }
  void _onSignUp() {
    if (!_globalKey.currentState!.validate()) return;
    if (!_registerController.isChecked) {
      showToast('Please check the privacy policy');
      return;
    }
    //_registerController.register();
  }



}
