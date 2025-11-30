import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../../widgets/widgets.dart';
import '../widgets/app_logo.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final AuthController _authController = Get.find<AuthController>();



  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar:  CustomAppBar(title: 'Forget Password',),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),
              AppLogo(
                title: 'Forget Your Password?',
                subtitle: 'Don’t worry! It happens. Please enter the email associated with your account.',
              ),
              SizedBox(height: 40.h),
              CustomTextField(
                labelText: 'Email',
                controller: _authController.forgotEmailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                isEmail: true,
              ),
              SizedBox(height: 36.h),
              GetBuilder<AuthController>(
                builder: (controller) {
                  return controller.isLoadingForgot ? CustomLoader() : CustomButton(
                    label: "Get Verification Code",
                    onPressed: _onGetVerificationCode,
                  );
                }
              ),

              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }


  void _onGetVerificationCode(){
    if(!_globalKey.currentState!.validate()) return;
    _authController.forgot();
  }

}
