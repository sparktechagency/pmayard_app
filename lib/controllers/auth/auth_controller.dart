import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/helpers/prefs_helper.dart';
import '../../app/utils/app_constants.dart';
import '../../services/api_client.dart';
import '../../services/api_urls.dart';
import '../../widgets/custom_tost_message.dart';

class AuthController extends GetxController {
  /// <======================= register ===========================>
  bool isLoadingRegister = false;
  bool isChecked = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void onChanged(value) {
    isChecked = !isChecked;
    update();
  }

  void cleanFieldRegister() {
    usernameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPassController.clear();
  }

  Future<void> register() async {
    isLoadingRegister = true;
    update();

    final requestBody = {
      'name': usernameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'password': confirmPassController.text,
    };

    final response = await ApiClient.postData(
      ApiUrls.register,
      requestBody,
      headers: {'Content-Type': 'application/json'},
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      await PrefsHelper.setString(AppConstants.bearerToken, responseBody['data']?['token'] ?? '');
      //Get.toNamed(AppRoutes.otpScreen, arguments: {'role': 'sign_up'});
      showToast(responseBody['message']);
      cleanFieldRegister();
    } else {
      showToast(responseBody['message']);
    }
    isLoadingRegister = false;
    update();
  }

  /// <======================= verifyOTP ===========================>
  bool isLoadingOtp = false;
  final TextEditingController otpController = TextEditingController();

  Future<bool> verifyOTP() async {
    isLoadingOtp = true;
    update();

    bool success = false;

    final requestBody = {
      'otp': otpController.text.trim(),
    };

    final response = await ApiClient.postData('', requestBody);
    final responseBody = response.body;

    if (response.statusCode == 201) {
      success = true;
      await PrefsHelper.setString(AppConstants.bearerToken, responseBody['data']?['token'] ?? '');
      showToast(responseBody['message']);
      otpController.clear();
    } else {
      showToast(responseBody['message']);
    }

    isLoadingOtp = false;
    update();
    return success;
  }

  /// <======================= login ===========================>
  bool isLoadingLogin = false;
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  void cleanFieldLogin() {
    loginEmailController.clear();
    loginPasswordController.clear();
  }

  Future<void> login() async {
    isLoadingLogin = true;
    update();

    final requestBody = {
      'email': loginEmailController.text.trim(),
      'password': loginPasswordController.text,
    };

    final response = await ApiClient.postData(ApiUrls.login, requestBody);
    final responseBody = response.body;

    if (response.statusCode == 200) {
      await PrefsHelper.setString(AppConstants.bearerToken, responseBody['data']?['token'] ?? '');
      //Get.offAllNamed(AppRoutes.paymentRequiredScreen);
      cleanFieldLogin();
    } else {
      if(responseBody['message'] == "We've sent an OTP to your email to verify your profile."){
       // Get.toNamed(AppRoutes.otpScreen, arguments: {'role': 'sign_up'});
      }
      showToast(responseBody['message']);
    }

    isLoadingLogin = false;
    update();
  }

  /// <======================= forgot ===========================>
  bool isLoadingForgot = false;
  final TextEditingController forgotEmailController = TextEditingController();

  void cleanFieldForgot() {
    forgotEmailController.clear();
  }

  Future<void> forgot() async {
    isLoadingForgot = true;
    update();

    final requestBody = {
      'email': forgotEmailController.text.trim(),
    };

    final response = await ApiClient.postData(ApiUrls.forgetPassword, requestBody);
    final responseBody = response.body;

    if (response.statusCode == 200) {
      await PrefsHelper.setString(AppConstants.bearerToken, responseBody['data']?['token'] ?? '');
    //  Get.toNamed(AppRoutes.otpScreen, arguments: {'role': 'forgot'});
      showToast(responseBody['message']);
      cleanFieldForgot();
    } else {
      showToast(responseBody['message']);
    }

    isLoadingForgot = false;
    update();
  }

  /// <======================= reset Password ===========================>
  bool isLoadingReset = false;
  final TextEditingController resetPasswordController = TextEditingController();
  final TextEditingController newResetPasswordController = TextEditingController();

  void cleanFieldReset() {
    newResetPasswordController.clear();
  }

  Future<void> resetPassword() async {
    isLoadingReset = true;
    update();

    final requestBody = {
      'password': newResetPasswordController.text.trim(),
    };

    final response = await ApiClient.postData(ApiUrls.resetPassword, requestBody);
    final responseBody = response.body;

    if (response.statusCode == 200) {
     // Get.offAllNamed(AppRoutes.resetPasswordSuccess);
      showToast(responseBody['message']);
      cleanFieldReset();
    } else {
      showToast(responseBody['message']);
    }

    isLoadingReset = false;
    update();
  }

  /// <======================= dispose all controllers ===========================>
  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    phoneController.dispose();
    otpController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    forgotEmailController.dispose();
    resetPasswordController.dispose();
    newResetPasswordController.dispose();
    super.onClose();
  }
}
