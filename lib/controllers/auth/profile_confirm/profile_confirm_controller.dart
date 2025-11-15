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
    /*
    *
    *

  /*
  *
  *
  *
  *
  {
        "name": "Dr. John Doe",
        "bio": "Experienced professional with expertise in various subjects.",
        "phoneNumber": "+1234567890",
        "qualification": "PhD in Mathematics",
        "subjects": [
            "Mathematics",
            "Physics"
        ],
        * IMAGE :
        *
        *
        *
        *
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
    }
  *
  * */
    *
    *
    *
    *
    * */
    final requestBody = {
      "name": nameController.text,
      "bio": bioController.text,
      "phoneNumber": "",
      "qualification": "PhD in Mathematics",
      "subjects": [
        "Mathematics",
        "Physics"
      ]
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