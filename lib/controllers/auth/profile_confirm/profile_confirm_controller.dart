import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/photo_picker_helper.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';
import '../../../services/api_urls.dart';

class ProfileConfirmController extends GetxController {


  /// ========================>>> profile confirm for Professional =======================>>>

  bool isLoading = false;
  File? profileProfessional;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController subjectsController = TextEditingController();
  final List<String> subjectList = [];
  List<Map<String, dynamic>> availability = [];
  DateTime? selectedDate;

  void onTapProfileProfessionalSelected (BuildContext context){
    PhotoPickerHelper.showPicker(context: context, onImagePicked: (image){
      profileProfessional = File(image.path);
      update();
    });
  }


  Future<void> profileConfirm() async {
    isLoading = true;
    update();

    List<MultipartBody>? multipartBody;
    if (profileProfessional != null) {
      multipartBody = [MultipartBody('image', profileProfessional ?? File(''))];
    }

    final requestBody = {
      'data': jsonEncode({
        "name": nameController.text.trim(),
        "bio": bioController.text.trim(),
        "phoneNumber": numberController.text.trim(),
        "qualification": qualificationController.text.trim(),
        "subjects": subjectList.toList(),
        "availability": availability,
      }),
    };

    final response = await ApiClient.postMultipartData(
      ApiUrls.professionalCreate,
      multipartBody: multipartBody,
      requestBody,
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      Get.find<UserController>().userData();
      Get.offAllNamed(AppRoutes.customBottomNavBar);
    } else {
      showToast(responseBody['message']);
    }

    isLoading = false;
    update();
  }


  /// ========================>>> profile confirm for Parent =======================>>>

bool isLoadingParent = false;

  final TextEditingController nameParentController = TextEditingController();
  final TextEditingController numberParentController = TextEditingController();
  final TextEditingController childNameController = TextEditingController();
  final TextEditingController childGradeController = TextEditingController();
  final TextEditingController relationshipController = TextEditingController();


  File? profileParent;

 void onTapImageParentSelected (BuildContext context){
  PhotoPickerHelper.showPicker(context: context, onImagePicked: (image){
    profileParent = File(image.path);
    update();
  });
}

  Future<void> profileConfirmParent() async {
    isLoadingParent = true;
    update();


    List<MultipartBody>? multipartBody;
    if (profileParent != null) {
      multipartBody = [MultipartBody('image', profileParent ?? File(''))];
    }

    final requestBody = {
      'data': jsonEncode({
        "name": nameParentController.text.trim(),
        "phoneNumber": numberParentController.text.trim(),
        "childs_name": childNameController.text.trim(),
        "childs_grade": childGradeController.text.trim(),
        "relationship_with_child": relationshipController.text.trim(),
      }),
    };


    final response = await ApiClient.postMultipartData(
      ApiUrls.parentCreate,
      requestBody,
      multipartBody: multipartBody
    );
    final responseBody = response.body;

    if (response.statusCode == 200) {
      Get.find<UserController>().userData();
      update();
      Get.offAllNamed(AppRoutes.customBottomNavBar);
    } else {
      showToast(responseBody['message']);
    }

    isLoadingParent = false;
    update();
  }


}