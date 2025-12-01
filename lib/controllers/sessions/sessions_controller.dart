import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/models/session/assign_view_profile_model.dart';
import 'package:pmayard_app/models/session/my_session_parent_model.dart';
import 'package:pmayard_app/models/session/my_session_professional_model.dart';
import 'package:pmayard_app/models/session/session_professional_model_data.dart';
import 'package:pmayard_app/models/session/session_response_data.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';

class SessionsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Removed automatic API call from onInit to prevent duplicate calls
    // The UI will handle calling getSessions() explicitly
  }

  // =================  Upcoming Sessions Related work are here ===============
  final sessionParentData = <SessionParentModelData>[].obs;
  final sessionProfessionalData = <SessionProfessionalModelData>[].obs;
  final isLoadingSession = false.obs;

  Future<void> getSessions() async {
    sessionParentData.clear();
    sessionProfessionalData.clear();

    final userController = Get.find<UserController>();
    String role = userController.user?.role ?? '';

    // Wait if role is not loaded yet
    if (role.isEmpty) {
      // Wait a bit for the user data to load
      await Future.delayed(Duration(milliseconds: 100));
      role = userController.user?.role ?? '';
    }

    isLoadingSession.value = true;

    try {
      final response = await ApiClient.getData(ApiUrls.upcomingSessions);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.body['data'] ?? [];
        if (role == 'professional') {
          final professionalData = data
              .map((e) => SessionProfessionalModelData.fromJson(e))
              .toList();
          sessionProfessionalData.assignAll(professionalData);
        } else {
          final parentData = data
              .map((e) => SessionParentModelData.fromJson(e))
              .toList();
          sessionParentData.assignAll(parentData);
        }
      }
    } catch (e) {
      print('Error fetching sessions: $e');
    } finally {
      isLoadingSession.value = false;
    }
  }

  // =================  MY Sessions Related work are here =====================
  final isLoadingMySection = false.obs;
  final mySessionParentData = <MySessionParentModelData>[].obs;
  final mySessionProfessionalData = <MySessionProfessionalModelData>[].obs;

  Future<void> fetchMySection( String date ) async {
    mySessionProfessionalData.clear();
    mySessionParentData.clear();
    final role = Get.find<UserController>().user?.role ?? '';

    isLoadingMySection.value = true;

    final response = await ApiClient.getData(ApiUrls.sessionSearch(date));

    if (response.statusCode == 200) {
      final List data = response.body['data'] ?? [];

      if (role == 'parent') {
        final session = data
            .map((e) => MySessionParentModelData.fromJson(e))
            .toList();
        mySessionParentData.assignAll(session);
        debugPrint(
          '=====================>>> parent ${mySessionParentData.length}',
        );
      } else {
        final session = data
            .map((e) => MySessionProfessionalModelData.fromJson(e))
            .toList();
        mySessionProfessionalData.assignAll(session);
        debugPrint(
          '=====================>> >Professional ${mySessionProfessionalData.length}',
        );
      }
    }
    isLoadingMySection.value = false;
  }

  // =================  Selected Session Related work are here are here =====================
  final isLoadingSelectedSession = false.obs;

  Future<void> fetchSelectedSession(String date) async {
    try {
      isLoadingSelectedSession.value = true;
      final role = Get.find<UserController>().user?.role ?? '';
      final response = await ApiClient.getData(ApiUrls.sessionSearch(date));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.body['data'] ?? [];

        if (role == 'professional') {
          final professionalData = data
              .map((e) => SessionProfessionalModelData.fromJson(e))
              .toList();
          sessionProfessionalData.assignAll(professionalData);
        } else {
          final parentData = data
              .map((e) => SessionParentModelData.fromJson(e))
              .toList();
          sessionParentData.assignAll(parentData);
        }
      }
    } catch (err) {
      showToast('Something Went Wrong $err');
    } finally {
      isLoadingSelectedSession.value = false;
    }
  }

  final isLoadingAssignViewProfile = false.obs;
  AssignViewProfileModel? assignViewProfileModel;

  Future<void> fetchAssignViewProfile(String userId) async{
    isLoadingAssignViewProfile.value = true;

    final response = await ApiClient.getData(ApiUrls.sessionViewProfile(userId));
    if( response.statusCode == 200 ){
        final data = response.body['data'];
        assignViewProfileModel = AssignViewProfileModel.fromJson(data);
    }else{
      showToast('Something Went Wrong');
    }

    isLoadingAssignViewProfile.value = false;
  }



  final isChangeStatus = false.obs;

  Future<void> completeSessionDBHandler(String userID, String status) async {
    isChangeStatus.value = true;

    final responseBody = {
      'status': status,
    };

    final response = await ApiClient.patch(
      ApiUrls.completeSession(userID),
      responseBody,
    );

    if (response.statusCode == 200) {
      print( response.status);

    } else {
      showToast('Something Went Wrong');
    }
    isChangeStatus.value = false;
  }

}
