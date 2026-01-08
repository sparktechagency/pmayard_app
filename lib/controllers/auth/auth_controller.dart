import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/controllers/assigned/assigned_controller.dart';
import 'package:pmayard_app/controllers/sessions/sessions_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/feature/bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';
import 'package:pmayard_app/services/get_fcm_token.dart';
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

  int myTime = 180;
  bool flag = true;
  Timer? timer;

  String formatTime(int second) {
    final minutes = second ~/ 60;
    final remainingSeconds = second - minutes * 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void timerStart() {
    timer?.cancel();
    myTime = 180;
    flag = true;
    update();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer time) {
      myTime--;
      if (myTime == 0) {
        flag = false;
        time.cancel();
      }
      update();
    });
  }

  Future<bool> verifyOTP() async {
    isLoadingOtp = true;
    update();

    final String email = await PrefsHelper.getString(AppConstants.email);

    final requestBody = {'email': email, 'otp': otpController.text.trim()};

    final response = await ApiClient.postData(ApiUrls.verifyOtp, requestBody);
    final responseBody = response.body;
    bool success = false;

    if (response.statusCode == 200) {
      success = true;

      final String? token = responseBody['data']?['accessToken'];

      if (token != null && token.isNotEmpty) {
        await PrefsHelper.setString(AppConstants.bearerToken, token);
      }
      showToast(responseBody['message']);
    } else {
      showToast(responseBody['message']);
    }

    otpController.clear();
    isLoadingOtp = false;
    update();
    return success;
  }

  /// <================== Resend Otp ==========================>
  Future<void> resentVerifyOTP() async {
    isLoadingOtp = true;
    update();

    final String email = await PrefsHelper.getString(AppConstants.email);

    final response = await ApiClient.postData(
      ApiUrls.resendVerifyOtp(email),
      {},
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      showToast(responseBody['message']);
      otpController.clear();
    } else {
      showToast(responseBody['message']);
    }

    isLoadingOtp = false;
    update();
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
    String? fcmToken = await FirebaseNotificationService.getFCMToken();
    isLoadingLogin = true;
    update();

    final requestBody = {
      'email': loginEmailController.text.trim(),
      'password': loginPasswordController.text,
      'fcmToken' : fcmToken
    };

    try {
      final response = await ApiClient.postData(ApiUrls.login, requestBody);
      final responseBody = response.body;

      if (response.statusCode != 200) {
        showToast(responseBody?['message'] ?? 'Something went wrong');
        return;
      }

      final data = responseBody['data'] as Map<String, dynamic>?;

      if (data == null) {
        showToast('Invalid response from server');
        return;
      }

      final user = data['user'] as Map<String, dynamic>? ?? {};
      final dynamic rawToken = data['accessToken'];
      final String? accessToken = (rawToken is String && rawToken.isNotEmpty)
          ? rawToken
          : null;

      final bool isVerified = (user['isVerified'] is bool)
          ? user['isVerified']
          : false;
      final bool isActive = (user['isActive'] is bool)
          ? user['isActive']
          : false;
      final String role = (user['role'] is String)
          ? user['role']
          : (data['role'] ?? '');
      final String? roleId = (user['roleId'] is String) ? user['roleId'] : null;

      await PrefsHelper.setString(
        AppConstants.email,
        loginEmailController.text.trim(),
      );

      if (!isVerified || accessToken == null) {
        Get.toNamed(
          AppRoutes.otpScreen,
          arguments: {
            'email': user['email'] ?? loginEmailController.text.trim(),
            'userId': user['_id'],
            'role': 'sign_up',
          },
        );
        return;
      }

      // Save token only after verification check
      await PrefsHelper.setString(AppConstants.bearerToken, accessToken);

      await Get.find<UserController>().userData();

      if (!isActive && (roleId == null || roleId.isEmpty)) {
        if (role == 'professional') {
          Get.offAllNamed(AppRoutes.completeProfileProfessional);
        } else if (role == 'parent') {
          Get.offAllNamed(AppRoutes.completeProfileParent);
        }
      } else if (isActive && roleId != null && roleId.isNotEmpty) {
        await Get.find<UserController>().userData();
        Get.offAllNamed(AppRoutes.customBottomNavBar);
        Get.find<CustomBottomNavBarController>().onChange(0);
      }

      cleanFieldLogin();
    } catch (e, st) {
      debugPrint('Login error: $e\n$st');
      showToast('Something went wrong. Please try again.');
    } finally {
      isLoadingLogin = false;
      update();
    }
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

  /// <=============== Change passport related work are here ========================
  bool isChangePassword = false;
  final TextEditingController currentPasswordTEController =
      TextEditingController();
  final TextEditingController newPasswordTEController = TextEditingController();
  final TextEditingController confirmPasswordTEController =
      TextEditingController();

  void changePassword() async {
    isChangePassword = true;
    update();

    final request = {
      'currentPassword': currentPasswordTEController.text,
      'newPassword': newPasswordTEController.text,
    };

    final response = await ApiClient.postData(ApiUrls.changePassword, request);
    if (response.statusCode == 200) {
      await PrefsHelper.setString(
        AppConstants.bearerToken,
        response.body['accessToken'],
      );
      UserController().userData();
      showToast(response.body['message']);
      clearChangePasswordField();
    } else {
      showToast(response.body['message']);
    }

    isChangePassword = false;
    update();
  }

  void clearChangePasswordField() {
    confirmPasswordTEController.clear();
    newPasswordTEController.clear();
    currentPasswordTEController.clear();
  }

  /// <======================= Log out related work are here  ===========================>
  void logOut() async {
    await PrefsHelper.remove(AppConstants.bearerToken);

    await PrefsHelper.remove(AppConstants.role);
    await PrefsHelper.remove(AppConstants.bio);
    await PrefsHelper.remove(AppConstants.image);
    await PrefsHelper.remove(AppConstants.userId);
    await PrefsHelper.remove(AppConstants.email);
    await PrefsHelper.remove(AppConstants.name);
    await PrefsHelper.remove(AppConstants.phone);

    Get.find<UserController>().user = null;
    Get.find<AssignedController>().assignModel.clear();
    Get.find<SessionsController>().upComingSessionProfessionalList.clear();
    Get.find<SessionsController>().upComingSessionParentList.clear();
    Get.offAllNamed(AppRoutes.loginScreen);
  }

  /// <======================= Delete user Related work are here ===========================>
  Future<bool> deleteUser(String userID) async {
    bool flag = false;
    final response = await ApiClient.deleteData(ApiUrls.deleteUser(userID));
    if (response.statusCode == 200) {
      flag = true;
      PrefsHelper.remove(AppConstants.bearerToken);
      Get.offAllNamed(AppRoutes.signUpScreen);
    }
    return flag;
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
    currentPasswordTEController.dispose();
    newPasswordTEController.dispose();
    super.onClose();
  }
}
