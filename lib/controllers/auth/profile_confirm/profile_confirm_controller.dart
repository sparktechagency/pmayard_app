import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
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
  RxBool isPhoneValid = false.obs;

  PhoneNumber? phoneNumber;

  @override
  void onInit() {
    super.onInit();
    // FIX 2: Add listeners to trigger instant button updates
    nameParentController.addListener(() => update());
    childNameController.addListener(() => update());
    childGradeController.addListener(() => update());
    relationshipController.addListener(() => update());
  }

  @override
  void onClose() {
    // Dispose controllers
    nameController.dispose();
    numberController.dispose();
    bioController.dispose();
    qualificationController.dispose();
    subjectsController.dispose();
    nameParentController.dispose();
    numberParentController.dispose();
    childNameController.dispose();
    childGradeController.dispose();
    relationshipController.dispose();
    super.onClose();
  }

  void updatePhoneValidation(bool isValid) {
    isPhoneValid.value = isValid;
    update();
  }

  void updatePhoneNumber(PhoneNumber num) {
    phoneNumber = num;
    update();
  }

  void onTapProfileProfessionalSelected(BuildContext context) {
    PhotoPickerHelper.showPicker(
      context: context,
      onImagePicked: (image) {
        profileProfessional = File(image.path);
        update();
      },
    );
  }

  Future<void> profileConfirm() async {
    isLoading = true;
    update();

    List<MultipartBody>? multipartBody;
    if (profileProfessional != null) {
      multipartBody = [MultipartBody('image', profileProfessional ?? File(''))];
    }

    String fullPhoneNumber = phoneNumber?.phoneNumber ?? numberController.text.trim();

    final requestBody = {
      'data': jsonEncode({
        "name": nameController.text.trim(),
        "bio": bioController.text.trim(),
        "phoneNumber": fullPhoneNumber,
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


  PhoneNumber? phoneNumberParent;

  void onTapImageParentSelected(BuildContext context) {
    PhotoPickerHelper.showPicker(
      context: context,
      onImagePicked: (image) {
        profileParent = File(image.path);
        update();
      },
    );
  }


  void updatePhoneNumberParent(PhoneNumber phoneNumber) {
    phoneNumberParent = phoneNumber;
    update();
  }

  RxBool isPhoneValidParent = false.obs;

  void updatePhoneValidationParent(bool isValid) {
    isPhoneValidParent.value = isValid;
    update();
  }

  Future<void> profileConfirmParent() async {
    isLoadingParent = true;
    update();

    List<MultipartBody>? multipartBody;
    if (profileParent != null) {
      multipartBody = [MultipartBody('image', profileParent ?? File(''))];
    }


    String fullPhoneNumber = phoneNumberParent?.phoneNumber ?? numberParentController.text.trim();

    final requestBody = {
      'data': jsonEncode({
        "name": nameParentController.text.trim(),
        "phoneNumber": fullPhoneNumber,
        "childs_name": childNameController.text.trim(),
        "childs_grade": childGradeController.text.trim(),
        "relationship_with_child": relationshipController.text.trim(),
      }),
    };

    final response = await ApiClient.postMultipartData(
      ApiUrls.parentCreate,
      requestBody,
      multipartBody: multipartBody,
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