import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/prefs_helper.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../../widgets/widgets.dart';
import '../widgets/app_logo.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final String role = Get.arguments['role'];
  final AuthController _authController = Get.find<AuthController>();

  // Time related work
  final controller = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.timerStart();
    });
  }
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Verify'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24.h),
            AppLogo(
              title: 'Enter Verification Code.',
              subtitle:
                  'Please enter the 6 digit verification code sent \n to your e-mail',
            ),
            SizedBox(height: 40.h),

            ///==============Pin code Field============<>>>>
            Form(
              key: _globalKey,
              child: CustomPinCodeTextField(
                textEditingController: _authController.otpController,
              ),
            ),

            GetBuilder<AuthController>(
              builder: (cnt) {
                return Visibility(
                  visible: cnt.flag,
                  replacement: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('Didn\'t get the Code ?'),
                        TextButton(
                          onPressed: (){
                            _onTapResendButtonHandler();
                            controller.timerStart();
                          },
                          child: Text('Resend'),
                        ),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10.r),
                          child: Text(cnt.formatTime(cnt.myTime),textAlign: TextAlign.end,)
                      )
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 36.h),
            GetBuilder<AuthController>(
              builder: (controller) {
                return controller.isLoadingOtp
                    ? CustomLoader()
                    : CustomButton(
                        label: "Verify",
                        onPressed: _onTapNextScreen,
                      );
              },
            ),

            SizedBox(height: 18.h),
          ],
        ),
      ),
    );
  }

  void _onTapNextScreen() async {
    if (!_globalKey.currentState!.validate()) return;
    final bool isSuccess = await _authController.verifyOTP();

    if (isSuccess) {
      if (role == 'sign_up') {
        Get.offAllNamed(AppRoutes.loginScreen);
      }
      else {
        Get.toNamed(AppRoutes.resetPasswordScreen);
      }
    }
  }

  void _onTapResendButtonHandler() {
    _authController.resentVerifyOTP();
  }
}
