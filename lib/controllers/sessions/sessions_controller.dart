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
    getSessions();
  }

  // =================  Upcoming Sessions Related work are here ===============
  List<SessionParentModelData> sessionParentData = [];
  List<SessionProfessionalModelData> sessionProfessionalData = [];
  bool isLoadingSession = false;

  Future<void> getSessions() async {
    sessionParentData.clear();
    sessionProfessionalData.clear();

    final role = Get.find<UserController>().user?.role ?? '';
    isLoadingSession = true;
    update();

    try {
      final response = await ApiClient.getData(ApiUrls.upcomingSessions);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.body['data'] ?? [];
        if (role == 'professional') {
          sessionProfessionalData = data
              .map((e) => SessionProfessionalModelData.fromJson(e))
              .toList();
        } else {
          sessionParentData = data
              .map((e) => SessionParentModelData.fromJson(e))
              .toList();
        }
      }
    } finally {
      isLoadingSession = false;
      update();
    }
  }

  // =================  MY Sessions Related work are here =====================
  bool isLoadingMySection = false;
  List<MySessionParentModelData> mySessionParentData = [];
  List<MySessionProfessionalModelData> mySessionProfessionalData = [];

  Future<void> fetchMySection( String date ) async {
    mySessionProfessionalData.clear();
    mySessionParentData.clear();
    final role = Get.find<UserController>().user?.role ?? '';

    isLoadingMySection = true;
    update();

    final response = await ApiClient.getData(ApiUrls.sessionSearch(date));

    if (response.statusCode == 200) {
      final List data = response.body['data'] ?? [];

      if (role == 'parent') {
        final session = data
            .map((e) => MySessionParentModelData.fromJson(e))
            .toList();
        mySessionParentData.addAll(session);
        debugPrint(
          '=====================>>> parent ${mySessionParentData.length}',
        );
      } else {
        final session = data
            .map((e) => MySessionProfessionalModelData.fromJson(e))
            .toList();
        mySessionProfessionalData.addAll(session);
        debugPrint(
          '=====================>> >Professional ${mySessionProfessionalData.length}',
        );
      }
    }
    isLoadingMySection = false;
    update();
  }

  // =================  Selected Session Related work are here are here =====================
  bool isLoadingSelectedSession = false;

  Future<void> fetchSelectedSession(String date) async {
    try {
      isLoadingSelectedSession = true;
      final role = Get.find<UserController>().user?.role ?? '';
      update();
      final response = await ApiClient.getData(ApiUrls.sessionSearch(date));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.body['data'] ?? [];

        if (role == 'professional') {
          sessionProfessionalData = data
              .map((e) => SessionProfessionalModelData.fromJson(e))
              .toList();
        } else {
          sessionParentData = data
              .map((e) => SessionParentModelData.fromJson(e))
              .toList();
        }
      }
    } catch (err) {
      showToast('Something Went Wrong $err');
    } finally {
      isLoadingSelectedSession = false;
      update();
    }
  }

  bool isLoadingAssignViewProfile = false;
  AssignViewProfileModel? assignViewProfileModel;

  Future<void> fetchAssignViewProfile(String userId) async{
    isLoadingAssignViewProfile = true;
    update();

    final response = await ApiClient.getData(ApiUrls.sessionViewProfile(userId));
    if( response.statusCode == 200 ){
        final data = response.body['data'];
        assignViewProfileModel = AssignViewProfileModel.fromJson(data);
    }else{
      showToast('Something Went Wrong');
    }

    isLoadingAssignViewProfile = false;
    update();
  }
}
