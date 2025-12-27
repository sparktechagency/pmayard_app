import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/services/api_urls.dart';
import '../../../app/utils/app_colors.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../../widgets/widgets.dart';
import '../widgets/app_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final AuthController _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Sign In'),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),
              AppLogo(
                showLogo: true,
                title: 'Welcome Back!',
                subtitle: 'Make sure that you already have an account.',
              ),
              SizedBox(height: 40.h),
              CustomTextField(
                labelText: 'Email',
                controller: _authController.loginEmailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                isEmail: true,
              ),
              CustomTextField(
                labelText: 'Password',
                controller: _authController.loginPasswordController,
                hintText: "Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (_authController.loginPasswordController.text.length < 6) {
                    return 'Password must be 8+ chars';
                  }
                  return null;
                },

              ),
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  onTap: () {
                    Get.toNamed(AppRoutes.forgotScreen);
                  },
                  text: "Forgot Password",
                ),
              ),
              SizedBox(height: 111.h),
              GetBuilder<AuthController>(
                builder: (controller) {
                  return controller.isLoadingLogin ? CustomLoader() : CustomButton(
                    label: "Sign In",
                    onPressed: _onSingUp,
                  );
                }
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Don’t have any account?  ",
                    fontSize: 14.sp,
                    color: AppColors.grayShade100,
                  ),
                  CustomText(
                    onTap: () {
                     Get.offAllNamed(AppRoutes.signUpScreen);
                    },
                    text: "Sign Up",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  void _onSingUp() {
    print(ApiUrls.baseUrl);
    if (!_globalKey.currentState!.validate()) return;
    _authController.login();
  }

}
