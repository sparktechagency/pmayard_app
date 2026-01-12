import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/models/assigned/assign_view_profile_model.dart';
import 'package:pmayard_app/models/session/my_session_parent_model.dart';
import 'package:pmayard_app/models/session/my_session_professional_model.dart';
import 'package:pmayard_app/models/session/upcomming_session_model.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';

class SessionsController extends GetxController {

  // =================  Upcoming Sessions (Using Models) ===============
  final RxList<UpComingSessionModel>upComingSession = <UpComingSessionModel>[].obs;
  final RxList<UpComingSessionModel> upComingSessionParentList = <UpComingSessionModel>[].obs;
  final RxList<UpComingSessionModel> upComingSessionProfessionalList = <UpComingSessionModel>[].obs;

  final isLoadingSession = false.obs;

  Future<void> getSessions() async {
    upComingSession.clear();
    upComingSessionParentList.clear();
    upComingSessionProfessionalList.clear();
    isLoadingSession.value = true;
    update();

    try {
      final response = await ApiClient.getData(ApiUrls.upcomingSessions);

      if (response.statusCode == 200) {
        final List<dynamic> datas = response.body['data'] ?? [];

        for (var item in datas) {
          // Convert JSON into your model
          final session = UpComingSessionModel.fromJson(item);

          // Add to main list
          upComingSession.add(session);

          // Add to role-specific lists
          if (session.parent != null) {
            upComingSessionParentList.add(session);
          }

          if (session.professional != null) {
            upComingSessionProfessionalList.add(session);
          }
        }

        print("✅ Sessions loaded: ${upComingSession.length}");
      } else {
        print("❌ API Error: ${response.statusCode}");
      }
    } catch (e) {
      print('❌ [SESSIONS] Error: $e');
    } finally {
      isLoadingSession.value = false;
      update();
    }
  }

  bool isLoadingTodaySessions = false;
  final RxList<UpComingSessionModel> todaySessionData = <UpComingSessionModel>[].obs;
  Future<void> fetchTodaySessions(String formatted) async{
    isLoadingTodaySessions = true;
    update();
    try {
      final response = await ApiClient.getData(ApiUrls.todaySessions(formatted));

      if (response.statusCode == 200) {
        final List<dynamic> datas = response.body['data'] ?? [];

        for (var item in datas) {
          final session = UpComingSessionModel.fromJson(item);
          todaySessionData.add(session);
        }

        print("✅ Sessions loaded: ${todaySessionData.length}");
      } else {
        print("❌ API Error: ${response.statusCode}");
      }
    } catch (e) {
      print('❌ [SESSIONS] Error: $e');
    } finally {
      isLoadingTodaySessions = false;
      update();
    }
  }

  // =================  MY Sessions (Using Raw Maps - No Models) =====================
  final isLoadingMySection = false.obs;
  final mySessionData = <Map<String, dynamic>>[].obs;

  final mySessionParentData = <MySessionParentModelData>[].obs;
  final mySessionProfessionalData = <MySessionProfessionalModelData>[].obs;

  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rxn<DateTime> selectedDay = Rxn<DateTime>();
  RxString stringDate = ''.obs;

  void onHandle(String date) {
    stringDate.value = date;
    fetchMySection(date);
  }

  Future<void> fetchMySection(String date) async {
    mySessionData.clear();
    mySessionParentData.clear();
    mySessionProfessionalData.clear();

    isLoadingMySection.value = true;
    update();

    try {
      final response = await ApiClient.getData(ApiUrls.sessionSearch(date));

      if (response.statusCode == 200) {
        final List<dynamic> data = response.body['data'] ?? [];
        mySessionData.assignAll(data.cast<Map<String, dynamic>>());
        debugPrint('Fetched  ${mySessionData.length} my sessions');
      }
    } catch (e) {
      print('Error fetching my sessions: $e');
    } finally {
      isLoadingMySection.value = false;
      update();
    }
  }

  // =================  Selected Session =====================
  final isLoadingSelectedSession = false.obs;
  
  
  
  
  /// =============>>> assignViewProfileData ==============>> 
  
  bool isLoadingAssignViewProfile = false;
  AssignViewProfileModel? assignViewProfileData;
  
  Future<void> fetchAssignViewProfile(String sessionID) async {
    assignViewProfileData = null;
    isLoadingAssignViewProfile = true;
    update();

      final response = await ApiClient.getData(ApiUrls.sessionViewProfile(sessionID));
      if (response.statusCode == 200) {
        assignViewProfileData = AssignViewProfileModel.fromJson(response.body['data']);
      }
      isLoadingAssignViewProfile = false;
      update();
  }

  // =================  Complete Session =====================
  final isChangeStatus = false.obs;

  Future<void> completeSessionDBHandler(String userID, String newStatus) async {
    isChangeStatus.value = true;

    try {
      final responseBody = {
        'status': newStatus,
      };

      final response = await ApiClient.patch(
        ApiUrls.completeSession(userID),
        responseBody,
      );

      if (response.statusCode == 200) {
        showToast('Session status updated successfully');
        await fetchMySection('');
        Get.back();
      } else {
        showToast('Failed to update session status');
      }
    } catch (e) {
      print('Error updating session: $e');
      showToast('Error: $e');
    } finally {
      isChangeStatus.value = false;
    }
  }
}
