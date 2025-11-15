import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/helpers/prefs_helper.dart';
import '../../app/utils/app_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/api_client.dart';
import '../../services/api_urls.dart';
import '../../widgets/custom_tost_message.dart';

class AuthController extends GetxController {
  /// <======================= register ===========================>
  bool isLoadingRegister = false;
  bool isChecked = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    onChanged('professional');
  }

  void onChanged(value) {
    isChecked = !isChecked;
    update();
  }

  String selectedValueType = 'professional';


  void roleChange(type) {
    selectedValueType = type;
    update();
    debugPrint('======================? #### $selectedValueType');
  }

  void cleanFieldRegister() {
    emailController.clear();
    passwordController.clear();
    confirmPassController.clear();
  }

  Future<void> register() async {
    isLoadingRegister = true;
    update();

    final requestBody = {
      'email': emailController.text.trim(),
      'password': confirmPassController.text,
      'role': selectedValueType,
    };

    final response = await ApiClient.postData(
      ApiUrls.register,
      requestBody,
      headers: {'Content-Type': 'application/json'},
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      var responseBody = response.body;

      // Check if responseBody is not null and contains the expected data
      if (responseBody != null && responseBody['data'] != null) {
        await PrefsHelper.setString(AppConstants.bearerToken, responseBody['data']?['accessToken'] ?? '');
        await PrefsHelper.setString(AppConstants.email, requestBody['email']);
        await PrefsHelper.setString(AppConstants.role, responseBody['role'] ?? ''); // Make sure 'role' exists
        Get.toNamed(AppRoutes.otpScreen,arguments: {'role' : 'sign_up'});
        cleanFieldRegister();
      } else {
        // Handle unexpected response structure or missing data
        showToast('Unexpected response structure');
      }
    } else {
      showToast(responseBody['message']);
    }

    // if (response.statusCode == 200) {
    //   await PrefsHelper.setString(AppConstants.bearerToken, responseBody['data']?['accessToken'] ?? '');
    //   await PrefsHelper.setString(AppConstants.role, responseBody['role'] ?? '');
    //   // Get.toNamed(AppRoutes.completeProfileFirstPage);
    //   Get.toNamed(AppRoutes.otpScreen);
    //   cleanFieldRegister();
    // } else {
    //   showToast(responseBody['message']);
    // }
    isLoadingRegister = false;
    update();
  }

  /// <======================= verifyOTP ===========================>
  bool isLoadingOtp = false;
  final TextEditingController otpController = TextEditingController();

  Future<bool> verifyOTP() async {
    isLoadingOtp = true;
    update();

    final String email = await PrefsHelper.getString(AppConstants.email);


    bool success = false;

    final requestBody = {
      'email': email,
      'otp': otpController.text.trim(),
    };

    final response = await ApiClient.postData(ApiUrls.verifyOtp, requestBody);
    final responseBody = response.body;

    if (response.statusCode == 200) {
      success = true;
      //await PrefsHelper.setString(AppConstants.bearerToken, responseBody['data']?['token'] ?? '');
      showToast(responseBody['message']);
      otpController.clear();
      Get.toNamed(AppRoutes.loginScreen);
    } else {
      showToast(responseBody['message']);
    }

    isLoadingOtp = false;
    update();
    return success;
  }

  /// <================== Resend Otp ==========================>
  Future<bool> resentVerifyOTP() async {
    isLoadingOtp = true;
    update();

    final String email = await PrefsHelper.getString(AppConstants.email);

    bool success = false;

    final requestBody = {
      'email': email,
      'otp': otpController.text.trim(),
    };

    final response = await ApiClient.postData(
      ApiUrls.resendVerifyOtp(email), requestBody,
      headers: {'Content-Type': 'application/json'},);
    final responseBody = response.body;

    if (response.statusCode == 200) {
      success = true;
      //await PrefsHelper.setString(AppConstants.bearerToken, responseBody['data']?['token'] ?? '');
      showToast(responseBody['message']);
      otpController.clear();
      Get.toNamed(AppRoutes.loginScreen);
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
      await PrefsHelper.setString(
          AppConstants.bearerToken, responseBody['data']?['accessToken'] ?? '');
      await PrefsHelper.setString(
          AppConstants.role, responseBody['data']?['role'] ?? '');
      Get.toNamed(AppRoutes.completeProfileFirstPage);

      //cleanFieldLogin();
    } else {
      if ((response.statusCode == 403 || response.statusCode == 400) &&
          ((responseBody['message']?.toString().toLowerCase() ==
              "you are not verified".toLowerCase()) ||
              (responseBody['message']?.toString().toLowerCase() ==
                  "the same user already exists".toLowerCase()))) {
        print("Maruf");
        Get.toNamed(AppRoutes.otpScreen, arguments: {'role': 'sign_up'});
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

    final response = await ApiClient.postData(
        ApiUrls.forgetPassword, requestBody);
    final responseBody = response.body;

    if (response.statusCode == 200) {
      await PrefsHelper.setString(
          AppConstants.email, forgotEmailController.text.trim());
      Get.toNamed(AppRoutes.otpScreen, arguments: {'role': 'forgot'});
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
    resetPasswordController.clear();
    newResetPasswordController.clear();
  }

  Future<void> resetPassword() async {
    isLoadingReset = true;
    update();

    final String email = await PrefsHelper.getString(AppConstants.email);

    final requestBody = {
      'email': email,
      'newPassword': newResetPasswordController.text.trim(),
    };

    final response = await ApiClient.postData(
        ApiUrls.resetPassword, requestBody);
    final responseBody = response.body;

    if (response.statusCode == 200) {
      Get.offAllNamed(AppRoutes.loginScreen);
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
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    otpController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    forgotEmailController.dispose();
    resetPasswordController.dispose();
    newResetPasswordController.dispose();
    super.onClose();
  }
}
