import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/models/user_model/user_data_model.dart';

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
      await PrefsHelper.setString(
        AppConstants.bearerToken,
        responseBody['data']?['accessToken'] ?? '',
      );
      await PrefsHelper.setString(
        AppConstants.email,
        requestBody['email'] ?? '',
      );
      await PrefsHelper.setString(
        AppConstants.role,
        responseBody['role'] ?? '',
      );
      Get.toNamed(AppRoutes.otpScreen, arguments: {'role': 'sign_up'});
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

    final String email = await PrefsHelper.getString(AppConstants.email);

    bool success = false;

    final requestBody = {'email': email, 'otp': otpController.text.trim()};

    final response = await ApiClient.postData(ApiUrls.verifyOtp, requestBody);

    final responseBody = response.body;

    if (response.statusCode == 200) {
      success = true;
      await PrefsHelper.setString(AppConstants.bearerToken, responseBody['data']?['accessToken'] ?? '');
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

    final requestBody = {'email': email, 'otp': otpController.text.trim()};

    final response = await ApiClient.postData(
      ApiUrls.resendVerifyOtp(email),
      requestBody,
      headers: {'Content-Type': 'application/json'},
    );
    final responseBody = response.body;

    if (response.statusCode == 200) {
      success = true;
      await PrefsHelper.setString(
        AppConstants.bearerToken,
        responseBody['data']?['token'] ?? '',
      );
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
  final TextEditingController loginEmailController = TextEditingController(
    text: kDebugMode ? 'cenocir522@etramay.com' : '',
  );
  final TextEditingController loginPasswordController = TextEditingController(
    text: kDebugMode ? '1qazxsw2' : '',
  );

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
      await PrefsHelper.setString(AppConstants.bearerToken, responseBody['data']['accessToken']);
      if (responseBody['data']['user']['isVerified'] == false) {
        Get.toNamed(AppRoutes.otpScreen, arguments: {'role': 'sign_up'});
      } else if (responseBody['data']['user']['isActive'] == true) {
        UserController().userData();
        Get.offAllNamed(AppRoutes.customBottomNavBar);
      } else {
        if (responseBody['data']['user']['role'] == 'professional') {
          Get.toNamed(AppRoutes.completeProfileProfessional);
        } else {
          Get.toNamed(AppRoutes.completeProfileParent);
        }
      }
      cleanFieldLogin();
    } else {
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

    final requestBody = {'email': forgotEmailController.text.trim()};

    final response = await ApiClient.postData(
      ApiUrls.forgetPassword,
      requestBody,
    );
    final responseBody = response.body;

    if (response.statusCode == 200) {
      await PrefsHelper.setString(
        AppConstants.email,
        forgotEmailController.text.trim(),
      );
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
  final TextEditingController newResetPasswordController =
      TextEditingController();

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
      ApiUrls.resetPassword,
      requestBody,
    );
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

  /// <======================= Log out related work are here  ===========================>

  void logOut() async {
    await PrefsHelper.remove(AppConstants.bearerToken);
    await PrefsHelper.remove('role');
    Get.offAllNamed(AppRoutes.loginScreen);
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
