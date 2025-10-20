import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/prefs_helper.dart';
import 'package:pmayard_app/app/utils/app_constants.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';
import '../../../services/api_urls.dart';

class ProfileConfirmController extends GetxController{



  bool isLoading = false;
  File? selectedImage;

  final TextEditingController numberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController subjectsController = TextEditingController();


  Future<void> profileConfirm() async {
    isLoading = true;
    update();

    final requestBody = {

    };

    final response = await ApiClient.postData(
      ApiUrls.register,
      requestBody,
      headers: {'Content-Type': 'application/json'},
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      await PrefsHelper.setString(AppConstants.bearerToken, responseBody['data']?['accessToken'] ?? '');
      Get.toNamed(AppRoutes.completeProfileFirstPage);
    } else {
      showToast(responseBody['message']);
    }
    isLoading = false;
    update();
  }
}