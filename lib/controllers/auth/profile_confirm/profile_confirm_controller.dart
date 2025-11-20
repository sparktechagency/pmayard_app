import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/photo_picker_helper.dart';
import 'package:pmayard_app/app/helpers/prefs_helper.dart';
import 'package:pmayard_app/app/utils/app_constants.dart';
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
  DateTime? selectedDate;
  final String startTime = "";
  final String endTime = "";


  Future<void> profileConfirm() async {
    isLoading = true;
    update();

    List<MultipartBody>? multipartBody;
    if (profileProfessional != null) {
      multipartBody = [MultipartBody('image', profileProfessional ?? File(''))];
    }

    final requestBody = {
      'data': jsonEncode({
        "name": "Dr. John Doe",
        "bio": "Experienced professional with expertise in various subjects.",
        "phoneNumber": "+1234567890",
        "qualification": "PhD in Mathematics",
        "subjects": [
          "Mathematics",
          "Physics"
        ],
        "availability": [
          {
            "day": "Monday",
            "timeSlots": [
              {
                "startTime": "09:00 AM",
                "endTime": "10:00 AM",
                "status": "available"
              },
              {
                "startTime": "11:00 AM",
                "endTime": "12:00 PM",
                "status": "booked"
              }
            ]
          },
          {
            "day": "Tuesday",
            "timeSlots": [
              {
                "startTime": "01:00 PM",
                "endTime": "02:00 PM",
                "status": "available"
              },
              {
                "startTime": "03:00 PM",
                "endTime": "04:00 PM",
                "status": "disabled"
              }
            ]
          }
        ]
      }),
    };

    final response = await ApiClient.postMultipartData(
      ApiUrls.register,
      multipartBody: multipartBody,
      requestBody,
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
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
      Get.offAllNamed(AppRoutes.customBottomNavBar);
    } else {
      showToast(responseBody['message']);
    }
    isLoadingParent = false;
    update();
  }


}