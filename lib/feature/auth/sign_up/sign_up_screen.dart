import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/routes/app_routes.dart';
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
      appBar: CustomAppBar(title: 'Sign Up'),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.h),
              AppLogo(
                showLogo: true,
                title: 'Join With Us!',
                subtitle: 'Make sure your account keep secure.',
              ),

              SizedBox(height: 24.h),
              CustomContainer(
                height: 29.h,
                radiusAll: 16.r,
                width: 320.w,
                bordersColor: AppColors.goldColor,
                child: GetBuilder<AuthController>(
                  builder: (controller) {
                    return Row(
                      children: ["professional", "parent"].map((type) {
                        final isSelected = controller.selectedValueType == type;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => controller.roleChange(type),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.goldColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              alignment: Alignment.center,
                              child: CustomText(
                                text: type == "professional"
                                    ? "Professional"
                                    : "Parent",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.goldColor,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                labelText: 'Email',
                controller: _registerController.emailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                isEmail: true,
              ),
              CustomTextField(
                labelText: 'Password',
                controller: _registerController.passwordController,
                hintText: "Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (_registerController
                          .passwordController
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GetBuilder<AuthController>(
                    builder: (controller) {
                      return Checkbox(
                        value: controller.isChecked,
                        onChanged: (value) => controller.onChanged(value),
                        activeColor: AppColors.secondaryColor,
                      );
                    },
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.bgColor,
                          ),
                          children: [
                            TextSpan(
                              text: 'I agree with ',
                              style: TextStyle(color: Color(0xff474747)),
                            ),
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.termsPrivacyColor,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.toNamed(AppRoutes.legalScreen,arguments: {'title': 'Terms & Conditions'}),
                            ),
                            TextSpan(
                              text: ' & ',
                              style: TextStyle(color: Color(0xff474747)),
                            ),
                            TextSpan(
                              text: 'Privacy Policy.',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.termsPrivacyColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.toNamed(AppRoutes.legalScreen,arguments: {'title': 'Privacy Policy'}),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // CustomText(
                  //   text: "I accept the Terms & Conditions & Privacy Policy",
                  //   fontSize: 11.sp,
                  //   // color: AppColors.textColor4D4D4D,
                  // ),
                ],
              ),
              SizedBox(height: 16.h),
              GetBuilder<AuthController>(
                builder: (controller) {
                  return controller.isLoadingRegister
                      ? CustomLoader()
                      : CustomButton(label: "Sign Up", onPressed: _onSignUp);
                },
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    color: AppColors.grayShade100,
                    text: "Already have an account?  ",
                    fontSize: 14.sp,
                  ),
                  CustomText(
                    onTap: () {
                      Get.offAllNamed(AppRoutes.loginScreen);
                    },
                    text: "Sign In",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryColor,
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
    _registerController.register();
  }
}
